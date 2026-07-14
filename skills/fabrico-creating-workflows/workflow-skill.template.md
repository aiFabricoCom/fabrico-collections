# Explicit Codex workflow skill template

Create both files below and replace every placeholder.

## `SKILL.md`

```markdown
---
name: fabrico-<verb-object>
description: <What the workflow delivers and when a user should invoke it explicitly.>
---

# <Workflow title>

Use the user's current request as the workflow input. Resolve paths and referenced context from the workspace before asking follow-up questions.

## Supporting skills

- `$<skill-name>` for <specific responsibility>

## Workflow

1. **Establish context.** <Required inputs, discovery, and assumptions.>
2. **Choose the path.** <Decision rule and safe fallback.>
3. **Execute.** <Actions and any bounded delegation.>
4. **Verify.** <Checks and evidence required for success.>
5. **Report.** <Deliverables, paths, unresolved items, and next step.>

## Delegation

When <condition>, ask Codex to delegate <bounded objective> to `<custom-agent-name>`. Provide the request, relevant paths, constraints, and expected result. Wait for the result and integrate it before completing the workflow. If delegation is unavailable, continue locally when safe or report the limitation.

## Constraints

- <Safety or scope boundary>
- <Maximum retries or review iterations>
- <Actions requiring user authority>
```

## `agents/openai.yaml`

```yaml
interface:
  display_name: "<Workflow display name>"
  short_description: "<25-64 character UI summary>"
  default_prompt: "Use $fabrico-<verb-object> to <representative task>."

policy:
  allow_implicit_invocation: false
```

Add `references/`, `scripts/`, or `assets/` only when the workflow genuinely needs them. Link every reference directly from `SKILL.md` and test every bundled script.
