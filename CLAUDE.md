# Fabrico Collections

Opinionated **Claude Code** setup for product discovery, implementation, and review. This repository is a
*customization collection*: a catalog of slash commands, subagents, and skills you install into Claude Code so it
can plan, build, and review software through a team of specialized agents.

This file is Claude Code's project memory. It documents the conventions and structure of the collection itself.

## Structure

| Artifact | Location |
| --- | --- |
| Slash commands | `.claude/commands/fabrico-*.md` |
| Subagents | `.claude/agents/fabrico-*.md` |
| Skills | `.claude/skills/fabrico-*/SKILL.md` |
| Project memory | `CLAUDE.md` (this file) |
| MCP servers | `.mcp.json` |

## Naming convention — `fabrico-` prefix required

Every customization artifact in this repository uses the `fabrico-` prefix so it can be installed into other
projects without colliding with project-specific customizations:

- **Commands:** `fabrico-<action>.md` — e.g. `fabrico-implement.md`, `fabrico-review.md` (invoked as `/fabrico-implement`)
- **Subagents:** `fabrico-<role>.md` — e.g. `fabrico-software-engineer.md`, `fabrico-architect.md`. The frontmatter
  `name:` must equal the filename (without `.md`).
- **Skills:** `fabrico-<gerund-subject>/` — e.g. `fabrico-code-reviewing/`, `fabrico-creating-skills/`. The SKILL.md
  frontmatter `name:` must equal the directory name.

When one artifact references another, always use the prefixed name (e.g. a command delegating to the
`fabrico-architect` subagent, or `/fabrico-review`).

## How it works (orchestration model)

The collection is designed for **automated, multi-agent software delivery**. The main entry points are slash
commands; most of them delegate to a specialized subagent via the **Task** tool, which may in turn delegate to other
subagents. The core chain:

- `/fabrico-implement` → **fabrico-engineering-manager** (orchestrator) → delegates to **fabrico-architect** (plan),
  **fabrico-software-engineer** / **fabrico-devops-engineer** / **fabrico-prompt-engineer** (build),
  **fabrico-ui-reviewer** (Figma/UI verification), then **fabrico-code-reviewer** (quality gates).
- `/fabrico-analyze-materials` → **fabrico-business-analyst** → BA worker subagents (transcript, extraction,
  analysis, quality, formatting) for turning workshop inputs into structured tasks.
- `/fabrico-review` → **fabrico-code-reviewer** for structured code review and risk detection.

Subagents auto-activate by their `description`; commands route explicitly via a delegation directive at the top of
the command body. Skills (`fabrico-*`) are model-invoked: Claude pulls in the relevant skill based on its
`description` when a task matches.

## Model tiers

Subagents declare a `model:` chosen by role: `opus` for orchestration/architecture/review reasoning
(engineering-manager, architect, plan-reviewer, code-reviewer, business-analyst, context-engineer, prompt-engineer,
customization-orchestrator), `sonnet` for implementation (software/devops/e2e engineers, ui-reviewer,
customization-*), `haiku` for the lightweight BA worker subagents.

## MCP servers

`.mcp.json` declares the MCP servers the agents rely on: `context7` (library docs), `figma`, `playwright`,
`sequential-thinking`, `atlassian` (Jira), `pdf-reader`, plus AWS and GCP servers for the infra/cost commands.
Several require credentials or local tooling (`uvx`, `npx`); enable only the ones you need.

## Extending the collection

Use the meta commands to author new artifacts in the correct Claude Code format:

- `/fabrico-create-custom-agent` — author a new `.claude/agents/*.md` subagent
- `/fabrico-create-custom-prompt` — author a new `.claude/commands/*.md` slash command
- `/fabrico-create-custom-skill` — author a new `.claude/skills/*/SKILL.md` skill
- `/fabrico-create-custom-instructions` — author / update `CLAUDE.md` memory

These are backed by the `fabrico-customization-*` subagents and the `fabrico-creating-*` skills.
