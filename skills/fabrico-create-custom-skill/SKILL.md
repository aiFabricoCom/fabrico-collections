---
name: fabrico-create-custom-skill
description: "Create a supporting skill in the repository skill directory."
---

> **Invocation portability:** `$fabrico-*` below means the discovered entry workflow. Use the unqualified name for repository or filesystem installs and `$fabrico-collections:fabrico-*` for plugin installs.

# Create a custom skill

Treat the user's current request, attachments, and referenced workspace files as the skill requirements.

For complex creation work, ask Codex to delegate coordination to `fabrico-customization-orchestrator`. Provide the intended triggers, exclusions, target scope, resources, constraints, and acceptance criteria. If delegation is unavailable, follow the same process locally.

## Supporting skills

- `$fabrico-creating-skills` for naming, progressive disclosure, UI metadata, and validation
- `$fabrico-technical-context-discovering` when repository conventions must be established
- `$fabrico-codebase-analysing` when overlap across many skills must be assessed

## Workflow

1. Identify concrete requests that should and should not activate the skill.
2. Inspect `.agents/skills/` for overlap, naming patterns, and reusable resources.
3. Choose a lowercase, hyphenated, verb-led name under 64 characters.
4. Plan the smallest useful package: `SKILL.md` plus only necessary scripts, references, assets, and UI metadata.
5. Create the skill with frontmatter containing only `name` and `description`; make the body concise and imperative.
6. Add `agents/openai.yaml` when useful. Disable implicit invocation only when the new skill is deliberately an explicit workflow.
7. Test every bundled script and validate frontmatter, links, names, descriptions, examples, and resource routing.
8. Forward-test complex behavior when safe, then request an independent review for substantial additions.
9. Return changed paths, activation design, resources added, and validation evidence.

Do not create auxiliary documentation or empty resource directories. Do not force one naming grammar when the repository already has a clearer consistent convention.
