---
name: fabrico-finish-project
description: "Finish a designated existing project by closing scoped gaps, validating its definition of done, and reporting completion evidence."
---

> **Invocation portability:** `$fabrico-*` below means the discovered entry workflow. Use the unqualified name for repository or filesystem installs and `$fabrico-collections:fabrico-*` for plugin installs.

# Finish an existing project

Use the user's current request as input. Expected context: a project path plus any specification, plan, backlog,
issue, or acceptance criteria that defines completion. This workflow closes an existing, partially implemented
project; use `$fabrico-autopilot` for a new build from a complete specification and `$fabrico-implement` for one
feature or task.

## Supporting skills

- `fabrico-technical-context-discovering` and `fabrico-codebase-analysing` to establish project state and conventions
- `fabrico-task-analysing` only when the completion baseline is incomplete
- `fabrico-implementation-gap-analysing` to compare expected and actual state
- `fabrico-architecture-designing` when remaining work needs a material design decision
- `fabrico-code-reviewing` for the independent completion review

## Autonomy and authority

Invoking this workflow authorizes local, reversible changes within the agreed completion scope and routine
transitions through analysis, planning, implementation, verification, and review. Do not pause between those
phases.

It does not authorize scope expansion, destructive operations, production or live-data changes, deployment,
publishing, releases, commits or pushes, paid services, outbound messages, or creating or disclosing credentials.
Stop and request explicit approval before any such action.

## Workflow

1. **Resolve the target.** Prefer the explicit path in the request. If the user says "this project" or gives no
   path, use the current workspace only when it contains one unambiguous project. Otherwise ask for the target.
   Read applicable guidance and inspect repository status; preserve all unrelated and pre-existing user changes.
   If the target is empty or not meaningfully started, stop and recommend `$fabrico-autopilot`.
2. **Freeze the completion contract.** Derive scope in this order: the current request; referenced approved
   specifications, plans, issues, and acceptance criteria; then executable project documentation and tests.
   Resolve material conflicts with the user. Unreferenced TODOs, roadmap items, improvement lists, and general
   technical debt are evidence to inspect, not automatic scope. Build a completion matrix containing each
   requirement, its source, in-scope or out-of-scope decision, current status, required change, and verification
   evidence. If the intended outcome cannot be established objectively, ask one focused question before editing.
3. **Establish the baseline.** Discover the project's real unit, integration, E2E, lint, type-check, build,
   container, migration, and UI-verification commands. Run the safe, relevant checks before editing. Use gap
   analysis to classify every contract item as `verified`, `partial`, `missing`, `blocked`, or `out of scope`. A
   pre-existing failure is in scope only when it violates the completion contract. Record blockers and do not
   overwrite unrelated work to hide them.
4. **Plan only the remaining gap.** Reuse an existing plan when present; otherwise create the smallest ordered
   remaining-work plan. Prefer `fabrico-engineering-manager` to coordinate substantial work, passing the target,
   completion matrix, relevant paths, constraints, and evidence expected. Its normal phase confirmations are
   replaced by this workflow's autonomy contract. Delegate bounded implementation to the suitable specialist;
   keep dependent or overlapping writes serial and parallelize only disjoint scopes. If delegation is unavailable,
   continue locally when safe without weakening the gates.
5. **Implement and verify incrementally.** Make the minimum changes required by the frozen contract. After each
   bounded task, run its targeted checks and update the completion matrix and any existing plan checklist only
   when evidence supports completion. Do not add speculative features, broad refactors, or unrelated upgrades. If
   new information would materially alter behavior, architecture, data, dependencies, or scope beyond the
   contract, stop for a user decision.
6. **Review and correct.** Request a review in a separate, non-implementing context through `$fabrico-review`
   against the full completion contract, not only the diff. Prefer `fabrico-code-reviewer`; if that custom profile is
   unavailable, use another isolated reviewer that can follow the same review contract. The reviewer returns all
   completion-blocking findings in one pass and does not implement fixes. Delegate fixes to the proper owner,
   rerun affected checks, and review again. Allow at most three full correction and review cycles; if a required
   check or finding still fails, stop as `INCOMPLETE` and report the evidence and attempted fixes. A same-thread
   review is only provisional: record the missing independence and do not report `COMPLETE` unless the user
   explicitly accepts it as an exception.
7. **Prove completion.** Run the complete relevant verification suite once after the last change, including UI
   verification when designs or visual acceptance criteria exist. A project is `COMPLETE` only when every in-scope
   matrix item is verified, every required gate passes, and no unresolved correctness, security, data-safety, or
   acceptance blocker remains. Use `COMPLETE WITH ACCEPTED EXCEPTIONS` only for exceptions the user explicitly
   accepted; otherwise report `BLOCKED` or `INCOMPLETE`.
8. **Report.** Create or update `COMPLETION-SUMMARY.md` with the target and scope sources, final status,
   requirement-to-evidence matrix, changed files, exact checks and results, review cycles, accepted exceptions,
   unresolved blockers, and any user action still required. Return the same essential evidence in chat. Never
   claim completion from code changes, checked boxes, or green tests alone.

## Stop conditions

Stop with a precise blocker and the smallest decision needed when the target or completion contract is ambiguous,
authoritative sources materially conflict, required access or credentials are unavailable, an action crosses the
authority boundary, safe verification cannot be performed, or three correction cycles fail. Do not stop merely
because a named agent is unavailable when the work can be completed safely in the current thread.
