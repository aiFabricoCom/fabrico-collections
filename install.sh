#!/usr/bin/env bash
#
# Fabrico Collections installer for Codex
#
#   curl -fsSL https://raw.githubusercontent.com/aiFabricoCom/fabrico-collections/main/install.sh | bash
#
# Options (when piping, pass after `bash -s --`):
#   --global           Install skills and agents for the current user (default)
#   --project [DIR]    Install into one project's .agents/ and .codex/ directories
#   --mcp              Configure the bundled MCP servers when it is safe to do so
#   --ref REF          Install a branch, tag, or commit (default: main)
#   --uninstall        Remove Fabrico artifacts; with --mcp, remove unchanged installer-owned config
#   --help
#
set -euo pipefail

REPO="aiFabricoCom/fabrico-collections"
REF="main"
MODE="global"
PROJECT_DIR=""
DO_MCP="0"
ACTION="install"

if [ -t 1 ]; then
  B=$'\033[1m'; G=$'\033[32m'; Y=$'\033[33m'; C=$'\033[36m'; D=$'\033[90m'; R=$'\033[0m'
else
  B=""; G=""; Y=""; C=""; D=""; R=""
fi

say()  { printf '%s\n' "$*"; }
ok()   { printf "  ${G}✓${R} %s\n" "$*"; }
warn() { printf "  ${Y}!${R} %s\n" "$*"; }
die()  { printf "${Y}✗ %s${R}\n" "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

usage() {
  cat <<'EOF'
Fabrico Collections installer for Codex

  curl -fsSL https://raw.githubusercontent.com/aiFabricoCom/fabrico-collections/main/install.sh | bash

Options (when piping, pass after `bash -s --`):
  --global          Install into ~/.agents/skills and ~/.codex/agents (default)
  --project [DIR]   Install into DIR/.agents/skills and DIR/.codex/agents
  --mcp             Configure bundled MCP servers; existing entries are preserved
  --ref REF         Install a branch, tag, or commit (default: main)
  --uninstall       Remove Fabrico artifacts; with --mcp, remove unchanged installer-owned config
  --help
EOF
  exit 0
}

while [ $# -gt 0 ]; do
  case "$1" in
    --global)
      MODE="global"
      ;;
    --project)
      MODE="project"
      if [ $# -gt 1 ] && [ "${2#-}" = "${2:-}" ] && [ -n "${2:-}" ]; then
        PROJECT_DIR="$2"
        shift
      fi
      ;;
    --mcp)
      DO_MCP="1"
      ;;
    --ref)
      shift
      [ $# -gt 0 ] || die "--ref requires a value"
      REF="$1"
      ;;
    --uninstall)
      ACTION="uninstall"
      ;;
    -h|--help)
      usage
      ;;
    *)
      die "Unknown option: $1 (try --help)"
      ;;
  esac
  shift
done

