# Autopilot — complete spec → working software

`$fabrico-autopilot` takes a complete specification and builds the software end to end without stopping at every
normal workflow gate. It is the path for “I will write one good spec and let the system execute it.”

## How to use it

> **Do not want to write the spec by hand?** Invoke `$fabrico-create-spec <your idea>`; see
> [Entry workflow skills](workflow-skills.md). Review the generated `SPEC.md`, then continue with step 2.

1. Copy the template into your project and fill it in:

   ```bash
   cp /path/to/fabrico-collections/SPEC.template.md ./SPEC.md
   ```

2. Keep the project in git and launch Codex with workspace-write permissions:

   ```bash
   codex --sandbox workspace-write --ask-for-approval on-request
   ```

3. Type this in the Codex composer:

   ```text
   $fabrico-autopilot SPEC.md
   ```

The workflow runs **backlog → architecture and scaffold → plan review → implementation with tests → quality gates
→ commit per story → code review → `BUILD-SUMMARY.md`**.

## The autonomy contract

Autopilot replaces routine per-step confirmations with these rules:

- **No pausing between ordinary phases.** It continues from backlog through review.
- **Decide when the spec is silent.** It chooses conventional defaults and records each material decision in
  `ASSUMPTIONS.md`.
- **Stop for true blockers:** missing credentials; irreversible, paid, destructive, deployment, or outbound
  actions; contradictory requirements; or a step that still fails after the documented retry limit.
- **Prefer free, local, and mocked defaults.** It does not incur cost or touch production without authority.
- **Keep quality gates enabled.** Autonomy removes routine confirmations, not tests, lint, build, or review.

Anything it cannot finish is recorded in `BUILD-SUMMARY.md` under “Needs your input”; it is not dropped silently.

Codex also supports `--dangerously-bypass-approvals-and-sandbox` for externally hardened automation environments.
Do not use it on an ordinary workstation: it removes approval prompts and sandbox protections. See
[Getting started](getting-started.md#launch-codex-with-appropriate-permissions).

## What makes autopilot succeed

Autonomy quality is bounded by spec quality. `SPEC.template.md` covers:

1. Product summary
2. Users and roles
3. MVP scope and explicit exclusions
4. **Features with observable acceptance criteria**
5. Data model
6. Technology constraints or permission to choose
7. Integrations and credential availability
8. UI and UX requirements
9. Non-functional requirements
10. Deployment target
11. Autonomy boundaries

The more concrete the requirements and acceptance criteria, the fewer assumptions the workflow must make.

## Outputs

- working, committed code with tests
- `ASSUMPTIONS.md` — decisions made where the spec was silent
- `BUILD-SUMMARY.md` — per-story status, verification evidence, remaining inputs, and run instructions

## Related

- A worked example spec ships as [`SPEC.md`](../SPEC.md).
- To build from an authorized running app, see [Legacy modernization](legacy-modernization.md).
