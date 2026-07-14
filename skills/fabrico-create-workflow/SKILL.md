---
name: fabrico-create-workflow
description: "Create a reusable entry workflow skill for this repository."
---

> **Invocation portability:** `$fabrico-*` below means the discovered entry workflow. Use the unqualified name for repository or filesystem installs and `$fabrico-collections:fabrico-*` for plugin installs.

# Create an explicit workflow

Use the user's current request and referenced files as the workflow specification.

For multi-phase design, ask Codex to delegate coordination to `fabrico-customization-orchestrator`, including the desired outcome, safety boundary, target paths, and acceptance checks. Continue locally if delegation is unavailable and the work remains safe and bounded.

## Supporting skills

- `$fabrico-creating-workflows` for the explicit workflow structure and UI policy
- `$fabrico-creating-skills` for progressive disclosure and resource design
- `$fabrico-technical-context-discovering` when repository conventions or integrations are unclear

## Workflow

1. Define the user-visible outcome, trigger, prerequisites, authority boundary, and terminal condition.
2. Search `.agents/skills/` and `.codex/agents/` for overlapping capabilities and established naming.
3. Choose a verb-led skill name and decide which details belong in references, scripts, or assets.
4. Create `.agents/skills/<name>/SKILL.md` with only `name` and `description` in frontmatter.
5. Create `agents/openai.yaml` with matching UI metadata and `policy.allow_implicit_invocation: false`.
6. Express delegation in plain language. Name the custom agent, bounded objective, required context, constraints, and expected result; keep final synthesis in the workflow.
7. Validate YAML, links, scripts, agent references, stop conditions, and an example `$<name>` invocation.
8. Request a review from `fabrico-customization-reviewer` for substantial workflows, address must-fix findings, and report validation evidence.

Do not implement this as a separate prompt-file or command format. The workflow is a Codex skill whose implicit activation is disabled by UI metadata.
