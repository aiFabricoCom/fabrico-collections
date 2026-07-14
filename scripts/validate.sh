#!/usr/bin/env bash

set -uo pipefail

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)"
PASS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0

ok() {
  PASS_COUNT=$((PASS_COUNT + 1))
  printf '[OK]   %s\n' "$1"
}

fail() {
  FAIL_COUNT=$((FAIL_COUNT + 1))
  printf '[FAIL] %s\n' "$1"
}

skip() {
  SKIP_COUNT=$((SKIP_COUNT + 1))
  printf '[SKIP] %s\n' "$1"
}

print_details() {
  while IFS= read -r line; do
    [ -n "$line" ] && printf '       %s\n' "$line"
  done
}

check() {
  local label="$1"
  local output
  local status

  shift
  output="$("$@" 2>&1)"
  status=$?
  if [ "$status" -eq 0 ]; then
    ok "$label"
    [ -n "$output" ] && printf '%s\n' "$output" | print_details
  else
    fail "$label"
    [ -n "$output" ] && printf '%s\n' "$output" | print_details
  fi
}

count_find_results() {
  find "$@" | wc -l | tr -d '[:space:]'
}

validate_structure() {
  local rc=0
  local target=""
  local skill_dirs=0
  local skill_files=0
  local entry_files=0
  local agent_files=0

  for path in \
    "$ROOT/skills" \
    "$ROOT/.agents" \
    "$ROOT/.codex" \
    "$ROOT/.codex/agents" \
    "$ROOT/.codex-plugin"; do
    if [ ! -d "$path" ]; then
      printf 'missing required directory: %s\n' "${path#"$ROOT/"}"
      rc=1
    fi
  done

  for path in \
    "$ROOT/AGENTS.md" \
    "$ROOT/.codex/config.toml" \
    "$ROOT/.codex-plugin/plugin.json" \
    "$ROOT/.mcp.json" \
    "$ROOT/SPEC.template.md" \
    "$ROOT/skills/fabrico-create-spec/references/SPEC.template.md"; do
    if [ ! -f "$path" ]; then
      printf 'missing required file: %s\n' "${path#"$ROOT/"}"
      rc=1
    fi
  done

  if [ -f "$ROOT/SPEC.template.md" ] && [ -f "$ROOT/skills/fabrico-create-spec/references/SPEC.template.md" ]; then
    if ! cmp -s "$ROOT/SPEC.template.md" "$ROOT/skills/fabrico-create-spec/references/SPEC.template.md"; then
      printf 'bundled SPEC template differs from repository SPEC.template.md\n'
      rc=1
    fi
  fi

  if [ -L "$ROOT/skills" ]; then
    printf 'skills/ must be the real directory, not a symlink\n'
    rc=1
  fi

  if [ ! -L "$ROOT/.agents/skills" ]; then
    printf '.agents/skills must be a symlink to ../skills\n'
    rc=1
  else
    target="$(readlink "$ROOT/.agents/skills")"
    if [ "$target" != "../skills" ]; then
      printf '.agents/skills points to %s; expected ../skills\n' "$target"
      rc=1
    fi
    if [ ! -d "$ROOT/.agents/skills" ]; then
      printf '.agents/skills is a broken symlink\n'
      rc=1
    fi
  fi

  if [ -d "$ROOT/skills" ]; then
    skill_dirs="$(count_find_results "$ROOT/skills" -mindepth 1 -maxdepth 1 -type d -name 'fabrico-*')"
    skill_files="$(count_find_results "$ROOT/skills" -mindepth 2 -maxdepth 2 -type f -name 'SKILL.md')"
    entry_files="$(count_find_results "$ROOT/skills" -mindepth 3 -maxdepth 3 -type f -path '*/agents/openai.yaml')"

    if [ "$skill_dirs" -ne 65 ]; then
      printf 'found %s top-level fabrico skill directories; expected 65\n' "$skill_dirs"
      rc=1
    fi
    if [ "$skill_files" -ne 65 ]; then
      printf 'found %s top-level SKILL.md files; expected 65\n' "$skill_files"
      rc=1
    fi
    if [ "$entry_files" -ne 31 ]; then
      printf 'found %s entry-workflow openai.yaml files; expected 31\n' "$entry_files"
      rc=1
    fi
  fi

  if [ -d "$ROOT/.codex/agents" ]; then
    agent_files="$(count_find_results "$ROOT/.codex/agents" -mindepth 1 -maxdepth 1 -type f -name 'fabrico-*.toml')"
    if [ "$agent_files" -ne 21 ]; then
      printf 'found %s custom agent TOML files; expected 21\n' "$agent_files"
      rc=1
    fi
  fi

  for legacy in \
    "$ROOT/.claude" \
    "$ROOT/.claude-plugin" \
    "$ROOT/CLAUDE.md" \
    "$ROOT/.codex/prompts"; do
    if [ -e "$legacy" ] || [ -L "$legacy" ]; then
      printf 'legacy customization surface must be absent: %s\n' "${legacy#"$ROOT/"}"
      rc=1
    fi
  done

  return "$rc"
}

