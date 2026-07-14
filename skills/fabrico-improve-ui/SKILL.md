---
name: fabrico-improve-ui
description: "Audit and improve an existing web, iOS, or Android UI with prioritized recommendations, safe implementation, and visual and accessibility verification."
---

> **Invocation portability:** `$fabrico-*` below means the discovered entry workflow. Use the unqualified name for repository or filesystem installs and `$fabrico-collections:fabrico-*` for plugin installs.

# Improve application UI

Use the user's current request as input. Expected context: an existing project path and optional platform, screen,
flow, design, screenshot, or acceptance context. This workflow audits current UI, proposes evidence-backed
improvements, implements the authorized changes, and verifies the result. It does not create a missing application
platform or replace a product redesign process.

If a named custom-agent profile is unavailable, as in a skills-only plugin installation, perform that bounded step
in the current thread with the referenced skills and preserve the same authority, evidence, verification, and review
gates. Never stop solely because delegation is unavailable.

## Supporting skills and reference

- `fabrico-technical-context-discovering` and `fabrico-codebase-analysing` to identify platforms, conventions,
  shared UI, design tokens, and runnable commands
- `fabrico-ensuring-accessibility` for web accessibility; use the target platform's native accessibility APIs,
  tests, and current official guidance for iOS and Android
- `fabrico-implementing-frontend` and `fabrico-optimizing-frontend` for compatible web or shared-framework work
- `fabrico-reviewing-frontend` and `fabrico-code-reviewing` for final review

After resolving the target platforms, read [platform UI audit checks](references/platform-ui-audit.md) and apply
only the relevant sections.

## Autonomy and authority

Invocation authorizes read-only UI inspection, starting existing local development runtimes, and local reversible
source and test changes that are objective, high-confidence, low-risk, and within the existing product behavior,
information architecture, design system, and requested scope. Preserve unrelated and pre-existing user changes.

Request approval before changing brand direction, navigation or information architecture, product meaning or copy,
core flows, cross-platform behavior, public APIs, dependencies, design tokens, generated or licensed assets, or
before a broad visual redesign. Production access, live data, deployment, store submission, publishing, releases,
commits, pushes, paid services, credentials, and destructive operations are outside this workflow.

## Workflow

1. **Resolve target and coverage.** Resolve the project path, read applicable guidance, inspect repository status,
   and detect the actual web, iOS, Android, and shared-code targets. Build a coverage matrix of requested platforms,
   screens, flows, states, themes, device classes, and orientations. Mark a requested but absent platform as
   `NOT PRESENT`; do not scaffold it. Distinguish exhaustive coverage from sampling and never claim a whole-app
   audit from a sample. Ask one focused question only when the target or meaningful audit boundary cannot be
   established.
2. **Establish UI intent.** Inspect the current request, approved specifications and designs, existing design
   system and tokens, platform conventions, and available user-research evidence. Treat an approved design as
   authoritative for its stated scope, but record accessibility, usability, or product conflicts instead of
   silently reproducing them. Without a design, improve the existing product rather than inventing a new visual
   direction.
3. **Capture the baseline.** Run each in-scope target with existing project commands and safe test data. Exercise
   representative screens and important default, loading, empty, error, validation, disabled, selected, focus,
   keyboard, text-scaling, light or dark, responsive, safe-area, and rotation states where supported. Collect
   runtime screenshots, accessibility structure or scan results, interaction observations, and relevant console
   or runtime diagnostics. Label every finding as `OBSERVED` or `INFERRED`.

   If a platform cannot be launched, use existing trustworthy screenshots, previews, snapshots, tests, and source
   inspection as secondary evidence. Do not describe source inspection as rendered or interaction verification.
   If neither a runnable target nor trustworthy captures exist, limit that platform to a source-level audit and
   report the limitation. Continue safe work on other platforms; request a simulator, device, URL, authentication,
   or screenshots only when a proposed change cannot be made safely without them.
4. **Audit and prioritize.** Evaluate task completion and usability, information hierarchy, consistency and design
   tokens, responsive or adaptive layout, feedback and UI states, accessibility, touch and keyboard interaction,
   platform conventions, localization and text scaling, and obvious perceived-performance issues. Create or update
   `UI-IMPROVEMENT-REPORT.md` with an improvement register containing platform and screen, evidence, issue, user
   impact, recommendation, severity, confidence, effort, implementation risk, authority class, affected scope, and
   verification method. Use one workflow severity scale:
   - `CRITICAL`: prevents a core task or creates a serious accessibility, safety, or unusable-layout failure.
   - `MAJOR`: materially harms usability, accessibility, responsive behavior, or an important screen or state.
   - `MINOR`: a limited, non-blocking defect with clear evidence.
   - `OPPORTUNITY`: an optional enhancement rather than a defect.

   Normalize reviewer terminology by user impact. Map `critical` to `CRITICAL` and `major` to `MAJOR`. Map a
   `warning` to `MAJOR` when it violates a requirement, accessibility rule, or important task; otherwise map it to
   `MINOR`. Map `minor` to `MINOR` and `suggestion` to `OPPORTUNITY` unless the definitions above require a higher
   severity. Prioritize `CRITICAL` and high-reach `MAJOR` findings over cosmetic preference; do not present taste as
   evidence.