USER_CODEX_ROOT="${CODEX_HOME:-$HOME/.codex}"
case "$USER_CODEX_ROOT" in
  /*) ;;
  *) USER_CODEX_ROOT="$PWD/$USER_CODEX_ROOT" ;;
esac

if [ "$MODE" = "global" ]; then
  ROOT="$HOME"
  CODEX_ROOT="$USER_CODEX_ROOT"
  SKILLS_DEST="$HOME/.agents/skills"
  AGENTS_DEST="$CODEX_ROOT/agents"
  CONFIG_DEST="$CODEX_ROOT/config.toml"
else
  ROOT="${PROJECT_DIR:-$PWD}"
  if [ "$ACTION" = "install" ]; then
    mkdir -p "$ROOT"
  fi
  [ -d "$ROOT" ] || die "Project directory does not exist: $ROOT"
  ROOT="$(CDPATH= cd -- "$ROOT" && pwd -P)"
  CODEX_ROOT="$ROOT/.codex"
  SKILLS_DEST="$ROOT/.agents/skills"
  AGENTS_DEST="$CODEX_ROOT/agents"
  CONFIG_DEST="$CODEX_ROOT/config.toml"
fi

COLLECTION_STATE_ROOT="$USER_CODEX_ROOT/fabrico-collections"
STATE_PARENT=""
if [ "$MODE" = "project" ]; then
  case "$ROOT" in
    *$'\n'*) die "Project paths containing newlines are not supported." ;;
  esac
  PROJECT_STATE_KEY="$(printf '%s' "$CONFIG_DEST" | cksum | awk '{ print $1 "-" $2 }')"
  STATE_PARENT="$COLLECTION_STATE_ROOT/project-configs"
  STATE_ROOT="$STATE_PARENT/$PROJECT_STATE_KEY"
else
  STATE_ROOT="$COLLECTION_STATE_ROOT"
fi
MCP_STATE_DIR="$STATE_ROOT/mcp"
PROJECT_CONFIG_SNAPSHOT="$STATE_ROOT/project-config.toml"
CONFIG_OWNER_RECORD="$STATE_ROOT/config-owner-v1"
CONFIG_SOURCE_URL="https://raw.githubusercontent.com/$REPO/$REF/.codex/config.toml"

count_skills() {
  find -H "$1" -mindepth 1 -maxdepth 1 -type d -name 'fabrico-*' 2>/dev/null | wc -l | tr -d ' '
}

count_agents() {
  find -H "$1" -mindepth 1 -maxdepth 1 -type f -name 'fabrico-*.toml' 2>/dev/null | wc -l | tr -d ' '
}

assert_project_directory_scope() {
  local path="$1"
  local label="$2"
  local expected_primary="$3"
  local expected_secondary="${4:-}"
  local resolved

  if [ -L "$path" ] && [ ! -d "$path" ]; then
    die "Refusing dangling $label symlink: $path"
  fi
  [ -d "$path" ] || return 0

  resolved="$(CDPATH= cd -- "$path" && pwd -P)"
  if [ "$resolved" != "$expected_primary" ] && { [ -z "$expected_secondary" ] || [ "$resolved" != "$expected_secondary" ]; }; then
    die "Refusing unexpected $label path: $path -> $resolved"
  fi
}

validate_project_paths() {
  [ "$MODE" = "project" ] || return 0

  if [ -L "$CODEX_ROOT" ]; then
    die "Refusing project .codex symlink: $CODEX_ROOT"
  fi
  assert_project_directory_scope "$ROOT/.agents" ".agents" "$ROOT/.agents" "$ROOT"
  assert_project_directory_scope "$SKILLS_DEST" "skills destination" "$ROOT/.agents/skills" "$ROOT/skills"
  assert_project_directory_scope "$AGENTS_DEST" "agents destination" "$ROOT/.codex/agents"
}

remove_empty_state_dirs() {
  rmdir "$MCP_STATE_DIR" 2>/dev/null || true
  rmdir "$STATE_ROOT" 2>/dev/null || true
  if [ -n "$STATE_PARENT" ]; then
    rmdir "$STATE_PARENT" 2>/dev/null || true
    rmdir "$COLLECTION_STATE_ROOT" 2>/dev/null || true
  fi
}

ensure_safe_state_dir() {
  if [ -L "$COLLECTION_STATE_ROOT" ] || { [ -e "$COLLECTION_STATE_ROOT" ] && [ ! -d "$COLLECTION_STATE_ROOT" ]; }; then
    die "Refusing unsafe collection state path: $COLLECTION_STATE_ROOT"
  fi
  if [ -n "$STATE_PARENT" ] && { [ -L "$STATE_PARENT" ] || { [ -e "$STATE_PARENT" ] && [ ! -d "$STATE_PARENT" ]; }; }; then
    die "Refusing unsafe project-state path: $STATE_PARENT"
  fi
  if [ -L "$STATE_ROOT" ] || { [ -e "$STATE_ROOT" ] && [ ! -d "$STATE_ROOT" ]; }; then
    die "Refusing unsafe state path: $STATE_ROOT"
  fi
  mkdir -p "$STATE_ROOT"
  chmod 700 "$STATE_ROOT"

  if [ -L "$MCP_STATE_DIR" ] || { [ -e "$MCP_STATE_DIR" ] && [ ! -d "$MCP_STATE_DIR" ]; }; then
    die "Refusing unsafe MCP state path: $MCP_STATE_DIR"
  fi
}

validate_config_record_paths() {
  local expected_owner

  ensure_safe_state_dir
  if [ -L "$PROJECT_CONFIG_SNAPSHOT" ] || { [ -e "$PROJECT_CONFIG_SNAPSHOT" ] && [ ! -f "$PROJECT_CONFIG_SNAPSHOT" ]; }; then
    die "Refusing unsafe config ownership record: $PROJECT_CONFIG_SNAPSHOT"
  fi
  if [ -L "$CONFIG_OWNER_RECORD" ] || { [ -e "$CONFIG_OWNER_RECORD" ] && [ ! -f "$CONFIG_OWNER_RECORD" ]; }; then
    die "Refusing unsafe config owner marker: $CONFIG_OWNER_RECORD"
  fi
  expected_owner="$(printf 'fabrico-collections-config-owner-v1\n%s' "$CONFIG_DEST")"
  if [ -f "$CONFIG_OWNER_RECORD" ] && [ "$(cat "$CONFIG_OWNER_RECORD")" != "$expected_owner" ]; then
    die "Config ownership record belongs to another path: $CONFIG_OWNER_RECORD"
  fi
}

record_config_snapshot() {
  local pending
  local pending_owner

  validate_config_record_paths

  pending="$(mktemp "$STATE_ROOT/.project-config.toml.XXXXXX")"
  pending_owner="$(mktemp "$STATE_ROOT/.config-owner.XXXXXX")"
  cp "$CONFIG_DEST" "$pending"
  printf 'fabrico-collections-config-owner-v1\n%s\n' "$CONFIG_DEST" >"$pending_owner"
  mv -f "$pending" "$PROJECT_CONFIG_SNAPSHOT"
  mv -f "$pending_owner" "$CONFIG_OWNER_RECORD"
}

has_config_ownership() {
  local expected_owner

  expected_owner="$(printf 'fabrico-collections-config-owner-v1\n%s' "$CONFIG_DEST")"
  [ -f "$PROJECT_CONFIG_SNAPSHOT" ] && [ ! -L "$PROJECT_CONFIG_SNAPSHOT" ] \
    && [ -f "$CONFIG_OWNER_RECORD" ] && [ ! -L "$CONFIG_OWNER_RECORD" ] \
    && [ "$(cat "$CONFIG_OWNER_RECORD")" = "$expected_owner" ]
}

remove_tracked_global_mcp() {
  if [ ! -d "$MCP_STATE_DIR" ]; then
    return
  fi

  if [ -L "$STATE_ROOT" ] || [ -L "$MCP_STATE_DIR" ]; then
    warn "Unsafe Fabrico MCP ownership path detected — left all MCP entries untouched."
    return
  fi

  if ! have codex; then
    warn "codex is unavailable — left tracked MCP entries and their ownership record untouched."
    return
  fi

  current="$(mktemp /tmp/fabrico-mcp.XXXXXX)"
  mcp_workdir="$(mktemp -d /tmp/fabrico-mcp-cwd.XXXXXX)"
  for name in \
    aws-api aws-documentation \
    gcp-gcloud gcp-observability gcp-storage playwright context7 \
    sequential-thinking figma atlassian pdf-reader
  do
    snapshot="$MCP_STATE_DIR/$name.json"
    [ -f "$snapshot" ] || continue

    if ! (cd "$mcp_workdir" && codex mcp get "$name" --json) >"$current" 2>/dev/null; then
      rm -f "$snapshot"
      warn "Tracked MCP server $name no longer exists."
    elif ! cmp -s "$snapshot" "$current"; then
      rm -f "$snapshot"
      warn "MCP server $name changed after installation — left untouched and released ownership."
    elif (cd "$mcp_workdir" && codex mcp remove "$name") >/dev/null 2>&1; then
      rm -f "$snapshot"
      ok "Removed tracked MCP $name"
    else
      warn "Could not remove tracked MCP server $name; kept its ownership record for a retry."
    fi
  done
  rm -f "$current"
  rm -rf "$mcp_workdir"
  remove_empty_state_dirs
}

remove_tracked_config() {
  if [ -L "$COLLECTION_STATE_ROOT" ] || { [ -n "$STATE_PARENT" ] && [ -L "$STATE_PARENT" ]; } || [ -L "$STATE_ROOT" ]; then
    warn "Unsafe Fabrico config ownership path detected — left $CONFIG_DEST untouched."
    return
  fi

  if ! has_config_ownership; then
    if [ -e "$PROJECT_CONFIG_SNAPSHOT" ] || [ -L "$PROJECT_CONFIG_SNAPSHOT" ]; then
      warn "Untrusted or incomplete Fabrico config ownership record — left $CONFIG_DEST untouched."
    fi
    return
  fi

  if [ ! -e "$CONFIG_DEST" ]; then
    rm -f "$PROJECT_CONFIG_SNAPSHOT" "$CONFIG_OWNER_RECORD"
    warn "Tracked project config no longer exists."
  elif [ -L "$CONFIG_DEST" ] || ! cmp -s "$PROJECT_CONFIG_SNAPSHOT" "$CONFIG_DEST"; then
    rm -f "$PROJECT_CONFIG_SNAPSHOT" "$CONFIG_OWNER_RECORD"
    warn "$CONFIG_DEST changed after installation — left untouched and released ownership."
  else
    rm -f "$CONFIG_DEST" "$PROJECT_CONFIG_SNAPSHOT" "$CONFIG_OWNER_RECORD"
    ok "Removed unchanged installer-owned configuration."
  fi
  remove_empty_state_dirs
}

remove_artifacts() {
  say "Removing Fabrico artifacts from ${C}$ROOT${R}"
  find -H "$SKILLS_DEST" -mindepth 1 -maxdepth 1 -type d -name 'fabrico-*' -exec rm -rf {} + 2>/dev/null || true
  find -H "$AGENTS_DEST" -mindepth 1 -maxdepth 1 -type f -name 'fabrico-*.toml' -delete 2>/dev/null || true
  ok "Removed Fabrico skills and custom agents."

  if [ "$DO_MCP" = "1" ]; then
    if [ "$MODE" = "global" ]; then
      remove_tracked_global_mcp
    fi
    remove_tracked_config
  fi

  if [ -f "$CONFIG_DEST" ]; then
    warn "Left $CONFIG_DEST intact; it may contain non-Fabrico settings."
  fi
}

validate_project_paths

printf "\n${B}Fabrico Collections${R} ${D}· Codex installer${R}\n\n"

if [ "$ACTION" = "uninstall" ]; then
  remove_artifacts
  exit 0
fi

have tar || die "tar is required."
if have curl; then
  DL() { curl -fsSL "$1"; }
elif have wget; then
  DL() { wget -qO- "$1"; }
else
  die "curl or wget is required."
fi

TMP="$(mktemp -d /tmp/fabrico-install.XXXXXX)"
trap 'rm -rf "$TMP"' EXIT

say "Downloading ${C}$REPO${R} ${D}($REF)${R} …"
DL "https://api.github.com/repos/$REPO/tarball/$REF" | tar -xz -C "$TMP" \
  || die "Download or extract failed. Check the repo/ref and your connection."

SRC="$(find "$TMP" -maxdepth 1 -mindepth 1 -type d | head -1)"
[ -n "$SRC" ] || die "Downloaded archive is empty."
[ -d "$SRC/skills" ] || die "Unexpected archive layout: missing skills/."
[ -d "$SRC/.codex/agents" ] || die "Unexpected archive layout: missing .codex/agents/."
[ "$(count_skills "$SRC/skills")" -eq 65 ] || die "Unexpected archive layout: expected 65 Fabrico skills."
[ "$(count_agents "$SRC/.codex/agents")" -eq 21 ] || die "Unexpected archive layout: expected 21 Fabrico agents."

preflight_install_configuration() {
  if [ "$MODE" = "global" ] && [ "$DO_MCP" = "1" ]; then
    have codex || die "codex is required for --mcp in global mode."
  fi
  if [ -L "$CONFIG_DEST" ]; then
    :
  else
    if [ -e "$CONFIG_DEST" ] && [ ! -f "$CONFIG_DEST" ]; then
      die "Refusing non-file config path: $CONFIG_DEST"
    fi
    if [ ! -f "$CONFIG_DEST" ]; then
      validate_config_record_paths
    fi
  fi
  if [ "$MODE" = "global" ] && [ "$DO_MCP" = "1" ]; then
    ensure_safe_state_dir
  fi
}

preflight_install_configuration

say "Installing for ${C}$MODE${R} use under ${C}$ROOT${R}"
mkdir -p "$SKILLS_DEST" "$AGENTS_DEST"
find -H "$SKILLS_DEST" -mindepth 1 -maxdepth 1 -type d -name 'fabrico-*' -exec rm -rf {} +
find -H "$AGENTS_DEST" -mindepth 1 -maxdepth 1 -type f -name 'fabrico-*.toml' -delete
cp -R "$SRC/skills/." "$SKILLS_DEST/"
cp -R "$SRC/.codex/agents/." "$AGENTS_DEST/"

ns="$(count_skills "$SKILLS_DEST")"
na="$(count_agents "$AGENTS_DEST")"
ok "$ns skills"
ok "$na custom agents"

ensure_agent_settings() {
  local max_depth
  local max_threads

  read_agent_setting() {
    local setting="$1"

    awk -v setting="$setting" '
      BEGIN { at_root = 1 }
      /^[[:space:]]*\[[^]]+\][[:space:]]*(#.*)?$/ {
        header = $0
        sub(/[[:space:]]*#.*/, "", header)
        gsub(/[[:space:]]/, "", header)
        in_agents = (header == "[agents]" || header == "[\"agents\"]" || header == "['\''agents'\'']")
        at_root = 0
        next
      }
      in_agents && $0 ~ "^[[:space:]]*" setting "[[:space:]]*=" {
        value = $0
        sub(/[[:space:]]*#.*/, "", value)
        sub(/^[^=]*=[[:space:]]*/, "", value)
        gsub(/[[:space:]]/, "", value)
        print value
        exit
      }
      at_root && $0 ~ "^[[:space:]]*agents[[:space:]]*\\.[[:space:]]*" setting "[[:space:]]*=" {
        value = $0
        sub(/[[:space:]]*#.*/, "", value)
        sub(/^[^=]*=[[:space:]]*/, "", value)
        gsub(/[[:space:]]/, "", value)
        print value
        exit
      }
      at_root && $0 ~ "^[[:space:]]*agents[[:space:]]*=" {
        body = $0
        sub(/^[^{]*{/, "", body)
        sub(/}[^}]*$/, "", body)
        if (body !~ /[{}]/ && index(body, "\"") == 0 && index(body, sprintf("%c", 39)) == 0) {
          pattern = "(^|,)[[:space:]]*" setting "[[:space:]]*=[[:space:]]*"
          if (match(body, pattern)) {
            value = substr(body, RSTART + RLENGTH)
            if (match(value, /^[0-9]+/)) {
              print substr(value, RSTART, RLENGTH)
              exit
            }
          }
        }
      }
    ' "$CONFIG_DEST"
  }

  mkdir -p "$(dirname "$CONFIG_DEST")"

  if [ -L "$CONFIG_DEST" ]; then
    warn "$CONFIG_DEST is a symbolic link and was left untouched. Ensure its target defines agents.max_threads = 6 and agents.max_depth = 2."
    return
  fi

  if [ -e "$CONFIG_DEST" ] && [ ! -f "$CONFIG_DEST" ]; then
    die "Refusing non-file config path: $CONFIG_DEST"
  fi

  if [ ! -f "$CONFIG_DEST" ]; then
    validate_config_record_paths
    cat >"$CONFIG_DEST" <<'EOF'
# Added by Fabrico Collections for nested custom-agent workflows.
[agents]
max_threads = 6
max_depth = 2
EOF
    record_config_snapshot
    ok "Created $CONFIG_DEST with agent delegation limits"
    return
  fi

  max_depth="$(read_agent_setting max_depth)"
  max_threads="$(read_agent_setting max_threads)"

  case "$max_depth" in
    ''|*[!0-9]*)
      warn "$CONFIG_DEST already exists and was left untouched. Ensure its agents table sets max_depth = 2 for Fabrico nested delegation."
      ;;
    *)
      if [ "$max_depth" -lt 2 ]; then
        warn "$CONFIG_DEST sets agents.max_depth = $max_depth and was left untouched. Raise it to 2 for Fabrico orchestrator-to-worker delegation."
      fi
      ;;
  esac

  case "$max_threads" in
    ''|*[!0-9]*)
      warn "$CONFIG_DEST already exists and was left untouched. Ensure its agents table sets max_threads = 6 for Fabrico's bounded parallel workers."
      ;;
    *)
      if [ "$max_threads" -lt 6 ]; then
        warn "$CONFIG_DEST sets agents.max_threads = $max_threads and was left untouched. Raise it to 6 for Fabrico's bounded parallel workers."
      fi
      ;;
  esac
}

