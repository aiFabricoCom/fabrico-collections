#!/usr/bin/env bash

set -euo pipefail

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)"
TMP="$(mktemp -d "${TMPDIR:-/tmp}/fabrico-install-test.XXXXXX")"
TMP="$(CDPATH= cd -- "$TMP" && pwd -P)"
trap 'rm -rf "$TMP"' EXIT

fail() {
  printf 'installer test failed: %s\n' "$*" >&2
  exit 1
}

assert_contains() {
  case "$1" in
    *"$2"*) ;;
    *) fail "expected output to contain: $2" ;;
  esac
}

fixture="$TMP/archive/fabrico-fixture"
mkdir -p "$fixture/.codex"
cp -R "$ROOT/skills" "$fixture/skills"
cp -R "$ROOT/.codex/agents" "$fixture/.codex/agents"
cp "$ROOT/.codex/config.toml" "$fixture/.codex/config.toml"
tar -czf "$TMP/fabrico.tar.gz" -C "$TMP/archive" fabrico-fixture

fakebin="$TMP/fakebin"
mkdir -p "$fakebin"
cat >"$fakebin/curl" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
exec /bin/cat "${FABRICO_TEST_ARCHIVE:?}"
EOF
cat >"$fakebin/codex" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

state="${FABRICO_TEST_CODEX_STATE:?}"
log="${FABRICO_TEST_CODEX_LOG:?}"
mkdir -p "$state"
printf '%s|%s\n' "$PWD" "$*" >>"$log"

[ "${1:-}" = "mcp" ] || exit 2
action="${2:-}"
name="${3:-}"
record="$state/$name.json"

case "$action" in
  get)
    [ -f "$record" ] || exit 1
    if [ "${4:-}" = "--json" ]; then
      /bin/cat "$record"
    fi
    ;;
  add)
    printf '{"name":"%s"}\n' "$name" >"$record"
    ;;
  remove)
    rm -f "$record"
    ;;
  *)
    exit 2
    ;;
esac
EOF
chmod +x "$fakebin/curl" "$fakebin/codex"

test_home="$TMP/home"
mkdir -p "$test_home"

run_project() {
  HOME="$test_home" \
  FABRICO_TEST_ARCHIVE="$TMP/fabrico.tar.gz" \
  PATH="$fakebin:$PATH" \
  bash "$ROOT/install.sh" "$@"
}

project_existing="$TMP/projects/existing"
mkdir -p "$project_existing/.codex"
cat >"$project_existing/.codex/config.toml" <<'EOF'
[agents] # keep this comment
max_threads = 3
max_depth = 1
EOF
cp "$project_existing/.codex/config.toml" "$TMP/existing.expected"
output="$(run_project --project "$project_existing")"
cmp -s "$TMP/existing.expected" "$project_existing/.codex/config.toml" \
  || fail "standard existing TOML was modified"
assert_contains "$output" "Raise it to 2"
assert_contains "$output" "Raise it to 6"

cat >"$project_existing/.codex/config.toml" <<'EOF'
agents = { max_threads = 6, max_depth = 2 }
EOF
cp "$project_existing/.codex/config.toml" "$TMP/inline.expected"
output="$(run_project --project "$project_existing")"
cmp -s "$TMP/inline.expected" "$project_existing/.codex/config.toml" \
  || fail "inline-table TOML was modified"
case "$output" in
  *"agents.max_"*) fail "inline-table TOML produced a false agent-setting warning" ;;
esac

cat >"$project_existing/.codex/config.toml" <<'EOF'
agents.max_threads = 6
agents.max_depth = 2
EOF
output="$(run_project --project "$project_existing")"
case "$output" in
  *"agents.max_"*) fail "top-level dotted agent settings produced a false warning" ;;
esac

cat >"$project_existing/.codex/config.toml" <<'EOF'
["agents"]
max_threads = 6
max_depth = 2
EOF
output="$(run_project --project "$project_existing")"
case "$output" in
  *"agents.max_"*) fail "quoted agents table produced a false warning" ;;
