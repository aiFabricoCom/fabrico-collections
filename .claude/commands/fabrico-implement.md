---
description: "Implement feature according to the plan."
argument-hint: "[task description or implementation plan]"
---

> **Delegate to the `fabrico-engineering-manager` subagent.** Launch it with the Task tool (subagent_type: `fabrico-engineering-manager`), passing the user's request below and any referenced context. Adopt its operating contract; do not do this work in the main thread when the subagent applies.

The request: $ARGUMENTS

Your goal is to implement the feature according to the provided task description or implementation plan.

No matter what you always follow the implementation workflow defined in this command, including all steps and quality gates. You do not skip any steps or gates, and you do not proceed to the next step until the current one is fully completed and verified.

This command is orchestration-only when used with the `fabrico-engineering-manager` subagent. The engineering manager must not implement product code directly when a suitable specialized agent exists.

Before any source-code modification is performed by the current agent, the current agent must first delegate implementation to the appropriate specialized agent, review the result, and continue only with orchestration-scoped follow-up work. If delegation does not happen, stop and explain why before proceeding.

If the caller supplies an explicit autonomy contract from `/fabrico-autopilot`, `/fabrico-finish-project`, or `/fabrico-improve-ui`, treat this command's routine flow-selection, plan, implementation, and in-scope correction confirmations as satisfied only for work already covered by that contract's frozen scope and authority boundary. Keep every quality gate. Ask before any change or action outside that boundary.

## Workflow

### Step 0: Assess Complexity & Select Flow

Before starting any work, perform a quick assessment of the task. If an explicit calling autonomy contract already defines the flow, do not ask the user to select it again.

1. **Scan the task** — Read the task description, any linked issues, or user instructions. Consider:
   - How many files are likely affected?
   - Is it a well-understood change (bug fix, small feature, config change) or something ambiguous/cross-cutting?
   - Are there unknowns that require research or architectural decisions?
   - Does it involve web UI changes requiring Figma verification, or native/design-free UI requiring platform verification?

2. **Recommend a flow** — Based on your assessment, use the **AskUserQuestion** tool to present your recommendation:
   - **Full Implementation Flow** (recommended for: multi-component features, unclear requirements, architectural changes, UI work with Figma designs, tasks touching >3 files across different domains)
   - **Quick Implementation Flow** (recommended for: bug fixes, small self-contained features, config changes, adding tests, straightforward CRUD, tasks where the solution is obvious)

   Present your reasoning briefly (1-2 sentences) and let the user confirm or override your recommendation.

---

### Quick Implementation Flow

If the Quick flow is selected, follow these streamlined steps:

1. **Delegate implementation** — Delegate directly to the `fabrico-software-engineer` subagent with the task description and any available context. The software engineer implements the solution following project conventions. The engineering manager must not write product code directly in the Quick flow.

2. **Run quality checks** — After implementation, run static code analysis, build the project, and run tests to verify correctness.

3. **Delegate code review** — Delegate to the `fabrico-code-reviewer` subagent via `/fabrico-review` (`.claude/commands/fabrico-review.md`). The code reviewer runs all quality gates (unit, integration, E2E tests, linting, build).

4. **Before making any changes** to the original solution during review fixes, ask for confirmation unless the fix is already covered by an explicit calling autonomy contract and its frozen scope.

---

### Full Implementation Flow

If the Full flow is selected, follow the complete workflow below:

1. **Review the current state of the task** - Check what's already done and decide whether you have enough context and information to start the implementation or if you need to delegate to the `fabrico-context-engineer` subagent to gather more context and requirements before starting the implementation. If the plan is missing, delegate to the `fabrico-architect` subagent to create a detailed implementation plan based on the feature context and requirements.

2. **Validate the plan** — After the architect produces or updates the `.plan.md`, delegate to the `fabrico-plan-reviewer` subagent via `/fabrico-review-plan` (`.claude/commands/fabrico-review-plan.md`) to validate the plan's correctness, feasibility, and simplicity. If the reviewer returns REVISIONS NEEDED with BLOCKER findings, send the review report back to the architect for corrections and re-validate (max 3 iterations — then escalate to user). If the plan is already approved and unchanged since the last review, skip re-validation. Once approved, present the plan and review summary to the user for implementation confirmation unless an explicit calling autonomy contract already covers the frozen scope. Never proceed with an unapproved plan.

