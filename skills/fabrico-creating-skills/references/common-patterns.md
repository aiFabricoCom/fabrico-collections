# Common skill design patterns

Use this reference after the skill's triggers and expected outcomes are clear.

## Instruction-only skill

Use for a short, stable procedure that needs no external files.

```text
skill-name/
└── SKILL.md
```

Keep the entire workflow in the body and include concrete validation.

## Workflow with detailed references

Use when the core sequence is stable but variants, policies, or schemas are large.

```text
skill-name/
├── SKILL.md
└── references/
    ├── variant-a.md
    └── variant-b.md
```

Put selection rules in `SKILL.md`; read only the chosen reference. Link every reference directly from the main file.

## Deterministic helper

Use when repeated parsing, conversion, or validation is safer as executable code.

```text
skill-name/
├── SKILL.md
└── scripts/
    └── validate.sh
```

Document inputs, outputs, failure behavior, and prerequisites. Test the script rather than pasting an unverified implementation into the skill.

## Output asset

Use for a template or media file that should be copied or transformed, not read as instructions.

```text
skill-name/
├── SKILL.md
└── assets/
    └── report.template.md
```

Tell Codex when to use the asset and which placeholders must be replaced.

## Explicit workflow entry point

Use when a user should deliberately start a potentially expensive, mutating, or highly structured procedure.

```text
skill-name/
├── SKILL.md
└── agents/
    └── openai.yaml
```

Set `policy.allow_implicit_invocation: false` and provide a default prompt that names the skill explicitly.

## Skill backed by MCP

Keep the procedure in `SKILL.md` and declare installable MCP dependencies in `agents/openai.yaml` when the server identity and transport are stable. Describe capabilities by purpose rather than hard-coding runtime method names. Include a fallback when the integration is optional.

## Anti-patterns

- One large skill covering unrelated outcomes
- Long descriptions that bury trigger terms
- Reference files linked only from other references
- The same instructions duplicated in the body and a reference
- Untested scripts or environment-specific absolute paths
- Empty resource directories and auxiliary documentation
- An explicit, costly workflow left eligible for implicit invocation
