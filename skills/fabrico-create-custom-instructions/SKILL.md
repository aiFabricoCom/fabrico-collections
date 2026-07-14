---
name: fabrico-create-custom-instructions
description: "Create or update `AGENTS.md` project guidance."
---

> **Invocation portability:** `$fabrico-*` below means the discovered entry workflow. Use the unqualified name for repository or filesystem installs and `$fabrico-collections:fabrico-*` for plugin installs.

# Create custom instructions

Use the user's current request and repository evidence as the instruction requirements.

For multi-directory or conflicting guidance, ask Codex to delegate coordination to `fabrico-customization-orchestrator`. Include intended scope, existing instruction paths, conflicts to resolve, and validation expectations. Continue locally when delegation is unavailable and scope is clear.

## Supporting skills

- `$fabrico-creating-instructions` for discovery, precedence, placement, templates, and checks
- `$fabrico-technical-context-discovering` for verified commands and repository conventions
- `$fabrico-codebase-analysing` when guidance must be derived across several subsystems

## Workflow

1. Inspect global guidance when relevant and every selected instruction file from the repository root to the target working directory.
2. Verify conventions against manifests, CI, linters, tests, generated-code configuration, and current repository behavior.
3. Choose the narrowest durable layer: global, repository root, nested, or same-level override.
4. Create or update plain-Markdown `AGENTS.md` or `AGENTS.override.md`, preserving unrelated existing guidance.
5. Keep shared rules at the broadest applicable level and place only scoped deltas below it.
6. Validate precedence from the intended working directory, run or verify documented commands, and check the combined size budget.
7. Request an independent review when changes span multiple layers or replace existing guidance.
8. Return changed paths, effective scope, precedence decisions, and validation evidence.

Do not treat Markdown links as instruction inclusion. Do not put optional workflows in `AGENTS.md`; encode those as skills instead.
