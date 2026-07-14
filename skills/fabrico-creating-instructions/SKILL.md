---
name: fabrico-creating-instructions
description: "Author root or nested `AGENTS.md` and `AGENTS.override.md` guidance."
---

# Creating Codex instructions

Encode durable working agreements in the smallest `AGENTS.md` layer that matches their scope.

## Discovery and precedence

Codex can load:

- `~/.codex/AGENTS.md` for personal defaults across repositories
- `AGENTS.md` at the repository root for shared project guidance
- nested `AGENTS.md` files between the repository root and current working directory for narrower guidance
- `AGENTS.override.md` in place of `AGENTS.md` at the same directory level

At each directory level, Codex selects at most one instruction file: `AGENTS.override.md` first, then `AGENTS.md`, then configured fallback filenames. It combines selected files from broadest to closest, so later guidance can refine earlier guidance.

Project instruction discovery follows the current working directory. Place nested files where sessions for that subtree are launched, and keep essential repository-wide rules at the root.

Markdown links are references for a reader; they do not load another file as instructions. Keep shared rules in the broadest applicable `AGENTS.md` and put only deltas in nested files.

## Placement decision

- Use the root file for setup, architecture boundaries, standard commands, verification, and review expectations that apply everywhere.
- Use a nested file for a subsystem with materially different commands or conventions.
- Use an override when the regular file at that level must be temporarily or deliberately replaced, not merely extended.
- Use a skill for an optional repeatable workflow.
- Use `.codex/config.toml` for models, sandboxing, MCP, hooks, feature flags, and fallback filename configuration.
- Use the current prompt for one-off task constraints.

## Creation workflow

1. Inspect existing instruction files from the repository root to the target directory, plus build manifests, CI, linters, and test configuration.
2. Extract verified commands and conventions. Prefer repository evidence over assumptions.
3. Choose the narrowest durable scope and decide whether to create, merge, or replace.
4. Preserve unrelated existing guidance and resolve contradictions explicitly.
5. Write concise, actionable rules with exact commands and observable verification expectations.
6. Remove duplicated formatter, linter, or type-system rules unless Codex needs routing guidance to run them.
7. Validate placement, precedence, command accuracy, and combined size from the intended working directory.

## Content guidance

Prioritize:

- repository layout and authoritative source locations
- setup, build, test, lint, format, and generated-code commands
- architecture and ownership boundaries not enforced mechanically
- file-editing and dependency policies
- required verification and review expectations
- scoped safety restrictions and external-action boundaries

Avoid biographies, generic engineering advice, stale architecture summaries, secrets, and exhaustive documentation copies. Keep combined guidance under Codex's configured document budget; the default is 32 KiB.

## Validation checklist

- [ ] File is plain Markdown with no metadata header.
- [ ] Placement matches the intended current-working-directory scope.
- [ ] Same-level override behavior is intentional.
- [ ] Nested guidance contains deltas and does not contradict broader rules accidentally.
- [ ] Every command exists and is appropriate for the stated scope.
- [ ] Guidance is repository-specific, actionable, and not duplicated elsewhere.
- [ ] No secrets, personal credentials, or environment-specific private paths are embedded.
- [ ] Combined instructions fit within the configured size budget.

Use [agents-md.template.md](assets/agents-md.template.md) for a repository root and [nested-agents-md.template.md](assets/nested-agents-md.template.md) for a scoped delta or override.
