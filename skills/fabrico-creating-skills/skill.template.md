# Codex skill template

Replace every placeholder and remove unused sections.

## `SKILL.md`

```markdown
---
name: <verb-led-skill-name>
description: <Capability, concrete trigger contexts, and any important exclusion.>
---

# <Skill title>

<One sentence defining the outcome.>

## Workflow

1. <Establish task context and authoritative inputs.>
2. <Apply the core procedure or decision rule.>
3. <Use only the resources relevant to the selected variant.>
4. <Validate the result with concrete checks.>
5. <Return the deliverable, evidence, and unresolved items.>

## Resource routing

- Read [<reference>.md](references/<reference>.md) when <condition>.
- Run `scripts/<helper>` when <condition>; verify its output before continuing.
- Use `assets/<asset>` as the base artifact when <condition>.

## Constraints

- <Safety or scope boundary.>
- <Required approval or authority boundary.>
- <What the skill must not do.>
```

## `agents/openai.yaml`

```yaml
interface:
  display_name: "<Human-readable title>"
  short_description: "<25-64 character UI summary>"
  default_prompt: "Use $<verb-led-skill-name> to <representative task>."
```

For an explicitly invoked workflow, add:

```yaml
policy:
  allow_implicit_invocation: false
```

Do not create empty resource directories. Add only the files required by the workflow.