esac

cat >"$project_existing/.codex/config.toml" <<'EOF'
[unrelated]
agents.max_threads = 6
agents.max_depth = 2
EOF
cp "$project_existing/.codex/config.toml" "$TMP/nested-dotted.expected"
output="$(run_project --project "$project_existing")"
cmp -s "$TMP/nested-dotted.expected" "$project_existing/.codex/config.toml" \
  || fail "nested dotted-key TOML was modified"
assert_contains "$output" "Ensure its agents table sets max_depth = 2"
assert_contains "$output" "Ensure its agents table sets max_threads = 6"

cat >"$project_existing/.codex/config.toml" <<'EOF'
agents = { max_threads = 3, hint_threads = "max_threads = 6", max_depth = 1, hint_depth = "max_depth = 2" }
EOF
cp "$project_existing/.codex/config.toml" "$TMP/inline-hints.expected"
output="$(run_project --project "$project_existing")"
cmp -s "$TMP/inline-hints.expected" "$project_existing/.codex/config.toml" \
  || fail "inline-table TOML with strings was modified"
assert_contains "$output" "Ensure its agents table sets max_depth = 2"
assert_contains "$output" "Ensure its agents table sets max_threads = 6"

project_link="$TMP/projects/config-link"
mkdir -p "$project_link/.codex"
outside_config="$TMP/outside-config.toml"
ln -s "$outside_config" "$project_link/.codex/config.toml"
run_project --project "$project_link" >/dev/null
[ -L "$project_link/.codex/config.toml" ] || fail "config symlink was replaced"
[ ! -e "$outside_config" ] || fail "dangling config symlink target was written"

project_codex_link="$TMP/projects/codex-link"
outside_codex="$TMP/outside-codex"
mkdir -p "$project_codex_link" "$outside_codex"
ln -s "$outside_codex" "$project_codex_link/.codex"
if run_project --project "$project_codex_link" >/dev/null 2>&1; then
  fail "project .codex symlink was accepted"
fi
[ ! -e "$outside_codex/config.toml" ] || fail "project .codex symlink redirected config outside the project"

project_agents_link="$TMP/projects/agents-link"
outside_agents="$TMP/outside-agents"
mkdir -p "$project_agents_link" "$outside_agents"
ln -s "$outside_agents" "$project_agents_link/.agents"
if run_project --project "$project_agents_link" >/dev/null 2>&1; then
  fail "out-of-project .agents symlink was accepted"
fi
[ -z "$(find "$outside_agents" -mindepth 1 -print -quit)" ] || fail "out-of-project .agents target was changed"

project_root_skill_link="$TMP/projects/root-skill-link"
mkdir -p "$project_root_skill_link/.agents" "$project_root_skill_link/fabrico-product"
printf 'keep\n' >"$project_root_skill_link/fabrico-product/sentinel"
ln -s .. "$project_root_skill_link/.agents/skills"
if run_project --project "$project_root_skill_link" --uninstall >/dev/null 2>&1; then
  fail "skills symlink to the project root was accepted"
fi
[ -f "$project_root_skill_link/fabrico-product/sentinel" ] || fail "project-root skills symlink deleted product data"

project_skill_link="$TMP/projects/skill-link"
mkdir -p "$project_skill_link/.agents" "$project_skill_link/skills"
ln -s ../skills "$project_skill_link/.agents/skills"
run_project --project "$project_skill_link" >/dev/null
[ "$(find "$project_skill_link/skills" -mindepth 1 -maxdepth 1 -type d -name 'fabrico-*' | wc -l | tr -d ' ')" -eq 65 ] \
  || fail "project skills symlink did not receive the installed skills"
run_project --project "$project_skill_link" --uninstall >/dev/null
[ "$(find "$project_skill_link/skills" -mindepth 1 -maxdepth 1 -type d -name 'fabrico-*' | wc -l | tr -d ' ')" -eq 0 ] \
  || fail "uninstall did not clean a project-local skills symlink target"

