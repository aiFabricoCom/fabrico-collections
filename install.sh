#!/usr/bin/env bash
#
# Fabrico Collections installer
#
#   curl -fsSL https://raw.githubusercontent.com/aiFabricoCom/fabrico-collections/main/install.sh | bash
#
# Options (when piping, pass after `bash -s --`):
#   --global          Install into ~/.claude/        (default)
#   --project [DIR]    Install into DIR/.claude/      (DIR defaults to the current directory)
#   --mcp             Also drop in .mcp.json          (project mode; only if absent)
#   --ref REF         Install a specific branch/tag/commit (default: main)
#   --uninstall       Remove all fabrico-* artifacts from the target
#   --help
#
# Safe by design: only ever writes/removes files named `fabrico-*` — your own
# commands, agents, and skills are never touched.
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
say()  { printf "%s\n" "$*"; }
ok()   { printf "  ${G}✓${R} %s\n" "$*"; }
warn() { printf "  ${Y}!${R} %s\n" "$*"; }
die()  { printf "${Y}✗ %s${R}\n" "$*" >&2; exit 1; }

usage() {
  cat <<'EOF'
Fabrico Collections installer

  curl -fsSL https://raw.githubusercontent.com/aiFabricoCom/fabrico-collections/main/install.sh | bash

Options (when piping, pass after `bash -s --`):
  --global         Install into ~/.claude/ (default)
  --project [DIR]  Install into DIR/.claude/ (DIR defaults to the current directory)
  --mcp            Also drop in .mcp.json (project mode; only if absent)
  --ref REF        Install a specific branch/tag/commit (default: main)
  --uninstall      Remove all fabrico-* artifacts from the target
  --help
EOF
  exit 0
}

while [ $# -gt 0 ]; do
  case "$1" in
    --global)    MODE="global" ;;
    --project)   MODE="project"
                 if [ $# -gt 1 ] && [ "${2#-}" = "${2:-}" ] && [ -n "${2:-}" ]; then PROJECT_DIR="$2"; shift; fi ;;
    --mcp)       DO_MCP="1" ;;
    --ref)       shift; REF="${1:-main}" ;;
    --uninstall) ACTION="uninstall" ;;
    -h|--help)   usage ;;
    *)           die "Unknown option: $1 (try --help)" ;;
  esac
  shift
done

if [ "$MODE" = "global" ]; then
  DIR="$HOME"
  DEST="$HOME/.claude"
else
  DIR="${PROJECT_DIR:-$PWD}"
  DEST="$DIR/.claude"
fi

have() { command -v "$1" >/dev/null 2>&1; }
count() { ( ls $1 2>/dev/null || true ) | wc -l | tr -d ' '; }

printf "\n${B}Fabrico Collections${R} ${D}· installer${R}\n\n"

# ---- uninstall ----
if [ "$ACTION" = "uninstall" ]; then
  say "Removing fabrico-* artifacts from ${C}$DEST${R}"
  rm -f  "$DEST"/commands/fabrico-*.md 2>/dev/null || true
  rm -f  "$DEST"/agents/fabrico-*.md   2>/dev/null || true
  rm -rf "$DEST"/skills/fabrico-*      2>/dev/null || true
  rm -f  "$DEST"/fabrico.mcp.json      2>/dev/null || true
  ok "Uninstalled."
  exit 0
fi

# ---- deps ----
have tar || die "tar is required."
if have curl; then DL() { curl -fsSL "$1"; }
elif have wget; then DL() { wget -qO- "$1"; }
else die "curl or wget is required."; fi

# ---- download ----
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
say "Downloading ${C}$REPO${R} ${D}($REF)${R} …"
DL "https://api.github.com/repos/$REPO/tarball/$REF" | tar -xz -C "$TMP" \
  || die "Download or extract failed. Check the repo/ref and your connection."

SRC="$( (find "$TMP" -maxdepth 1 -mindepth 1 -type d || true) | head -1 )"
[ -n "$SRC" ] && [ -d "$SRC/.claude" ] || die "Unexpected archive layout."

# ---- install ----
say "Installing into ${C}$DEST${R} ${D}($MODE)${R}"
mkdir -p "$DEST/commands" "$DEST/agents" "$DEST/skills"
cp -R "$SRC/.claude/commands/." "$DEST/commands/"
cp -R "$SRC/.claude/agents/."   "$DEST/agents/"
cp -R "$SRC/.claude/skills/."   "$DEST/skills/"

nc="$(count "$DEST/commands/fabrico-*.md")"
na="$(count "$DEST/agents/fabrico-*.md")"
ns="$(count "$DEST/skills/fabrico-*/SKILL.md")"
ok "$nc commands"
ok "$na subagents"
ok "$ns skills"

# ---- mcp ----
if [ "$MODE" = "project" ] && [ "$DO_MCP" = "1" ]; then
  if [ -f "$DIR/.mcp.json" ]; then
    warn ".mcp.json already exists — left untouched (servers in $SRC/.mcp.json)"
  else
    cp "$SRC/.mcp.json" "$DIR/.mcp.json"; ok "Installed .mcp.json"
  fi
else
  cp "$SRC/.mcp.json" "$DEST/fabrico.mcp.json"
  printf "  ${D}MCP servers reference saved to $DEST/fabrico.mcp.json${R}\n"
fi

# ---- done ----
printf "\n${G}Done.${R} Open Claude Code in your project and try:\n\n"
printf "  ${C}/fabrico-implement${R} <task>            ${D}# orchestrated build${R}\n"
printf "  ${C}/fabrico-autopilot${R} SPEC.md           ${D}# spec → working software${R}\n"
printf "  ${C}/fabrico-modernize${R} <url> ios         ${D}# rebuild a legacy app${R}\n\n"
printf "${D}Docs: https://github.com/$REPO  ·  Uninstall: curl -fsSL https://raw.githubusercontent.com/$REPO/main/install.sh | bash -s -- --uninstall${R}\n\n"
