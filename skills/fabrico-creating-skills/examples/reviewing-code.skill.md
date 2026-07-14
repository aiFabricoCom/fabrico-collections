# Example: compact code-review skill

## `SKILL.md`

```markdown
---
name: reviewing-code
description: Review code changes for correctness, regressions, security, and missing tests. Use for diffs, branches, or pull requests.
---

# Reviewing code

## Workflow

1. Establish the review base, intended behavior, and applicable repository guidance.
2. Inspect the complete diff, then read surrounding code for every behavior-changing hunk.
3. Trace changed inputs, state transitions, error paths, and externally visible effects.
4. Check existing tests and identify behavior that changed without coverage.
5. Run the smallest relevant read-only verification commands when available.
6. Report only actionable findings, ordered by severity, with file and line references.

## Finding format

- **Severity and title**
- **Location**
- **Failure scenario**
- **Why it matters**
- **Suggested direction**

If no findings remain, say so and list residual test or environment gaps.

## Constraints

- Do not edit reviewed files unless the user separately asks for fixes.
- Do not report style preferences as defects unless repository guidance requires them.
- Do not infer a failure without tracing a concrete scenario.
```

## `agents/openai.yaml`

```yaml
interface:
  display_name: "Reviewing Code"
  short_description: "Find regressions and missing test coverage"
  default_prompt: "Use $reviewing-code to review the current branch against its base."
```

This example stays instruction-only because the procedure needs no reusable scripts, references, or assets.
