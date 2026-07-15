---
description: "Finish a designated existing project by closing scoped gaps and proving its definition of done."
argument-hint: "[project path and optional spec, plan, backlog, issue, or acceptance context]"
---

> **Delegate to the `fabrico-engineering-manager` subagent.** Launch it with the Task tool (subagent_type: `fabrico-engineering-manager`), passing this entire command, the user's request below, and referenced context. Adopt its orchestration contract. For this workflow, the authority contract below replaces normal phase confirmations within the frozen completion scope; it does not relax quality gates or authorize external actions.

<goal>
Finish an existing, partially implemented project by establishing an objective completion contract, closing only
the remaining in-scope gaps, and proving completion with executable evidence and an independent review.

Use `/fabrico-autopilot` for a new build from a complete specification and `/fabrico-implement` for one feature or
task.

The request: $ARGUMENTS
</goal>

<input-requirements>
Resolve an existing project path plus any specification, plan, backlog, issue, or acceptance criteria that defines
completion. If no path is provided, use the current workspace only when it contains one unambiguous project. If the
target is empty or not meaningfully started, stop and recommend `/fabrico-autopilot`.
</input-requirements>

<required-skills>
## Required Skills

Before starting, load and follow these skills as applicable:

- `fabrico-technical-context-discovering` and `fabrico-codebase-analysing` — establish project state and conventions
- `fabrico-task-analysing` — clarify an incomplete completion baseline
- `fabrico-implementation-gap-analysing` — compare expected and actual state
- `fabrico-architecture-designing` — resolve material design decisions in remaining work
- `fabrico-code-reviewing` — independent completion review
</required-skills>

<authority-contract>
## Authority

Invocation authorizes local, reversible changes within the frozen completion scope and routine transitions through
analysis, planning, implementation, verification, and review. Preserve unrelated and pre-existing user changes.

It does not authorize scope expansion, destructive operations, production or live-data changes, deployment,
publishing, releases, commits, pushes, paid services, outbound messages, or creating or disclosing credentials.
Stop and request explicit approval before any such action.
</authority-contract>

<workflow>
## Workflow

1. **Resolve the target.** Read applicable guidance and inspect repository status. Confirm that the target is an
   existing, meaningfully started project and preserve all unrelated work.
2. **Freeze the completion contract.** Derive scope in this order: the current request; referenced approved
   specifications, plans, issues, and acceptance criteria; then executable project documentation and tests. Build a
   completion matrix containing each requirement, source, scope decision, current status, required change, and
   verification evidence. Treat unreferenced TODOs, roadmap items, and general technical debt as evidence to inspect,
   not automatic scope. Ask one focused question if the outcome cannot be established objectively.
3. **Establish the baseline.** Discover and run the project's safe relevant unit, integration, E2E, lint,
   type-check, build, container, migration, and UI-verification commands. Classify each contract item as `VERIFIED`,
   `PARTIAL`, `MISSING`, `BLOCKED`, or `OUT OF SCOPE`. A pre-existing failure is in scope only when it violates the
   completion contract.
4. **Plan only the remaining gap.** Reuse an existing plan when present; otherwise create the smallest ordered
   remaining-work plan. Delegate research or architecture only where the matrix shows a real gap. Assign bounded
   implementation to the appropriate specialist and pass this command's explicit autonomy contract plus the frozen
   completion matrix. Keep overlapping writes serial and parallelize only disjoint scopes.
5. **Implement and verify incrementally.** Make the minimum changes required by the frozen contract. After every
   bounded task, run targeted checks and update the completion matrix and any existing plan checklist only when the
   evidence supports completion. Stop for a decision if new information would materially alter behavior,
   architecture, data, dependencies, or scope.
6. **Review and correct.** Delegate a separate, non-implementing review to `fabrico-code-reviewer` with
   `/fabrico-review` against the full completion contract, not only the diff. Delegate fixes to the proper owner,
   rerun affected checks, and review again. Allow at most three complete correction-and-review cycles. Treat
   same-thread review as provisional unless the user explicitly accepts it as an exception.
7. **Prove completion.** Run the complete relevant verification suite once after the last change, including UI
   verification when designs or visual acceptance criteria exist. Mark the project `COMPLETE` only when every
   in-scope matrix item is verified, every required gate passes, and no unresolved correctness, security,
   data-safety, or acceptance blocker remains.
8. **Report.** Create or update `COMPLETION-SUMMARY.md` with scope sources, final status, the requirement-to-evidence
   matrix, changed files, exact checks and results, review cycles, accepted exceptions, unresolved blockers, and any
   remaining user action. Return the same essential evidence in chat.
</workflow>

<output-specification>
## Output

Create or update `COMPLETION-SUMMARY.md` and report one of:

- `COMPLETE` — every in-scope item is verified and all required gates pass
- `COMPLETE WITH ACCEPTED EXCEPTIONS` — only for exceptions explicitly accepted by the user
- `INCOMPLETE` — required work or verification remains
- `BLOCKED` — no safe continuation path exists without user input or external access

Never claim completion from code changes, checked boxes, or green tests alone; map every requirement to evidence.
</output-specification>

<constraints>
## Constraints

- Do not expand scope to unrelated TODOs, roadmap items, improvements, refactors, or upgrades.
- Do not hide pre-existing failures by overwriting unrelated work.
- Stop with the smallest required decision when the target or completion contract is ambiguous, authoritative
  sources conflict, required access is unavailable, an action crosses the authority boundary, safe verification
  cannot be performed, or three correction cycles fail.
</constraints>

<!-- FABRICO_COLLECTIONS:command:fabrico-finish-project:v1 -->
