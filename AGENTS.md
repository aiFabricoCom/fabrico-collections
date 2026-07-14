# Fabrico Collections

This repository is an opinionated Codex customization collection for product discovery, implementation, and review.
It packages explicit workflow skills, supporting skills, custom agents, project guidance, and optional MCP servers.

## Repository structure

| Artifact | Location |
| --- | --- |
| Entry workflow skills | `.agents/skills/fabrico-*/SKILL.md` with `agents/openai.yaml` |
| Supporting skills | `.agents/skills/fabrico-*/SKILL.md` without `agents/openai.yaml` |
| Custom agents | `.codex/agents/fabrico-*.toml` |
| Project Codex config | `.codex/config.toml` |
| Project guidance | `AGENTS.md` |
| Plugin manifest | `.codex-plugin/plugin.json` |
| Plugin MCP bundle | `.mcp.json` |

There are 31 explicit entry workflows and 34 supporting skills. Entry workflows use
`policy.allow_implicit_invocation: false` and are invoked as `$fabrico-<action>`. Supporting skills remain available
for explicit or implicit activation.

When installed through the plugin, Codex qualifies component names with the plugin namespace, for example
`$fabrico-collections:fabrico-implement`. Direct repository and filesystem installations use the unqualified
`$fabrico-implement` form. `agents/openai.yaml` default prompts target the plugin-qualified form.

## Naming and format rules

Every collection artifact uses the `fabrico-` prefix to avoid collisions when installed alongside project-specific
customizations.

- Entry workflows use verb-led names such as `fabrico-implement` and `fabrico-review`.
- Supporting skills use action or domain names such as `fabrico-code-reviewing`.
- A skill directory name must match the `name` in its `SKILL.md` frontmatter. Skill frontmatter contains only
  `name` and `description`.
- Each custom agent is a standalone TOML file in `.codex/agents/`. It must define `name`, `description`, and
  `developer_instructions`. Use `model_reasoning_effort` when a role needs a reasoning tier; do not pin a model
  without a concrete compatibility reason.
- Use `sandbox_mode = "read-only"` for agents whose contract is review or research only. Treat it as a default, not
  an absolute security boundary when a parent session deliberately overrides sandboxing.
- A reviewer that must persist a named review artifact or update review-owned checklist state may use
  `workspace-write` only when its contract expressly forbids product-code changes and limits writes to those
  review outputs.
- Use root or nested `AGENTS.md`/`AGENTS.override.md` files for durable guidance. Codex guidance is scoped by file
  location; do not invent import directives or glob-based scope.

## Orchestration model

The entry skills are the user-facing workflows. They may ask Codex to spawn a named custom agent and pass the
current request plus referenced context. Describe delegation in capability-oriented language; never depend on an
internal tool name or hidden dispatch parameter.

Core flows include:

- `$fabrico-implement` → `fabrico-engineering-manager` → planning, implementation, UI verification, and review
  agents.
- `$fabrico-analyze-materials` → `fabrico-business-analyst` → transcript, analysis, extraction, quality, and
  formatting workers.
- `$fabrico-review` → `fabrico-code-reviewer` for an evidence-based review.

Nested delegation is capped by `.codex/config.toml`. Avoid cycles: a child agent should return results to its parent
instead of spawning the parent again. With six configured threads, a user-facing caller may run at most five workers;
a nested orchestrator must reserve its parent and run at most four. Escalate to the user after three failed
correction loops.

## Authoring customizations

Use these explicit workflows when extending the collection:

- `$fabrico-create-custom-agent` creates `.codex/agents/<name>.toml`.
- `$fabrico-create-workflow` creates an explicit workflow skill under `.agents/skills/<name>/` with
  `agents/openai.yaml` and implicit invocation disabled.
- `$fabrico-create-custom-skill` creates a reusable supporting skill under `.agents/skills/<name>/`.
- `$fabrico-create-custom-instructions` creates or updates root or nested `AGENTS.md` guidance.

Keep skill descriptions concise and front-load trigger terms. The combined discovery catalog must stay below 8,000
characters so all Fabrico skills remain discoverable.

## MCP servers

`.mcp.json` is the plugin-bundled MCP configuration referenced by `.codex-plugin/plugin.json`. It includes optional
servers for library docs, Figma, browser automation, Jira, PDFs, AWS, and GCP. The installer `--mcp` path enables the
whole bundle; selective installations must merge/register only the servers a workflow needs. Remote servers can
require `codex mcp login`; local servers require `npx` or `uvx` on `PATH`.

## Verification

After changing the collection:

1. Run `./scripts/validate.sh`.
2. Run `bash -n install.sh assets/demo-autopilot.sh`.
3. Validate every changed skill with the bundled skill validator and validate the plugin manifest.
4. Run `git diff --check` and inspect `git status --short`.

Do not reintroduce legacy provider-specific directories, memory filenames, deprecated Codex custom prompts, foreign
model tiers, or surface-specific tool names into the collection contracts.
