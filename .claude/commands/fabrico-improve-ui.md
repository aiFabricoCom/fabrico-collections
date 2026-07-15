---
description: "Audit and improve an existing web, iOS, or Android UI with evidence-backed changes and platform-specific verification."
argument-hint: "[project path] [web|ios|android] [optional screens, flow, or design context]"
---

> **Delegate to the `fabrico-engineering-manager` subagent.** Launch it with the Task tool (subagent_type: `fabrico-engineering-manager`), passing this entire command, the user's request below, and referenced context. Adopt its orchestration contract. For this workflow, the authority contract below replaces normal phase confirmations only for `AUTO` items; it does not relax quality gates or authorize external actions.

<goal>
Audit and improve an existing application's UI across the requested web, iOS, Android, or shared-mobile targets.
Establish a rendered baseline, prioritize evidence-backed findings, implement only the authorized bounded changes,
and prove the result with comparable visual, interaction, accessibility, and project-check evidence.

This workflow improves an existing product. It does not scaffold a missing platform, invent a new brand direction,
or silently redesign product behavior.

The request: $ARGUMENTS
</goal>

<input-requirements>
Resolve an existing project path plus any requested platform, screen, flow, design, screenshot, or acceptance
context. If no path is provided, use the current workspace only when it contains one unambiguous project.

Ask one focused question only when the target or meaningful audit boundary cannot be established. Mark a requested
but absent platform as `NOT PRESENT`; do not create it.
</input-requirements>

<required-skills>
## Required Skills

Before starting, load and follow these skills as applicable:

- `fabrico-improving-ui` — platform coverage, audit criteria, evidence, prioritization, and completion states
- `fabrico-technical-context-discovering` and `fabrico-codebase-analysing` — project conventions, targets, shared UI, design tokens, and runnable commands
- `fabrico-implementation-gap-analysing` — compare the intended UI outcome with the current implementation
- `fabrico-ensuring-accessibility` — web accessibility; use native APIs and project checks for iOS and Android
- `fabrico-implementing-frontend` and `fabrico-optimizing-frontend` — compatible web or shared-framework changes
- `fabrico-reviewing-frontend` and `fabrico-code-reviewing` — final implementation review
</required-skills>

<authority-contract>
## Authority

Invocation authorizes read-only inspection, starting existing local development runtimes, and local reversible
source and test changes that are objective, high-confidence, low-risk, and within the existing product behavior,
information architecture, design system, and requested scope. Preserve unrelated and pre-existing user changes.

Request approval before changing brand direction, navigation or information architecture, product meaning or copy,
core flows, cross-platform behavior, public APIs, dependencies, design tokens, generated or licensed assets, or
before a broad visual redesign.

Production or live-data access, deployment, store submission, publishing, releases, commits, pushes, paid services,
credentials, destructive operations, and outbound messages are not authorized by this command.
</authority-contract>

<workflow>
## Workflow

1. **Resolve target and coverage.** Read applicable project guidance, inspect repository status, detect the actual
   web, iOS, Android, and shared-code targets, and build a coverage matrix for the requested platforms, screens,
   flows, states, themes, device classes, and orientations. Distinguish exhaustive coverage from sampling.
2. **Establish UI intent.** Inspect approved specifications and designs, the existing design system and tokens,
   platform conventions, and available research. Treat an approved design as authoritative only for its stated
   scope. Without a design, improve the existing product rather than inventing a new visual direction.
3. **Capture the baseline.** Follow `fabrico-improving-ui` to run each available target with existing project
   commands and safe data. Capture representative UI states, runtime screenshots, accessibility evidence,
   interactions, and relevant diagnostics. Label findings `OBSERVED` or `INFERRED`; source inspection alone is not
   rendered verification.
4. **Audit and prioritize.** Create or update `UI-IMPROVEMENT-REPORT.md` with the coverage matrix and improvement
   register defined by `fabrico-improving-ui`. Prioritize user impact, accessibility, broken layouts, and important
   states over cosmetic taste.
5. **Freeze the change set.** Classify every recommendation as `AUTO`, `APPROVAL REQUIRED`, or `DEFERRED` using the
   supporting skill. Present the prioritized register. Continue all independent `AUTO` items without another phase
   confirmation and batch approval-required decisions into one focused request.
6. **Implement bounded improvements.** Delegate product changes to `fabrico-software-engineer`, passing this
   command's explicit autonomy contract, the frozen `AUTO` register, coverage matrix, target roots, authority
   boundary, and expected evidence. Use
   `/fabrico-implement-ui-common-task` only for web UI whose approved Figma design is the target. For native Figma
   work and all design-free targets, use `/fabrico-implement-common-task` with the relevant platform context.
   Keep overlapping writes serial, reuse existing components and tokens, and run targeted checks after each batch.
7. **Verify and correct.** Re-run the baseline matrix and collect comparable before/after evidence. For a web target
   with both an accessible Figma reference and a running URL, delegate an independent pass to
   `fabrico-ui-reviewer` through `/fabrico-review-ui`. Do not use that web-only reviewer for native or design-free
   audits. Verify iOS and Android with the project's existing build, simulator or emulator, device, accessibility,
   UI, screenshot, lint, and test paths as available. Delegate an independent code review to
   `fabrico-code-reviewer` with `/fabrico-review`, delegate fixes to the proper owner, and allow at most three
   complete correction cycles.
8. **Report.** Complete `UI-IMPROVEMENT-REPORT.md` and return the essential evidence in chat: scope, unavailable
   targets, changed files, before/after evidence, exact checks and results, review findings, deferred proposals,
   and one completion state for every requested platform.
</workflow>

<output-specification>
## Output

Create or update `UI-IMPROVEMENT-REPORT.md`. Report each requested platform as:

- `VERIFIED` — runtime visual, interaction, accessibility, and required project checks passed after implementation
- `PARTIALLY VERIFIED` — safe changes were made, but runtime, device, state, screenshot, or assistive-technology evidence is incomplete
- `NOT PRESENT` — the requested platform does not exist in the project
- `BLOCKED` — no safe implementation or verification path exists

Report overall `COMPLETE` only when every existing in-scope platform is `VERIFIED`, required review passes, and no
unresolved `CRITICAL` or `MAJOR` finding remains. Use `COMPLETE WITH ACCEPTED EXCEPTIONS` only for exceptions the
user explicitly accepted. Otherwise report `INCOMPLETE` or `BLOCKED`.
</output-specification>

<constraints>
## Constraints

- Never claim visual improvement from source changes, green builds, snapshots, or inferred evidence alone.
- Do not use the web-only `fabrico-ui-reviewer` as evidence for iOS or Android verification.
- Do not make subjective visual changes from low-confidence evidence.
- Stop for the smallest required decision when authoritative sources conflict, the change crosses the authority
  boundary, safe data or access is unavailable, unrelated user changes cannot be preserved, or three correction
  cycles fail.
</constraints>

<!-- FABRICO_COLLECTIONS:command:fabrico-improve-ui:v1 -->