project_state_link="$TMP/projects/state-link"
outside_state="$TMP/outside-state"
state_codex_home="$TMP/state-codex-home"
mkdir -p "$project_state_link/.codex" "$outside_state" "$state_codex_home"
printf 'sentinel\n' >"$outside_state/sentinel"
ln -s "$outside_state" "$state_codex_home/fabrico-collections"
if HOME="$test_home" CODEX_HOME="$state_codex_home" FABRICO_TEST_ARCHIVE="$TMP/fabrico.tar.gz" \
  PATH="$fakebin:$PATH" bash "$ROOT/install.sh" --project "$project_state_link" >/dev/null 2>&1; then
  fail "state-directory symlink was accepted"
fi
[ ! -e "$project_state_link/.codex/config.toml" ] || fail "config was written before unsafe state rejection"
[ ! -d "$project_state_link/.agents/skills" ] || fail "skills were copied before unsafe state rejection"
[ "$(cat "$outside_state/sentinel")" = "sentinel" ] || fail "outside state target changed"

project_forged="$TMP/projects/forged-owner"
mkdir -p "$project_forged/.codex/fabrico-collections"
printf 'project_name = "user-owned"\n' >"$project_forged/.codex/config.toml"
cp "$project_forged/.codex/config.toml" "$project_forged/.codex/fabrico-collections/project-config.toml"
run_project --project "$project_forged" --uninstall --mcp >/dev/null
[ -f "$project_forged/.codex/config.toml" ] || fail "untrusted snapshot removed a user-owned config"

project_new="$TMP/projects/new"
mkdir -p "$project_new"
output="$(run_project --project "$project_new")"
[ -f "$project_new/.codex/config.toml" ] || fail "new project config was not created"
project_new_key="$(printf '%s' "$project_new/.codex/config.toml" | cksum | awk '{ print $1 "-" $2 }')"
project_new_state="$test_home/.codex/fabrico-collections/project-configs/$project_new_key"
cmp -s "$project_new/.codex/config.toml" "$project_new_state/project-config.toml" \
  || fail "new project config snapshot differs"
[ -f "$project_new_state/config-owner-v1" ] || fail "new project config owner marker is missing"
assert_contains "$output" "--project $project_new --uninstall --mcp"
run_project --project "$project_new" --uninstall --mcp >/dev/null
[ ! -e "$project_new/.codex/config.toml" ] || fail "unchanged project config was not removed"
[ ! -e "$project_new_state" ] || fail "project config ownership state was not cleaned"

project_mcp_existing="$TMP/projects/mcp-existing"
mkdir -p "$project_mcp_existing/.codex"
printf 'project_name = "keep"\n' >"$project_mcp_existing/.codex/config.toml"
cp "$project_mcp_existing/.codex/config.toml" "$TMP/mcp-existing.expected"
output="$(run_project --project "$project_mcp_existing" --mcp --ref feature/test)"
cmp -s "$TMP/mcp-existing.expected" "$project_mcp_existing/.codex/config.toml" \
  || fail "project --mcp overwrote existing config"
assert_contains "$output" "https://raw.githubusercontent.com/aiFabricoCom/fabrico-collections/feature/test/.codex/config.toml"

project_custom="$TMP/projects/custom-state"
project_custom_codex_home="$TMP/project-custom-codex-home"
mkdir -p "$project_custom" "$project_custom_codex_home"
output="$(HOME="$test_home" CODEX_HOME="$project_custom_codex_home" \
  FABRICO_TEST_ARCHIVE="$TMP/fabrico.tar.gz" PATH="$fakebin:$PATH" \
  bash "$ROOT/install.sh" --project "$project_custom")"