validate_bash_syntax() {
  local rc=0
  local count=0
  local file
  local output

  while IFS= read -r file; do
    count=$((count + 1))
    if ! output="$(bash -n "$file" 2>&1)"; then
      printf '%s\n' "bash syntax error in ${file#"$ROOT/"}:"
      printf '%s\n' "$output"
      rc=1
    fi
  done < <(find "$ROOT" -type f -name '*.sh' -not -path '*/.git/*' | sort)

  if [ "$count" -eq 0 ]; then
    printf 'no shell scripts found\n'
    rc=1
  else
    printf 'checked %s shell scripts\n' "$count"
  fi

  return "$rc"
}

validate_installer_behavior() {
  "$ROOT/scripts/test-install.sh"
}

validate_json_yaml_and_skills() {
  ruby - "$ROOT" <<'RUBY'
require "json"
require "pathname"
require "set"
require "yaml"

root = File.expand_path(ARGV.fetch(0))
errors = []

def safe_yaml_load(text, path)
  YAML.safe_load(
    text,
    permitted_classes: [],
    permitted_symbols: [],
    aliases: false,
    filename: path
  )
rescue ArgumentError
  YAML.safe_load(text, [], [], false, path)
end

def read_json(path, errors)
  JSON.parse(File.read(path))
rescue StandardError => e
  errors << "#{path}: invalid JSON: #{e.message}"
  nil
end

manifest_path = File.join(root, ".codex-plugin", "plugin.json")
mcp_path = File.join(root, ".mcp.json")
manifest = read_json(manifest_path, errors)
mcp = read_json(mcp_path, errors)

unless manifest.is_a?(Hash)
  errors << "#{manifest_path}: manifest root must be an object"
else
  allowed_manifest_keys = Set.new(%w[id name version description skills apps mcpServers interface author homepage repository license keywords])
  unknown_manifest_keys = manifest.keys.map(&:to_s).to_set - allowed_manifest_keys
  unless unknown_manifest_keys.empty?
    errors << "#{manifest_path}: unsupported fields: #{unknown_manifest_keys.to_a.sort.join(', ')}"
  end

  {
    "name" => "fabrico-collections",
    "skills" => "./skills/",
    "mcpServers" => "./.mcp.json"
  }.each do |key, expected|
    errors << "#{manifest_path}: #{key} must equal #{expected.inspect}" unless manifest[key] == expected
  end

  %w[name version description].each do |key|
    value = manifest[key]
    errors << "#{manifest_path}: missing non-empty #{key}" unless value.is_a?(String) && !value.strip.empty?
  end

  version = manifest["version"]
  semver = /\A(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?(?:\+[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?\z/
  errors << "#{manifest_path}: version must be strict semver" if version.is_a?(String) && !semver.match?(version)

  author = manifest["author"]
  unless author.is_a?(Hash) && author["name"].is_a?(String) && !author["name"].strip.empty?
    errors << "#{manifest_path}: author.name must be a non-empty string"
  end

  default_prompts = manifest.dig("interface", "defaultPrompt")
  unless default_prompts.is_a?(Array) && default_prompts.length.between?(1, 3)
    errors << "#{manifest_path}: interface.defaultPrompt must contain 1 to 3 prompts"
  else
    default_prompts.each_with_index do |prompt, index|
      unless prompt.is_a?(String) && !prompt.strip.empty? && prompt.length <= 128
        errors << "#{manifest_path}: interface.defaultPrompt[#{index}] must be a non-empty string of at most 128 characters"
        next
      end
      unless prompt.match?(/\$fabrico-collections:fabrico-[a-z0-9-]+/)
        errors << "#{manifest_path}: interface.defaultPrompt[#{index}] must use the $fabrico-collections: component namespace"
      end
    end
  end

  interface = manifest["interface"]
  unless interface.is_a?(Hash)
    errors << "#{manifest_path}: interface must be an object"
  else
    required_interface = %w[displayName shortDescription longDescription developerName category capabilities]
    required_interface.each do |key|
      value = interface[key]
      valid = key == "capabilities" ? value.is_a?(Array) && value.all? { |item| item.is_a?(String) && !item.strip.empty? } : value.is_a?(String) && !value.strip.empty?
      errors << "#{manifest_path}: interface.#{key} is required" unless valid
    end
  end

  %w[skills mcpServers apps].each do |key|
    next unless manifest.key?(key)

    value = manifest[key]
    unless value.is_a?(String) && value.start_with?("./")
      errors << "#{manifest_path}: #{key} path must start with ./"
      next
    end

    resolved = File.expand_path(value, root)
    unless resolved.start_with?(root + File::SEPARATOR) && File.exist?(resolved)
      errors << "#{manifest_path}: #{key} path does not resolve inside the plugin root: #{value}"
    end
  end
end

servers = nil
unless mcp.is_a?(Hash)
  errors << "#{mcp_path}: root must be an object"
else
  errors << "#{mcp_path}: top level must contain only mcpServers" unless mcp.keys == ["mcpServers"]
  servers = mcp["mcpServers"]
end

unless servers.is_a?(Hash) && !servers.empty?
  errors << "#{mcp_path}: MCP server map must be a non-empty object"
else
    servers.each do |name, config|
      unless name.is_a?(String) && !name.strip.empty?
        errors << "#{mcp_path}: server names must be non-empty strings"
        next
      end
      unless name.match?(/\A[A-Za-z0-9_-]+\z/)
        errors << "#{mcp_path}: server #{name.inspect} must use only letters, numbers, hyphens, and underscores"
      end
      unless config.is_a?(Hash)
        errors << "#{mcp_path}: server #{name.inspect} must be an object"
        next
      end

      allowed_server_keys = Set.new(%w[command args env url type])
      unknown_server_keys = config.keys.map(&:to_s).to_set - allowed_server_keys
      unless unknown_server_keys.empty?
        errors << "#{mcp_path}: server #{name.inspect} has unsupported fields: #{unknown_server_keys.to_a.sort.join(', ')}"
      end

      has_command = config["command"].is_a?(String) && !config["command"].strip.empty?
      has_url = config["url"].is_a?(String) && !config["url"].strip.empty?
      errors << "#{mcp_path}: server #{name.inspect} must define exactly one of command or url" if has_command == has_url

      type = config["type"]
      if config.key?("type") && !%w[stdio http].include?(type)
        errors << "#{mcp_path}: server #{name.inspect} type must be stdio or http"
      elsif type == "stdio" && !has_command
        errors << "#{mcp_path}: server #{name.inspect} stdio type requires command"
      elsif type == "http" && !has_url
        errors << "#{mcp_path}: server #{name.inspect} http type requires url"
      end

      if config.key?("args") && !(config["args"].is_a?(Array) && config["args"].all? { |arg| arg.is_a?(String) })
        errors << "#{mcp_path}: server #{name.inspect} args must be an array of strings"
      end
      if config.key?("env") && !(config["env"].is_a?(Hash) && config["env"].all? { |key, value| key.is_a?(String) && !key.empty? && value.is_a?(String) })
        errors << "#{mcp_path}: server #{name.inspect} env must map non-empty strings to strings"
      end
  end
end

skill_paths = Dir.glob(File.join(root, "skills", "fabrico-*", "SKILL.md")).sort
description_chars = 0
entry_count = 0
skill_names = Set.new
entry_names = Set.new

skill_paths.each do |path|
  expected_name = File.basename(File.dirname(path))
  skill_names << expected_name
  text = File.read(path)
  match = text.match(/\A---\r?\n(.*?)\r?\n---\r?\n/m)
  unless match
    errors << "#{path}: missing YAML frontmatter delimited by ---"
    next
  end

  begin
    frontmatter = safe_yaml_load(match[1], path)
  rescue StandardError => e
    errors << "#{path}: invalid YAML frontmatter: #{e.message}"
    next
  end

  unless frontmatter.is_a?(Hash)
    errors << "#{path}: frontmatter must be a mapping"
    next
  end

  keys = frontmatter.keys.map(&:to_s).to_set
  expected_keys = Set.new(%w[name description])
  errors << "#{path}: frontmatter keys must be exactly name and description (found #{keys.to_a.sort.join(', ')})" unless keys == expected_keys

  name = frontmatter["name"]
  description = frontmatter["description"]
  errors << "#{path}: name #{name.inspect} must match directory #{expected_name.inspect}" unless name == expected_name
  unless description.is_a?(String) && !description.strip.empty?
    errors << "#{path}: description must be a non-empty string"
  else
    description_chars += description.length
  end

  openai_path = File.join(File.dirname(path), "agents", "openai.yaml")
  next unless File.file?(openai_path)

  entry_count += 1
  entry_names << expected_name
  unless text.include?("Invocation portability:")
    errors << "#{path}: entry workflow must explain direct versus plugin invocation names"
  end
  begin
    metadata = safe_yaml_load(File.read(openai_path), openai_path)
  rescue StandardError => e
    errors << "#{openai_path}: invalid YAML: #{e.message}"
    next
  end

  unless metadata.is_a?(Hash)
    errors << "#{openai_path}: metadata must be a mapping"
    next
  end

  policy = metadata["policy"]
  interface = metadata["interface"]
  unless policy.is_a?(Hash) && policy["allow_implicit_invocation"] == false
    errors << "#{openai_path}: policy.allow_implicit_invocation must be false"
  end
  unless interface.is_a?(Hash)
    errors << "#{openai_path}: interface must be a mapping"
    next
  end

  %w[display_name short_description default_prompt].each do |key|
    value = interface[key]
    errors << "#{openai_path}: interface.#{key} must be a non-empty string" unless value.is_a?(String) && !value.strip.empty?
  end
  default_prompt = interface["default_prompt"]
  qualified_invocation = "$fabrico-collections:#{expected_name}"
  if default_prompt.is_a?(String) && !default_prompt.include?(qualified_invocation)
    errors << "#{openai_path}: default_prompt must explicitly invoke #{qualified_invocation}"
  end
end

supporting_names = skill_names - entry_names
catalogs = [
  [
    File.join(root, "docs", "workflow-skills.md"),
    entry_names,
    /^\|\s*`\$(fabrico-[a-z0-9-]+)`\s*\|/,
    "entry workflow"
  ],
  [
    File.join(root, "docs", "skills.md"),
    supporting_names,
    /^\|\s*`(fabrico-[a-z0-9-]+)`\s*\|/,
    "supporting skill"
  ]
]

catalogs.each do |path, expected, pattern, label|
  unless File.file?(path)
    errors << "#{path}: missing #{label} catalog"
    next
  end

  listed = File.read(path).scan(pattern).flatten
  documented = listed.to_set
  if listed.length != documented.length
    duplicates = listed.tally.select { |_name, count| count > 1 }.keys.sort
    errors << "#{path}: duplicate #{label} rows: #{duplicates.join(', ')}"
  end

  missing = (expected - documented).to_a.sort
  extra = (documented - expected).to_a.sort
  errors << "#{path}: missing #{label} rows: #{missing.join(', ')}" unless missing.empty?
  errors << "#{path}: unexpected #{label} rows: #{extra.join(', ')}" unless extra.empty?
end

errors << "found #{skill_paths.length} skills; expected 65" unless skill_paths.length == 65
errors << "found #{entry_count} entry workflows; expected 31" unless entry_count == 31
errors << "combined skill description catalog is #{description_chars} characters; maximum is 8000" if description_chars > 8000

puts "skill description catalog: #{description_chars}/8000 characters"
unless errors.empty?
  errors.each { |error| warn error.sub(root + File::SEPARATOR, "") }
  exit 1
end
RUBY
}

validate_toml() {
  python3 - "$ROOT" <<'PYTHON'
import json
import sys
from pathlib import Path

root = Path(sys.argv[1]).resolve()
errors = []

try:
    import tomllib as toml_parser
    parser_name = "tomllib"
except ImportError:
    try:
        import tomli as toml_parser
        parser_name = "tomli"
    except ImportError:
        try:
            from pip._vendor import tomli as toml_parser
            parser_name = "pip._vendor.tomli"
        except ImportError:
            print("no TOML parser available (need Python 3.11+, tomli, or pip's vendored tomli)", file=sys.stderr)
            raise SystemExit(1)


def relative(path):
    try:
        return str(path.relative_to(root))
    except ValueError:
        return str(path)


def load_toml(path):
    try:
        value = toml_parser.loads(path.read_text(encoding="utf-8"))
        if not isinstance(value, dict):
            errors.append(f"{relative(path)}: TOML document must be a table")
            return {}
        return value
    except Exception as exc:
        errors.append(f"{relative(path)}: invalid TOML: {exc}")
        return {}


config_path = root / ".codex" / "config.toml"
config = load_toml(config_path)
agents_config = config.get("agents")
if not isinstance(agents_config, dict):
    errors.append(".codex/config.toml: missing [agents] table")
else:
    minimums = {"max_threads": 6, "max_depth": 2}
    for key, minimum in minimums.items():
        value = agents_config.get(key)
        if not isinstance(value, int) or isinstance(value, bool) or value < minimum:
            errors.append(f".codex/config.toml: agents.{key} must be an integer >= {minimum}")

config_servers = config.get("mcp_servers")
if not isinstance(config_servers, dict) or not config_servers:
    errors.append(".codex/config.toml: missing non-empty [mcp_servers] configuration")

agent_paths = sorted((root / ".codex" / "agents").glob("fabrico-*.toml"))
allowed_efforts = {"none", "minimal", "low", "medium", "high", "xhigh", "max", "ultra"}
allowed_sandboxes = {"read-only", "workspace-write", "danger-full-access"}

for path in agent_paths:
    agent = load_toml(path)
    for key in ("name", "description", "developer_instructions"):
        value = agent.get(key)
        if not isinstance(value, str) or not value.strip():
            errors.append(f"{relative(path)}: {key} must be a non-empty string")

    if agent.get("name") != path.stem:
        errors.append(f"{relative(path)}: name {agent.get('name')!r} must match filename {path.stem!r}")

    effort = agent.get("model_reasoning_effort")
    if effort is not None and effort not in allowed_efforts:
        errors.append(f"{relative(path)}: unsupported model_reasoning_effort {effort!r}")

    sandbox = agent.get("sandbox_mode")
    if sandbox is not None and sandbox not in allowed_sandboxes:
        errors.append(f"{relative(path)}: unsupported sandbox_mode {sandbox!r}")

if len(agent_paths) != 21:
    errors.append(f"found {len(agent_paths)} custom agent TOML files; expected 21")

mcp_path = root / ".mcp.json"
try:
    mcp_document = json.loads(mcp_path.read_text(encoding="utf-8"))
    if not isinstance(mcp_document, dict) or set(mcp_document) != {"mcpServers"}:
        raise ValueError("top level must be an object containing only mcpServers")
    bundled_servers = mcp_document["mcpServers"]
    if not isinstance(bundled_servers, dict) or not bundled_servers:
        errors.append(".mcp.json: mcpServers must be a non-empty object")
    elif isinstance(config_servers, dict):
        config_names = set(config_servers)
        bundled_names = set(bundled_servers)
        if config_names != bundled_names:
            missing = sorted(bundled_names - config_names)
            extra = sorted(config_names - bundled_names)
            if missing:
                errors.append(".codex/config.toml: missing MCP servers present in .mcp.json: " + ", ".join(missing))
            if extra:
                errors.append(".codex/config.toml: MCP servers absent from .mcp.json: " + ", ".join(extra))

        comparable_keys = ("command", "args", "env", "url")
        for name in sorted(config_names & bundled_names):
            config_server = config_servers[name]
            bundled_server = bundled_servers[name]
            if not isinstance(config_server, dict) or not isinstance(bundled_server, dict):
                errors.append(f"MCP server {name!r}: definitions must be tables/objects in both files")
                continue

            for key in comparable_keys:
                config_value = config_server.get(key)
                bundled_value = bundled_server.get(key)
                if config_value != bundled_value:
                    errors.append(f"MCP server {name!r}: field {key!r} differs between .codex/config.toml and .mcp.json")
except Exception as exc:
    errors.append(f".mcp.json: could not compare MCP server names: {exc}")

print(f"parsed TOML with {parser_name}; checked {len(agent_paths)} custom agents")
if errors:
    for error in errors:
        print(error, file=sys.stderr)
    raise SystemExit(1)
PYTHON
}

validate_provider_cleanup_and_references() {
  python3 - "$ROOT" <<'PYTHON'
import os
import re
import sys
from pathlib import Path
from urllib.parse import unquote

root = Path(sys.argv[1]).resolve()
errors = []
text_suffixes = {".json", ".md", ".sh", ".svg", ".tape", ".toml", ".txt", ".yaml", ".yml"}


def relative(path):
    return path.relative_to(root).as_posix()


def text_files():
    for current, directories, files in os.walk(root, followlinks=False):
        current_path = Path(current)
        directories[:] = sorted(directory for directory in directories if directory != ".git")

        # skills/ is canonical. Never scan the compatibility symlink (or an
        # intermediate real directory) a second time through .agents/skills.
        if current_path == root / ".agents" and "skills" in directories:
            directories.remove("skills")

        for filename in sorted(files):
            path = current_path / filename
            if path == root / "scripts" / "validate.sh":
                continue
            if path.suffix.lower() in text_suffixes:
                yield path


stale_patterns = [
    ("legacy provider directory", re.compile(r"(?i)(?:^|[^a-z0-9])\.claude(?:-plugin)?(?:/|\b)")),
    ("legacy memory filename", re.compile(r"(?i)\bCLAUDE\.md\b")),
    ("legacy provider product name", re.compile(r"(?i)\bClaude(?: Code)?\b")),
    ("legacy dispatch parameter", re.compile(r"(?i)\bsubagent_type\b")),
    ("legacy prompt argument", re.compile(r"\$ARGUMENTS\b")),
    ("legacy frontmatter field", re.compile(r"(?i)\b(?:argument-hint|allowed-tools)\s*:")),
    ("legacy provider model tier", re.compile(r"(?i)\b(?:opus|sonnet|haiku)\b")),
    ("legacy provider CLI", re.compile(r'''(?i)(?:^|[\s`'"])claude(?:\s+mcp|\s*$)''')),
    ("legacy permission flag", re.compile(r"--dangerously-skip-permissions\b")),
    ("legacy import directive", re.compile(r"(?i)(?:^|\s)@import(?:\s|$)")),
    ("legacy command marker", re.compile(r"FABRICO_COLLECTIONS:command:")),
    ("unsupported Playwright MCP flag", re.compile(r"--channel\b")),
    (
        "legacy surface-specific tool contract",
        re.compile(
            r"(?i)\b(?:Read|Write|Edit|Glob|Grep|Bash|Task|TodoWrite|WebFetch|WebSearch|AskUserQuestion)\s+tool\b"
            r"|\btool\s+(?:Read|Write|Edit|Glob|Grep|Bash|Task|TodoWrite|WebFetch|WebSearch|AskUserQuestion)\b"
        ),
    ),
    (
        "legacy slash workflow invocation",
        re.compile(r'''(?i)(?:^|[\s`'"\[(])/fabrico-[a-z0-9-]+'''),
    ),
]

anthropic_allowed_paths = [
    re.compile(r"^docs/extending\.md$"),
    re.compile(r"^skills/fabrico-engineer-prompt/"),
    re.compile(r"^skills/fabrico-engineering-prompts/"),
    re.compile(r"^\.codex/agents/fabrico-prompt-engineer\.toml$"),
    re.compile(r"^\.codex/agents/fabrico-code-reviewer\.toml$"),
]
anthropic_neutral_context = re.compile(
    r"(?i)\b(?:OpenAI|Google|Mistral|Bedrock|LangChain|provider-neutral|provider-specific|LLM provider)\b"
)

all_files = list(text_files())

required_template_references = {
    "skills/fabrico-create-spec/SKILL.md": "references/SPEC.template.md",
    "skills/fabrico-autopilot/SKILL.md": "../fabrico-create-spec/references/SPEC.template.md",
    "skills/fabrico-reverse-engineering-spec/SKILL.md": "../fabrico-create-spec/references/SPEC.template.md",
}
for rel, expected_reference in required_template_references.items():
    path = root / rel
    if not path.is_file() or expected_reference not in path.read_text(encoding="utf-8"):
        errors.append(f"{rel}: missing bundled SPEC template reference {expected_reference!r}")

for path in all_files:
    rel = relative(path)
    try:
        content = path.read_text(encoding="utf-8")
    except UnicodeDecodeError as exc:
        errors.append(f"{rel}: not valid UTF-8: {exc}")
        continue

    for line_number, line in enumerate(content.splitlines(), 1):
        for label, pattern in stale_patterns:
            if pattern.search(line):
                errors.append(f"{rel}:{line_number}: {label}: {line.strip()}")

        if re.search(r"(?i)\bAnthropic\b", line):
            path_allowed = any(pattern.search(rel) for pattern in anthropic_allowed_paths)
            context_allowed = anthropic_neutral_context.search(line) is not None
            if not (path_allowed and context_allowed):
                errors.append(
                    f"{rel}:{line_number}: Anthropic mention is not in the provider-neutral allowlist: {line.strip()}"
                )

skill_names = {path.parent.name for path in (root / "skills").glob("fabrico-*/SKILL.md")}
agent_names = {path.stem for path in (root / ".codex" / "agents").glob("fabrico-*.toml")}
known_artifacts = skill_names | agent_names | {"fabrico-collections"}

name = r"fabrico-[a-z0-9]+(?:-[a-z0-9]+)*"
reference_patterns = [
    (
        "skill invocation",
        re.compile(rf"\$(?:fabrico-collections:)?({name})(?![:a-z0-9-])", re.I),
        skill_names,
    ),
    (
        "skill path",
        re.compile(rf"(?:\.agents/)?skills/({name})(?![a-z0-9-])", re.I),
        skill_names,
    ),
    (
        "custom agent path",
        re.compile(rf"\.codex/agents/({name})(?![a-z0-9-])\.toml", re.I),
        agent_names,
    ),
    ("artifact name", re.compile(rf"`({name})`", re.I), known_artifacts),
]

seen_reference_errors = set()
for path in all_files:
    rel = relative(path)
    try:
        content = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        continue

    for line_number, line in enumerate(content.splitlines(), 1):
        for label, pattern, known_names in reference_patterns:
            for match in pattern.finditer(line):
                referenced_name = match.group(1).lower()
                if referenced_name not in known_names:
                    error = f"{rel}:{line_number}: unknown {label} {referenced_name!r}"
                    if error not in seen_reference_errors:
                        seen_reference_errors.add(error)
                        errors.append(error)


def markdown_destination(raw):
    destination = raw.strip()
    if destination.startswith("<"):
        closing = destination.find(">")
        if closing != -1:
            destination = destination[1:closing]
    else:
        destination = destination.split(None, 1)[0]

    # Template resources deliberately use placeholders such as
    # references/<reference>.md and cannot resolve before instantiation.
    if "<" in destination or ">" in destination:
        return None
    if not destination or destination.startswith(("#", "/", "//")):
        return None
    if re.match(r"^[a-z][a-z0-9+.-]*:", destination, re.I):
        return None
    return unquote(re.split(r"[?#]", destination, maxsplit=1)[0])


inline_link = re.compile(r"!?\[[^\]\n]*\]\(([^)\n]+)\)")
reference_link = re.compile(r"^\s*\[[^\]\n]+\]:\s*(\S+)", re.M)
seen_link_errors = set()
relative_link_count = 0

for path in all_files:
    if path.suffix.lower() != ".md":
        continue
    try:
        content = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        continue

    for pattern in (inline_link, reference_link):
        for match in pattern.finditer(content):
            destination = markdown_destination(match.group(1))
            if destination is None:
                continue
            relative_link_count += 1
            resolved = (path.parent / destination).resolve()
            try:
                resolved.relative_to(root)
            except ValueError:
                line_number = content.count("\n", 0, match.start()) + 1
                errors.append(
                    f"{relative(path)}:{line_number}: relative Markdown link escapes the repository root "
                    f"{match.group(1).strip()!r}"
                )
                continue
            if resolved.exists():
                continue
            line_number = content.count("\n", 0, match.start()) + 1
            error = (
                f"{relative(path)}:{line_number}: broken relative Markdown link "
                f"{match.group(1).strip()!r}"
            )
            if error not in seen_link_errors:
                seen_link_errors.add(error)
                errors.append(error)

print(
    f"scanned {len(all_files)} text files; resolved {len(skill_names)} skills, "
    f"{len(agent_names)} agents, and {relative_link_count} relative Markdown links"
)
if errors:
    limit = 200
    for error in errors[:limit]:
        print(error, file=sys.stderr)
    if len(errors) > limit:
        print(f"... {len(errors) - limit} additional errors omitted", file=sys.stderr)
    raise SystemExit(1)
PYTHON
}

validate_git_diff() {
  local rc=0
  local output

  if ! output="$(git -C "$ROOT" diff --check 2>&1)"; then
    printf '%s\n' "$output"
    rc=1
  fi
  if ! output="$(git -C "$ROOT" diff --cached --check 2>&1)"; then
    printf '%s\n' "$output"
    rc=1
  fi

  return "$rc"
}

printf 'Fabrico Collections validation\n'
printf 'Repository: %s\n\n' "$ROOT"

check "target repository structure" validate_structure
check "Bash syntax" validate_bash_syntax
check "isolated installer behavior" validate_installer_behavior

if command -v ruby >/dev/null 2>&1; then
  check "JSON, YAML, skill metadata, and description budget" validate_json_yaml_and_skills
else
  fail "JSON, YAML, skill metadata, and description budget"
  printf '       ruby is required for JSON and YAML validation\n'
fi

if command -v python3 >/dev/null 2>&1; then
  check "TOML, custom agents, config, and MCP parity" validate_toml
  check "provider cleanup and artifact references" validate_provider_cleanup_and_references
else
  fail "TOML, custom agents, config, and MCP parity"
  fail "provider cleanup and artifact references"
  printf '       python3 is required for TOML and repository validation\n'
fi

if command -v git >/dev/null 2>&1 && git -C "$ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  check "git diff --check (working tree and index)" validate_git_diff
else
  skip "git diff --check (not a Git worktree or Git is unavailable)"
fi

printf '\nSummary: %s passed, %s failed, %s skipped\n' "$PASS_COUNT" "$FAIL_COUNT" "$SKIP_COUNT"
[ "$FAIL_COUNT" -eq 0 ]
