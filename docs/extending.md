# Extending the system

The collection can author its own customizations in the correct Claude Code formats. Use the meta commands; they
are backed by the `fabrico-customization-*` subagents and the `fabrico-creating-*` skills.

| Command | Creates | Backed by |
| --- | --- | --- |
| `/fabrico-create-custom-agent` | a subagent `.claude/agents/*.md` | `fabrico-creating-agents` |
| `/fabrico-create-custom-prompt` | a slash command `.claude/commands/*.md` | `fabrico-creating-prompts` |
| `/fabrico-create-custom-skill` | a skill `.claude/skills/<name>/SKILL.md` | `fabrico-creating-skills` |
| `/fabrico-create-custom-instructions` | project memory `CLAUDE.md` | `fabrico-creating-instructions` |

For multi-step customization work (build several subagents, audit all artifacts, design a multi-agent system),
`fabrico-customization-orchestrator` decomposes the task and delegates to the researcher → creator → reviewer
specialists.

## Naming convention — `fabrico-` prefix

Every artifact uses the `fabrico-` prefix so it can be installed into other projects without colliding with
project-specific customizations:

- **Commands:** `fabrico-<action>.md` → invoked as `/fabrico-<action>`.
- **Subagents:** `fabrico-<role>.md`; the frontmatter `name:` must equal the filename.
- **Skills:** `fabrico-<gerund-subject>/` (gerund form, e.g. `creating-skills`); the SKILL.md `name:` must equal
  the directory name.

Cross-references always use the prefixed name.

## Artifact formats (cheat sheet)

**Slash command** (`.claude/commands/*.md`):
```markdown
---
description: "one sentence"
argument-hint: "[what the user passes]"
# model: opus|sonnet|haiku        # optional
# allowed-tools: Read, Grep, Bash # optional; omit to inherit
---
> Optional: Delegate to the `fabrico-<agent>` subagent via the Task tool.

Body. Reference the user input with $ARGUMENTS (or $1, $2).
```

**Subagent** (`.claude/agents/*.md`):
```markdown
---
name: fabrico-<role>
description: "action-oriented, so Claude auto-routes to it"
model: opus|sonnet|haiku
# tools: Read, Grep, Glob, Bash, Task   # omit to inherit the full toolset incl. MCP
---
Role, responsibilities, process, constraints.
```

**Skill** (`.claude/skills/<name>/SKILL.md`):
```markdown
---
name: fabrico-<gerund-subject>
description: "what it does + when to use it (drives auto-activation)"
---
Procedure, checklists, references/ and templates/ as needed (progressive disclosure).
```

## Model tiers

Subagents pick `model:` by role: **opus** for orchestration/architecture/review reasoning, **sonnet** for
implementation, **haiku** for lightweight workers. See [Subagents](agents.md) for the per-agent assignment.

## Authoring LLM application prompts (different thing)

`/fabrico-engineer-prompt` and the `fabrico-engineering-prompts` skill are for prompts **inside your product's LLM
features** (system prompts, RAG templates, agent instructions) — not for authoring Claude Code commands. For the
latter, use `/fabrico-create-custom-prompt`.
