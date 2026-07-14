# Fabrico Collections — Documentation

Opinionated **Codex** setup for product discovery, implementation, review, autonomous builds, and legacy
modernization. It packages entry workflows, supporting knowledge, and specialized custom agents into a reusable
software-delivery system.

At a glance: **31 entry workflow skills**, **34 supporting skills**, and **21 custom agents**, all prefixed
`fabrico-`.

## Guides

1. [Getting started](getting-started.md) — install per project or globally, configure MCP, and launch Codex.
2. [Workflows](workflows.md) — discovery → implementation → review, including delegation and approval gates.
3. [Autopilot](autopilot.md) — write one complete spec and get working software autonomously.
4. [Legacy modernization](legacy-modernization.md) — inspect an authorized running app and rebuild it for web or mobile.
5. [Extending the system](extending.md) — author workflow skills, supporting skills, custom agents, and `AGENTS.md` guidance.
6. [Going to production](going-to-production.md) — harden an AI-built app for real users.

## Reference

- [Entry workflow skills](workflow-skills.md) — all 31 `$fabrico-*` workflows.
- [Custom agents](agents.md) — all 21 `fabrico-*` agent roles and reasoning profiles.
- [Supporting skills](skills.md) — all 34 reusable knowledge and procedure packages.

## Quick start

From this repository, launch Codex:

```bash
codex --sandbox workspace-write --ask-for-approval on-request
```

Then type one of these prompts in the Codex composer:

- `$fabrico-implement <task>` — orchestrated research → plan → build → review
- `$fabrico-improve-ui <project> [web|ios|android]` — audit and implement evidence-backed UI improvements
- `$fabrico-autopilot SPEC.md` — complete spec → working software
- `$fabrico-finish-project /path/to/project` — close and verify an existing partial project
- `$fabrico-modernize <url> ios` — rebuild an authorized legacy app for a modern target

For a global or project-scoped installation, use the repository installer or follow
[Getting started](getting-started.md).

> See the repository [`AGENTS.md`](../AGENTS.md) for naming and orchestration conventions, and
> [`README.md`](../README.md) for the overview.
