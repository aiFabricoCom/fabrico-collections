# Extending the system

Fabrico can author its own Codex customizations. The four meta workflows are backed by the
`fabrico-customization-*` agents and `fabrico-creating-*` supporting skills.

| Entry workflow skill | Creates | Backed by |
| --- | --- | --- |
| `$fabrico-create-custom-agent` | a custom agent in `.codex/agents/*.toml` | `fabrico-creating-agents` |
| `$fabrico-create-workflow` | a reusable entry workflow skill | `fabrico-creating-workflows` |
| `$fabrico-create-custom-skill` | a supporting skill in `.agents/skills/<name>/SKILL.md` | `fabrico-creating-skills` |
| `$fabrico-create-custom-instructions` | project guidance in `AGENTS.md` or `AGENTS.override.md` | `fabrico-creating-instructions` |

For multi-step customization work, `fabrico-customization-orchestrator` delegates bounded research, creation, and
review tasks to the corresponding specialist agents.

## Naming convention — `fabrico-` prefix

The prefix prevents collisions when the collection is installed alongside project-specific customizations:

- **Entry workflow skills:** action-oriented names such as `fabrico-implement`; explicitly invoke them as
  `$fabrico-implement`.
- **Supporting skills:** descriptive workflow or knowledge names such as `fabrico-code-reviewing`. Codex can
  activate them implicitly or through an explicit `$fabrico-code-reviewing` mention.
- **Custom agents:** role names such as `fabrico-software-engineer`.

Use the prefixed `name` consistently in cross-references.

## Artifact formats

### Skill

Entry and supporting skills use the same open Agent Skills format:

```markdown
---
name: fabrico-<name>
description: Explain what the skill does, when it should trigger, and important boundaries.
---

Imperative workflow instructions, with references/, scripts/, examples/, or assets/ only when useful.
```

Store repository skills at `.agents/skills/fabrico-<name>/SKILL.md`. Global personal skills live under
`$HOME/.agents/skills`. Keep `description` concise and specific because Codex uses it for discovery.

### Custom agent

Custom agents are TOML configuration layers:

```toml
name = "fabrico-<role>"
description = "When Codex should delegate to this role."
model_reasoning_effort = "medium"

developer_instructions = """
Define the role, responsibilities, process, boundaries, and expected handoff.
"""
```

Store project agents at `.codex/agents/fabrico-<role>.toml` and personal agents at
`~/.codex/agents/fabrico-<role>.toml`. `name` is the source of truth; matching the filename is a useful
convention. Omit `model_reasoning_effort` to inherit the parent session setting. Use `sandbox_mode = "read-only"`
for roles that must not modify the workspace.

### Project guidance

Use plain Markdown with no frontmatter:

```markdown
# Repository guidance

## Build and verification

- Run npm test after changing application code.
- Run npm run lint before handing work back.

## Conventions

- Keep domain logic independent from UI components.
```

Place shared repository guidance in root `AGENTS.md`. Codex builds its instruction chain from the repository root
to the current working directory, so a nested `AGENTS.md` applies when Codex runs in that subtree. An
`AGENTS.override.md` in a directory takes precedence over `AGENTS.md` at the same level. Personal global guidance
lives at `~/.codex/AGENTS.md`.

### Project configuration and MCP

Project settings and MCP servers belong in `.codex/config.toml`:

```toml
[agents]
max_threads = 6
max_depth = 2

[mcp_servers.context7]
command = "npx"
args = ["-y", "@upstash/context7-mcp@latest"]
```

Fabrico workflows can delegate more than one level deep, so keep `agents.max_depth` high enough for the
orchestration you enable. Merge project configuration instead of overwriting existing settings.

## Reasoning profiles

Prefer capability-based profiles over provider-specific model aliases:

- **high** for orchestration, architecture, and adversarial review
- **medium** for implementation and focused research
- **low** for narrow, repeatable worker tasks

Use an explicit OpenAI model only when the workflow truly requires one; otherwise inherit the session model and
set `model_reasoning_effort` where useful.

## Authoring LLM application prompts is different

`$fabrico-engineer-prompt` and `fabrico-engineering-prompts` design prompts consumed by an application's LLM API,
including provider-neutral OpenAI, Anthropic, Google, Mistral, and open-source integrations. They do not create
Codex customization artifacts. Use the meta workflows above for Codex agents, skills, guidance, and configuration.
