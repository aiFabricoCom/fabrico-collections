---
name: fabrico-creating-skills
description: "Author repository skills with concise metadata and progressive disclosure."
---

# Creating Codex skills

Build small, discoverable capability packages that contain instructions and only the resources needed to execute them reliably.

## Canonical structure

```text
.agents/skills/<skill-name>/
├── SKILL.md                 # required
├── agents/openai.yaml       # recommended UI metadata
├── scripts/                 # optional deterministic helpers
├── references/              # optional material read on demand
└── assets/                  # optional files copied or used in output
```

Repository skills live under `.agents/skills/`; personal skills live under `$HOME/.agents/skills/`. Keep the folder name identical to the `name` value.

## Creation workflow

1. Collect concrete requests that should and should not activate the skill.
2. Search existing skills to avoid overlap and identify repository naming conventions.
3. Choose a lowercase, hyphenated, verb-led name under 64 characters.
4. Plan what belongs in the activation body and what should be a script, reference, or asset.
5. Write `SKILL.md` frontmatter with only `name` and `description`.
6. Write the body in imperative language. Keep the core procedure, decision rules, safety boundaries, resource routing, and validation steps.
7. Add `agents/openai.yaml` when UI metadata improves discovery. Set `allow_implicit_invocation: false` only for workflows that must be started explicitly.
8. Run bundled scripts on representative input and validate frontmatter, links, names, and examples.
9. Forward-test complex skills on a realistic request when doing so is safe and bounded.

## Description design

The description is the primary trigger. State the capability first, then concrete trigger contexts and important exclusions. Front-load decisive terms because catalogs may shorten long descriptions.

Avoid generic claims such as “helps with development.” Distinguish the skill from adjacent capabilities in one or two compact sentences.

## Progressive disclosure

- **Metadata:** name, description, and path are visible before activation.
- **Activation:** `SKILL.md` is loaded when selected.
- **Resources:** supporting files are read or executed only when the task needs them.

Keep `SKILL.md` below 500 lines. Link references directly from it and avoid reference chains. Put a short table of contents in reference files longer than 100 lines.

Use resources deliberately:

- `scripts/` for repeated operations that benefit from deterministic execution
- `references/` for detailed schemas, policies, variants, and examples Codex may need to read
- `assets/` for templates, media, or boilerplate used in an output rather than read as guidance

Do not add auxiliary readmes, changelogs, installation guides, or duplicate explanations.

## UI metadata

When creating `agents/openai.yaml`:

- quote every string value;
- keep `short_description` between 25 and 64 characters;
- make `default_prompt` one sentence that explicitly mentions `$<skill-name>`;
- omit icons and brand fields unless assets were provided;
- use `policy.allow_implicit_invocation: false` for explicit workflow entry points, otherwise omit the policy or set it to true.

## Validation checklist

- [ ] Folder and skill names match and satisfy naming rules.
- [ ] Frontmatter contains only `name` and `description`.
- [ ] Description states capability, triggers, and meaningful boundaries.
- [ ] Body is concise, imperative, and free of duplicated resource content.
- [ ] Every linked resource exists and is one hop from `SKILL.md`.
- [ ] Bundled scripts execute successfully on representative input.
- [ ] `agents/openai.yaml`, when present, matches the skill and parses as YAML.
- [ ] Explicit workflows disable implicit invocation; ordinary capability skills remain discoverable.
- [ ] Examples contain no secrets, environment-specific paths, or unresolved placeholders.

Start from [skill.template.md](skill.template.md). Read [common-patterns.md](references/common-patterns.md) when selecting a resource layout. See [reviewing-code.skill.md](examples/reviewing-code.skill.md) for a complete compact example.