3. **Review the plan** — Read the implementation plan and feature context thoroughly. Identify every task, its type (`[CREATE]`, `[MODIFY]`, `[REUSE]`), and which agent should handle it. Create a **todo for every task** in the plan — not one per phase. Each task gets its own todo.

   **Inventory UI verification tasks** — Build two explicit lists. The first contains `[REUSE]` **web Figma** tasks assigned to `fabrico-ui-reviewer`, with their Figma URLs and running pages. The second contains `[REUSE]` **native or design-free** platform-verification tasks that follow `fabrico-improving-ui`, with their target runtimes and required evidence. Every item in both lists must be processed before code review.

4. **Confirm web dev server URL** — If the **web Figma** inventory from step 3 contains any tasks, use the **AskUserQuestion** tool now to ask for the dev server URL. Do not guess from processes or port scans. Do not ask for a web URL for native-only or design-free tasks; resolve their simulator, emulator, device, build, or other runtime through the platform-verification scope.

5. **Delegate codebase analysis (if needed)** — Check if the plan file (`*.plan.md`) contains a populated **"Technical Context"** section. If it does, skip this step — the context was already captured during planning. If the section is missing or empty, use the `fabrico-architect` subagent to perform codebase analysis and technical context discovery to establish project conventions, coding standards, architecture patterns, and existing codebase patterns before implementing any feature. This will help you identify which agents to delegate specific tasks to during implementation.

6. **Confirm with user before implementation** — Confirm before implementation after research and planning unless an explicit calling autonomy contract already authorizes the frozen scope.

7. **Process each task in plan order.** For each task, based on its type:
   - **`[CREATE]` or `[MODIFY]`** → delegate to the appropriate agent (the `fabrico-software-engineer` subagent for application code, the `fabrico-devops-engineer` subagent for infrastructure, the `fabrico-prompt-engineer` subagent for LLM prompts). After the agent completes, run quality checks (tsc, lint, build).

   - **`[REUSE]` — web Figma verification tasks** → These tasks MUST be processed. Delegate each one to `fabrico-ui-reviewer` via the **Task** tool (subagent_type: `fabrico-ui-reviewer`) with `/fabrico-review-ui`, passing the Figma URL, confirmed web dev-server URL, and component or section. Follow `/fabrico-implement-ui` for the verify-fix loop.

   - **`[REUSE]` — native or design-free UI verification tasks** → Process each task with `fabrico-improving-ui`. Do not delegate it to `fabrico-ui-reviewer`. Use the target project's existing build, simulator/emulator or device, accessibility, UI, screenshot, lint, and test paths; record evidence and limitations for every requested platform.

   - **`[REUSE]` — other tasks** → execute as described in the task definition — the task specifies which agent to delegate to and what context to pass.

   The engineering manager must not be the first writer of product code for any `[CREATE]` or `[MODIFY]` task when one of the specialized implementation agents above is applicable.

8. **After each task**, update the relevant plan to reflect progress by checking the box for the completed task step and:
   - Review the implementation against the plan and feature context to ensure all requirements are met.
   - Run static code analysis, build the project, and run unit and integration tests to verify that the implementation works as expected and does not introduce new issues.

9. **UI Verification Gate — MANDATORY before code review** — Verify that every item in both step 3 inventories was processed. Every web Figma task must have a reviewer result or explicit accepted exception. Every native or design-free task must have the platform evidence and completion state required by `fabrico-improving-ui`, or an explicit accepted exception. Do not proceed to code review with silently unverified UI; record blockers and limitations in the plan's Changelog.

10. **Delegate code review** — Delegate to the `fabrico-code-reviewer` subagent via `/fabrico-review` (`.claude/commands/fabrico-review.md`). Include E2E test execution as part of the review. The code reviewer runs all quality gates (unit, integration, E2E tests, linting, build).

11. **Before making any changes** to the original solution during implementation, ask for confirmation unless the change is already covered by an explicit calling autonomy contract and its frozen scope. Document changes in the plan file's Changelog section with timestamps.

If the engineering manager starts implementing product code directly instead of delegating, treat that as a workflow violation. Stop further direct implementation, delegate the remaining work to the correct agent, and record the deviation in the chat summary.

Ensure to write clean, efficient, and maintainable code following best practices and coding standards for the project.

<!-- FABRICO_COLLECTIONS:command:fabrico-implement:v2 -->