configure_global_mcp() {
  have codex || die "codex is required for --mcp in global mode."
  ensure_safe_state_dir
  mcp_workdir="$TMP/global-mcp-cwd"
  mkdir -p "$mcp_workdir"

  codex_mcp() {
    (cd "$mcp_workdir" && codex mcp "$@")
  }

  track_mcp() {
    name="$1"
    ensure_safe_state_dir
    mkdir -p "$MCP_STATE_DIR"
    chmod 700 "$MCP_STATE_DIR"
    snapshot="$MCP_STATE_DIR/$name.json"
    pending="$snapshot.pending.$$"
    if (umask 077; codex_mcp get "$name" --json >"$pending" 2>/dev/null); then
      mv "$pending" "$snapshot"
    else
      rm -f "$pending"
      warn "Could not record ownership for MCP server $name; future uninstall will preserve it."
    fi
  }

  existing_mcp() {
    name="$1"
    if [ -f "$MCP_STATE_DIR/$name.json" ]; then
      warn "MCP server $name already exists and is tracked from an earlier Fabrico install — left untouched."
    else
      warn "MCP server $name already exists — left untouched and not claimed by Fabrico."
    fi
  }

  add_stdio() {
    name="$1"
    shift
    if codex_mcp get "$name" >/dev/null 2>&1; then
      existing_mcp "$name"
    else
      codex_mcp add "$name" -- "$@" >/dev/null
      track_mcp "$name"
      ok "MCP $name"
    fi
  }

  add_http() {
    name="$1"
    url="$2"
    if codex_mcp get "$name" >/dev/null 2>&1; then
      existing_mcp "$name"
    else
      codex_mcp add "$name" --url "$url" >/dev/null
      track_mcp "$name"
      ok "MCP $name"
    fi
  }

  add_stdio aws-api uvx awslabs.aws-api-mcp-server@latest
  if ! codex_mcp get aws-documentation >/dev/null 2>&1; then
    codex_mcp add aws-documentation \
      --env FASTMCP_LOG_LEVEL=ERROR \
      --env AWS_DOCUMENTATION_PARTITION=aws \
      --env 'MCP_USER_AGENT=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36' \
      -- uvx awslabs.aws-documentation-mcp-server@latest >/dev/null
    track_mcp aws-documentation
    ok "MCP aws-documentation"
  else
    existing_mcp aws-documentation
  fi
  add_stdio gcp-gcloud npx -y @google-cloud/gcloud-mcp
  add_stdio gcp-observability npx -y @google-cloud/observability-mcp
  add_stdio gcp-storage npx -y @google-cloud/storage-mcp
  add_stdio playwright npx @playwright/mcp@latest
  add_stdio context7 npx -y @upstash/context7-mcp@latest
  add_stdio sequential-thinking npx -y @modelcontextprotocol/server-sequential-thinking
  add_http figma https://mcp.figma.com/mcp
  add_http atlassian https://mcp.atlassian.com/v1/mcp
  add_stdio pdf-reader npx @sylphx/pdf-reader-mcp

  say "  ${D}Authenticate remote servers when needed: codex mcp login figma / codex mcp login atlassian${R}"
}

