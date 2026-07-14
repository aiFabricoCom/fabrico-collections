---
name: fabrico-create-custom-agent
description: "Create a Codex custom agent in `.codex/agents/*.toml`."
---

> **Invocation portability:** `$fabrico-*` below means the discovered entry workflow. Use the unqualified name for repository or filesystem installs and `$fabrico-collections:fabrico-*` for plugin installs.

# Create a custom agent

Use the user's current request and referenced files as the complete workflow input.

For multi-step work, ask Codex to delegate coordination to `fabrico-customization-orchestrator`. Give it the requested outcome, target scope, relevant paths, constraints, and required validation. If that agent is unavailable, perform the same bounded workflow in the current thread.

## Supporting skills

- `$fabrico-creating-agents` for the TOML schema, role boundaries, template, and checks
- `$fabrico-technical-context-discovering` when repository conventions are not yet established
- `$fabrico-codebase-analysing` when several existing agents must be compared

## Workflow

1. Inspect `.codex/agents/`, applicable skills, `AGENTS.md`, and project configuration.
2. Confirm the requested role is distinct from existing agents and determine project or personal scope.
3. Resolve only decisions that materially affect responsibilities, permissions, integrations, or output.
4. Design a narrow role with activation cues, exclusions, completion criteria, and bounded collaboration.
5. Create or update `.codex/agents/<name>.toml` using `$fabrico-creating-agents`. Use personal scope only when explicitly requested.
6. Parse the TOML and verify every referenced skill, agent, path, and MCP server.
7. Request an independent review from `fabrico-customization-reviewer` for substantial changes; apply must-fix findings and revalidate.
8. Return changed paths, key decisions, validation evidence, and unresolved limitations.

Do not create a broad general-purpose role when an existing agent or skill already covers the request. Do not pin a model or widen permissions without a concrete requirement.