assert_contains "$output" "CODEX_HOME=$project_custom_codex_home bash -s -- --project $project_custom --uninstall --mcp"
project_custom_key="$(printf '%s' "$project_custom/.codex/config.toml" | cksum | awk '{ print $1 "-" $2 }')"
project_custom_state="$project_custom_codex_home/fabrico-collections/project-configs/$project_custom_key"
[ -f "$project_custom_state/config-owner-v1" ] || fail "custom CODEX_HOME did not receive project ownership state"
HOME="$test_home" CODEX_HOME="$project_custom_codex_home" FABRICO_TEST_ARCHIVE="$TMP/fabrico.tar.gz" \
  PATH="$fakebin:$PATH" bash "$ROOT/install.sh" --project "$project_custom" --uninstall --mcp >/dev/null
[ ! -e "$project_custom/.codex/config.toml" ] || fail "custom CODEX_HOME project uninstall left config behind"
[ ! -e "$project_custom_state" ] || fail "custom CODEX_HOME project uninstall orphaned ownership state"

no_codex_home="$TMP/no-codex-home"
fakebin_no_codex="$TMP/fakebin-no-codex"
mkdir -p "$no_codex_home" "$fakebin_no_codex"
cp "$fakebin/curl" "$fakebin_no_codex/curl"
if HOME="$no_codex_home" FABRICO_TEST_ARCHIVE="$TMP/fabrico.tar.gz" \
  PATH="$fakebin_no_codex:/usr/bin:/bin:/usr/sbin:/sbin" \
  /bin/bash "$ROOT/install.sh" --global --mcp >/dev/null 2>&1; then
  fail "global --mcp succeeded without codex"
fi
[ ! -e "$no_codex_home/.agents/skills" ] || fail "skills were copied before the codex preflight"
[ ! -e "$no_codex_home/.codex/agents" ] || fail "agents were copied before the codex preflight"

global_home="$TMP/global-home"
custom_codex_home="$TMP/custom-codex-home"
codex_state="$TMP/codex-state"
codex_log="$TMP/codex.log"
project_cwd="$TMP/project-cwd"
mkdir -p "$global_home" "$project_cwd"
: >"$codex_log"

run_global() {
  HOME="$global_home" \
  CODEX_HOME="$custom_codex_home" \
  FABRICO_TEST_ARCHIVE="$TMP/fabrico.tar.gz" \
  FABRICO_TEST_CODEX_STATE="$codex_state" \
  FABRICO_TEST_CODEX_LOG="$codex_log" \
  PATH="$fakebin:$PATH" \
  bash "$ROOT/install.sh" "$@"
}

output="$(cd "$project_cwd" && run_global --global --mcp)"
[ -f "$custom_codex_home/config.toml" ] || fail "custom CODEX_HOME config was not created"
[ -f "$custom_codex_home/agents/fabrico-engineering-manager.toml" ] || fail "agents ignored custom CODEX_HOME"
[ ! -e "$global_home/.codex/agents/fabrico-engineering-manager.toml" ] || fail "agents leaked into default CODEX_HOME"
[ "$(find "$codex_state" -type f -name '*.json' | wc -l | tr -d ' ')" -eq 11 ] \
  || fail "global --mcp did not register the complete bundle"
expected_mcp_names="$(python3 - "$ROOT/.mcp.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as source:
    print("\n".join(sorted(json.load(source)["mcpServers"])))
PY
)"
actual_mcp_names="$(find "$codex_state" -type f -name '*.json' -exec basename {} .json \; | sort)"
[ "$actual_mcp_names" = "$expected_mcp_names" ] || fail "global installer MCP names differ from .mcp.json"
if grep -Fq "$project_cwd|" "$codex_log"; then
  fail "global MCP command ran from the project working directory"
fi
assert_contains "$output" "CODEX_HOME=$custom_codex_home bash -s -- --uninstall --mcp"

run_global --global --uninstall --mcp >/dev/null
[ ! -e "$custom_codex_home/config.toml" ] || fail "unchanged global config was not removed"
[ "$(find "$codex_state" -type f -name '*.json' | wc -l | tr -d ' ')" -eq 0 ] \
  || fail "tracked global MCP entries were not removed"

printf 'installer behavior checks passed\n'