if [ "$MODE" = "project" ] && [ "$DO_MCP" = "1" ]; then
  if [ -e "$CONFIG_DEST" ] || [ -L "$CONFIG_DEST" ]; then
    warn "$CONFIG_DEST already exists — left untouched. Merge only the settings you need from $CONFIG_SOURCE_URL."
    ensure_agent_settings
  else
    mkdir -p "$(dirname "$CONFIG_DEST")"
    validate_config_record_paths
    cp "$SRC/.codex/config.toml" "$CONFIG_DEST"
    record_config_snapshot
    ok "Installed project agent and MCP configuration"
  fi
else
  ensure_agent_settings
  if [ "$DO_MCP" = "1" ]; then
    configure_global_mcp
  fi
fi

printf "\n${G}Done.${R} Start a new Codex task in your project and try:\n\n"
printf "  ${C}\$fabrico-implement${R} <task>            ${D}# orchestrated build${R}\n"
printf "  ${C}\$fabrico-autopilot${R} SPEC.md           ${D}# spec → working software${R}\n"
printf "  ${C}\$fabrico-modernize${R} <url> ios         ${D}# rebuild a legacy app${R}\n\n"
printf "${D}Docs: https://github.com/$REPO${R}\n"
printf "${D}Uninstall: curl -fsSL https://raw.githubusercontent.com/$REPO/$REF/install.sh | "
if [ -n "${CODEX_HOME:-}" ]; then
  printf 'CODEX_HOME=%q ' "$USER_CODEX_ROOT"
fi
printf 'bash -s -- '
  if [ "$MODE" = "project" ]; then
  printf -- '--project %q --uninstall' "$ROOT"
    if has_config_ownership; then
    printf ' --mcp'
  fi
else
  printf -- '--uninstall'
  if [ "$DO_MCP" = "1" ] || has_config_ownership; then
    printf ' --mcp'
  fi
fi
printf "${R}\n\n"