5. **Freeze the change set.** Classify every recommendation:
   - `AUTO`: objective, high-confidence, local, and reversible; preserves behavior, information architecture,
     brand, existing tokens, and public contracts.
   - `APPROVAL REQUIRED`: subjective, medium or low confidence, broad, behavioral, brand, navigation, new
     dependency or asset, cross-platform parity decision, or otherwise high-impact.
   - `DEFERRED`: unsupported, out of scope, explicitly declined, or accepted for later.

   Present the prioritized register before implementation. Proceed with all independent `AUTO` items without
   another phase confirmation. Batch approval-required decisions into one focused request and do not block safe,
   unrelated items while waiting.
6. **Implement bounded improvements.** For substantial or multi-platform work, prefer
   `fabrico-engineering-manager` and pass the coverage matrix, frozen register, platform roots, authority boundary,
   and expected evidence as an implementation-ready scope. Delegate product-code changes to
   `fabrico-software-engineer`; if either profile is unavailable, implement the frozen bounded scope in the current
   thread with the same supporting skills. Keep overlapping writes serial and parallelize only disjoint targets. Use
   `$fabrico-implement-ui-common-task` only when an approved Figma design is the implementation target for a web
   UI. For native Figma work, use `$fabrico-implement-common-task` with the relevant design context plus the native
   accessibility, build, simulator or device, and platform checks from the reference. Use
   `$fabrico-implement-common-task` for all other targets. Reuse current components, tokens, assets, and platform
   patterns. Avoid speculative features, sweeping refactors, and unrelated cleanup. Run targeted static checks and
   tests after every bounded batch.
7. **Verify and correct.** Re-run the same screen, state, device, theme, interaction, and accessibility matrix used
   for the baseline. Capture comparable before and after evidence and run relevant lint, type-check, unit,
   integration, UI, build, and platform checks. When a web target has both an accessible Figma reference and a
   running URL, request an independent pass from `fabrico-ui-reviewer` through `$fabrico-review-ui`; do not use
   that agent for native or design-free audits. Request a separate, non-implementing code review through
   `$fabrico-review`, preferably from `fabrico-code-reviewer`. Fix every in-scope `CRITICAL` and `MAJOR` finding
   plus the selected `MINOR` items, then re-verify. Allow at most three full correction cycles. If no separate
   review context is available, record a provisional same-thread review and do not report `COMPLETE` unless the
   user explicitly accepts that limitation.
8. **Report.** Complete `UI-IMPROVEMENT-REPORT.md` with audit scope and coverage, unavailable targets, evidence
   sources, the prioritized register, approval decisions, changed files, before and after evidence, exact checks
   and results, review findings, deferred proposals, and platform-specific status. Return the same essential
   evidence in chat.

## Completion states

Report every requested platform as:

- `VERIFIED`: runtime visual, interaction, accessibility, and required project checks passed after implementation
- `PARTIALLY VERIFIED`: safe changes were made, but runtime, device, state, screenshot, or assistive-technology
  evidence remains unavailable
- `NOT PRESENT`: the requested platform does not exist in the target project
- `BLOCKED`: no safe implementation or verification path exists

Report overall `COMPLETE` only when every existing in-scope platform is `VERIFIED`, required review passes, and no
unresolved `CRITICAL` or `MAJOR` finding remains. Use `COMPLETE WITH ACCEPTED EXCEPTIONS` only when the user
explicitly accepts a `CRITICAL` or `MAJOR` deferral or a missing review or verification gate. Otherwise report
`INCOMPLETE` or `BLOCKED`. Never claim visual improvement solely from source changes, green builds, snapshots, or
inferred evidence.

## Stop conditions

Stop with the smallest required decision when scope is ambiguous, authoritative sources materially conflict, a
change crosses the authority boundary, safe test data or access is unavailable, the only runtime would touch
production or live data, unrelated user changes cannot be preserved, or three correction cycles fail. Missing
simulators or screenshots alone cause limited evidence and `PARTIALLY VERIFIED`; they are a blocker only when the
next proposed change cannot be implemented safely without rendered evidence.
