---
description: "Modernize or port a legacy web app end to end: reverse-engineer a SPEC.md from the running app, plan the migration to a chosen target (modern web, native iOS, or React Native), then rebuild it autonomously. The spec is platform-agnostic; you pick the target at build time."
argument-hint: "<url of running app | path to SPEC.md> [target: web|ios|react-native]"
---

> **Delegate the build phase to the `fabrico-engineering-manager` subagent** (Task tool, subagent_type:
> `fabrico-engineering-manager`) once the spec and migration plan exist. Adopt the autonomy contract from
> `/fabrico-autopilot` for the rebuild.

Input: $ARGUMENTS

## Goal

Take an existing web application and rebuild it on a modern target — modern web, native iOS, or cross-platform
React Native — preserving behavior and reaching feature parity, with as little manual babysitting as possible.

## Required skills

- `fabrico-reverse-engineering-spec` — to derive the SPEC if given a URL.
- `fabrico-planning-migration` — to choose/confirm the target, build the parity matrix, and plan data/auth/UX.
- `fabrico-technical-context-discovering`, `fabrico-architecture-designing` — for the target architecture.

## Workflow

1. **Get the SPEC.** If `$ARGUMENTS` is a URL → run the `/fabrico-reverse-spec` flow first to produce `SPEC.md`.
   If it's a path to an existing `SPEC.md` → use it. If neither is resolvable → ask the user (AskUserQuestion).
2. **Determine the target.** Read it from `$ARGUMENTS` (`web` | `ios` | `react-native`). If absent, use
   AskUserQuestion to pick one (with the trade-offs from `fabrico-planning-migration`). Write the chosen target
   into the SPEC's **Target** section.
3. **Plan the migration.** Follow `fabrico-planning-migration` to produce `MIGRATION-PLAN.md`: stack mapping,
   feature-parity matrix (port-as-is / adapt / drop), data migration, auth, UX adaptation (esp. web → mobile),
   risks, and phasing.
4. **Review checkpoint (single gate).** Present a concise summary of `SPEC.md` + `MIGRATION-PLAN.md` and the open
   questions, and ask the user to confirm or edit the target, parity decisions, and any dropped features. (If the
   user said to run fully autonomously, skip this gate, log decisions to `ASSUMPTIONS.md`, and continue.)
5. **Rebuild autonomously.** Delegate to `fabrico-engineering-manager` using the `/fabrico-autopilot` autonomy
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

<!-- FABRICO_COLLECTIONS:command:fabrico-modernize:v1 -->
