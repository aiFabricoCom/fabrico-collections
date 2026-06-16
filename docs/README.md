# Fabrico Collections — Documentation

Opinionated **Claude Code** setup for product discovery, implementation, review, autonomous builds, and legacy
modernization. This is a customization collection — a catalog of slash commands, subagents, and skills that turn
Claude Code into a team of specialized agents.

At a glance: **28 slash commands**, **21 subagents**, **34 skills**, all prefixed `fabrico-`.

## Guides

1. [Getting started](getting-started.md) — install (per-project or global), MCP setup, requirements.
2. [Workflows](workflows.md) — the golden path; discovery → implementation → review; how delegation and gates work.
3. [Autopilot](autopilot.md) — write one complete spec, get working software autonomously.
4. [Legacy modernization](legacy-modernization.md) — reverse-engineer a spec from a running web app (Playwright/Chrome, incl. login) and rebuild it on a modern stack or mobile.
5. [Extending the system](extending.md) — author your own commands, subagents, skills, and `CLAUDE.md` memory.

## Reference

- [Commands](commands.md) — all 28 `/fabrico-*` slash commands.
- [Subagents](agents.md) — all 21 `fabrico-*` subagents and their model tiers.
- [Skills](skills.md) — all 34 `fabrico-*` skills.

## Quick start

```bash
# install globally so /fabrico-* works in every project
mkdir -p ~/.claude/commands ~/.claude/agents ~/.claude/skills
cp -R .claude/commands/* ~/.claude/commands/
cp -R .claude/agents/*   ~/.claude/agents/
cp -R .claude/skills/*   ~/.claude/skills/
```

Then open Claude Code in your project and try:

- `/fabrico-implement <task>` — orchestrated research → plan → build → review
- `/fabrico-autopilot SPEC.md` — complete spec → working software, autonomously
- `/fabrico-modernize <url> ios` — rebuild a legacy web app on a modern target

> See the repository [`CLAUDE.md`](../CLAUDE.md) for the naming convention and orchestration model, and
> [`README.md`](../README.md) for the short overview.
