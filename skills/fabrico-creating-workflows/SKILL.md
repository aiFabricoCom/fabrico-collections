---
name: fabrico-creating-workflows
description: "Author reusable entry workflow skills."
---

# Creating explicit workflow skills

Model a reusable user-started action as a normal Codex skill plus UI metadata that disables implicit invocation.

## Canonical structure

```text
.agents/skills/<workflow-name>/
├── SKILL.md
├── agents/
│   └── openai.yaml
└── references/, scripts/, assets/   # only when needed
```

`SKILL.md` frontmatter contains only `name` and `description`. The current user message is the workflow input; do not add argument placeholders or invent a separate command format.

For an explicit workflow, `agents/openai.yaml` must contain:

```yaml
interface:
  display_name: "<Human-readable name>"
  short_description: "<25-64 character UI summary>"
  default_prompt: "Use $<workflow-name> to <representative task>."

policy:
  allow_implicit_invocation: false
```

Quote all YAML string values. The default prompt must mention the skill by its exact `$name`.

## Creation workflow

1. Define the user-visible outcome, required context, safety boundary, and completion evidence.
2. Search existing skills and agents to avoid duplicate entry points.
3. Choose a lowercase, hyphenated, verb-led name under 64 characters; preserve the repository namespace when required.
4. Write a concise description that states what the workflow does and the request that should invoke it explicitly.
5. Design a numbered procedure with decision points, validation, and a clear terminal condition.
6. If specialization materially helps, instruct Codex to delegate a bounded subtask to a named custom agent. Include the objective, scope, relevant files, constraints, and expected return value. Keep orchestration and final synthesis in the calling workflow.
7. Move detailed formats and examples into directly linked resources. Add scripts only for deterministic repeated operations and test them.
8. Create `agents/openai.yaml` with `allow_implicit_invocation: false`.
9. Validate YAML, resource links, agent references, and an example explicit invocation.

## Design rules

- Keep the entry skill focused on one coherent outcome.
- Use the user's current request as input; ask only for missing decisions that materially change the result.
- State prerequisites and safe fallbacks without naming internal tools.
- Avoid mandatory delegation for trivial work or when the named agent is unavailable.
- Serialize write-heavy delegated work unless file scopes are disjoint.
- Cap retry and review loops.
- Do not put project-wide conventions here; use `AGENTS.md`.
- Do not duplicate domain procedures already provided by another skill.

## Validation checklist

- [ ] Directory name and frontmatter `name` match.
- [ ] `SKILL.md` frontmatter has only `name` and `description`.
- [ ] Description is concise and distinguishes this workflow from related skills.
- [ ] `agents/openai.yaml` is valid and sets `allow_implicit_invocation: false`.
- [ ] `default_prompt` explicitly mentions the exact skill name.
- [ ] All references are one hop from `SKILL.md` and resolve.
- [ ] Named agents and supporting skills exist or have an explicit fallback.
- [ ] Workflow has verification, stop conditions, and bounded iteration.

Use [workflow-skill.template.md](workflow-skill.template.md) as the starting point.
