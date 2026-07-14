---
name: fabrico-creating-agents
description: "Author Codex custom agents in `.codex/agents/*.toml`."
---

# Creating Codex custom agents

Create focused agents that Codex can select for delegated work. Keep repeatable procedures in skills and repository rules in `AGENTS.md`.

## Canonical locations

- Project agent: `.codex/agents/<name>.toml`
- Personal agent: `~/.codex/agents/<name>.toml`

Prefer project scope for team-owned roles. Use personal scope only when the user explicitly wants the role across repositories.

## Required schema

Every agent file is TOML and defines:

- `name`: stable identifier used when referring to the agent
- `description`: concise guidance for when the role is useful
- `developer_instructions`: the role's operating contract

Optional session settings include `nickname_candidates`, `model`, `model_reasoning_effort`, `sandbox_mode`, `mcp_servers`, and `skills.config`. Omit settings that should inherit from the parent session. Prefer `model_reasoning_effort` over pinning a model unless availability and cost requirements justify a model choice.

Use `sandbox_mode = "read-only"` for research or review roles that should not edit. Treat this as a default, not a security boundary: live parent-session permission overrides still apply.

## Creation workflow

1. Inspect `.codex/agents/`, relevant skills, `AGENTS.md`, and `.codex/config.toml` without copying unrelated conventions.
2. Define one narrow responsibility, activation cues, exclusions, expected output, and collaboration boundaries.
3. Decide which settings should inherit and which must be overridden for this role.
4. Write `developer_instructions` as direct behavioral guidance. Include role, responsibilities, constraints, completion criteria, and output contract.
5. Refer to skills by name instead of duplicating their procedures. Describe delegation in plain language, naming the target agent and the bounded task it should receive.
6. Start from [agent.template.toml](agent.template.toml), remove unused optional fields, and replace every placeholder.
7. Parse the TOML and verify referenced agents, skills, paths, and MCP servers exist.

## Authoring rules

- Keep the role distinct from existing agents.
- Do not encode a full task workflow in the agent; place reusable steps in a skill.
- Do not put repository conventions in the agent; place them in the nearest applicable `AGENTS.md`.
- Describe capabilities semantically. Do not depend on internal tool-call names.
- Give delegated work a concrete objective, scope, constraints, and return format.
- Avoid recursive handoff loops. State when the agent must return to its caller instead of delegating again.
- Keep instructions compact enough to leave room for the task and its evidence.

## Validation checklist

- [ ] File is valid TOML under `.codex/agents/` or `~/.codex/agents/`.
- [ ] `name`, `description`, and `developer_instructions` are present and strings.
- [ ] The name is unique and the filename follows the same convention.
- [ ] Optional settings are valid Codex configuration keys and justified.
- [ ] Read-only roles set `sandbox_mode = "read-only"` and also state their behavioral boundary.
- [ ] Instructions contain no unresolved placeholders or stale paths.
- [ ] Every referenced skill, agent, MCP server, and file exists or is explicitly optional.
- [ ] Delegation cannot create an unbounded cycle.

## Connected skills

- `fabrico-creating-skills` for reusable procedures referenced by agents
- `fabrico-creating-workflows` for explicit user-invoked workflows
- `fabrico-creating-instructions` for durable repository guidance
