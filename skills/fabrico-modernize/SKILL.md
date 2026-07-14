---
name: fabrico-modernize
description: "Create a migration plan and rebuild on the selected target."
---

> **Invocation portability:** `$fabrico-*` below means the discovered entry workflow. Use the unqualified name for repository or filesystem installs and `$fabrico-collections:fabrico-*` for plugin installs.

## Input

Use the user’s current request as the workflow input. Expected context: `<url of running app | path to SPEC.md> [target: web|ios|react-native]`.

> **Delegate the build phase to the `fabrico-engineering-manager` custom agent** once the spec and migration plan
> exist. Spawn it through Codex subagent delegation and adopt the autonomy contract from
> `$fabrico-autopilot` for the rebuild. If that profile is unavailable, as in a skills-only plugin installation,
> perform the build phase in the current thread with the referenced skills and the same autonomy and quality gates.
## Goal

Take an existing web application and rebuild it on a modern target — modern web, native iOS, or cross-platform
React Native — preserving behavior and reaching feature parity, with as little manual babysitting as possible.

## Required skills

- `fabrico-reverse-engineering-spec` — to derive the SPEC if given a URL.
- `fabrico-planning-migration` — to choose/confirm the target, build the parity matrix, and plan data/auth/UX.
- `fabrico-technical-context-discovering`, `fabrico-architecture-designing` — for the target architecture.

## Workflow

1. **Get the SPEC.** If `the user’s request` is a URL → run the `$fabrico-reverse-spec` flow first to produce `SPEC.md`.
   If it's a path to an existing `SPEC.md` → use it. If neither is resolvable → ask the user (direct user question).
2. **Determine the target.** Read it from `the user’s request` (`web` | `ios` | `react-native`). If absent, use
   direct user question to pick one (with the trade-offs from `fabrico-planning-migration`). Write the chosen target
   into the SPEC's **Target** section.
3. **Plan the migration.** Follow `fabrico-planning-migration` to produce `MIGRATION-PLAN.md`: stack mapping,
   feature-parity matrix (port-as-is / adapt / drop), data migration, auth, UX adaptation (esp. web → mobile),
   risks, and phasing.
4. **Review checkpoint (single gate).** Present a concise summary of `SPEC.md` + `MIGRATION-PLAN.md` and the open
   questions, and ask the user to confirm or edit the target, parity decisions, and any dropped features. (If the
   user said to run fully autonomously, skip this gate, log decisions to `ASSUMPTIONS.md`, and continue.)
5. **Rebuild autonomously.** Delegate to `fabrico-engineering-manager` using the `$fabrico-autopilot` autonomy
   contract: scaffold the target stack → implement each story in parity-matrix order with tests → run quality
   gates → `git commit` per feature → code review. Honor the data-migration and integration plan (stub external
   services behind interfaces until the user provides keys).
6. **Output `BUILD-SUMMARY.md`** plus a **parity report**: each legacy feature → built / adapted / pending, what
   the user must still provide (keys, data export access, Apple developer account for iOS), and how to run/build.

## Constraints

- Preserve behavior; modernize presentation. Don't drop a legacy feature without it being marked in the parity
  matrix and confirmed.
- Never commit secrets; never deploy, charge, send real messages, or migrate production data without explicit
  approval. Use `.env.example` and a mock/stub for any integration whose credentials aren't provided.
- For `ios` (SwiftUI), building/running on-device needs Xcode + an Apple developer account — note this in the
  summary; produce the buildable project and tests regardless.

