---
name: fabrico-implement
description: "Implement a feature according to the plan, orchestrated end to end."
---

> **Invocation portability:** `$fabrico-*` below means the discovered entry workflow. Use the unqualified name for repository or filesystem installs and `$fabrico-collections:fabrico-*` for plugin installs.

## Input

Use the user’s current request as the workflow input. Expected context: `[task description or implementation plan]`.

> **Prefer the `fabrico-engineering-manager` subagent.** When that custom agent is available, spawn it with the user's request and referenced context and adopt its operating contract. If this workflow is already running inside `fabrico-engineering-manager`, execute its orchestration steps locally and never spawn another manager. If the profile is unavailable, as in a skills-only plugin installation, orchestrate the complete workflow in the current thread. In that local mode, every later instruction to delegate means: use the named agent when available; otherwise perform that step locally with the referenced skills and preserve every gate.
Your goal is to implement the feature according to the provided task description or implementation plan.

No matter what you always follow the implementation workflow defined in this workflow, including all steps and quality gates. You do not skip any steps or gates, and you do not proceed to the next step until the current one is fully completed and verified.

This workflow is orchestration-only when used with the `fabrico-engineering-manager` subagent. The engineering manager must not implement product code directly when a suitable specialized agent exists.

When a suitable specialized agent is available, delegate implementation before modifying source code, review its result, and continue with orchestration-scoped follow-up work. When custom-agent profiles are unavailable, perform the implementation locally with the same specialist skills, review steps, and quality gates; do not stop solely because delegation is unavailable.

## Workflow

### Step 0: Assess Complexity & Select Flow

Before starting any work, perform a quick assessment of the task:

1. **Scan the task** — Read the task description, any linked issues, or user instructions. Consider:
   - How many files are likely affected?
   - Is it a well-understood change (bug fix, small feature, config change) or something ambiguous/cross-cutting?
   - Are there unknowns that require research or architectural decisions?
   - Does it involve UI changes requiring Figma verification?

2. **Recommend a flow** — Based on your assessment, ask the user directly to present your recommendation:
   - **Full Implementation Flow** (recommended for: multi-component features, unclear requirements, architectural changes, UI work with Figma designs, tasks touching >3 files across different domains)
   - **Quick Implementation Flow** (recommended for: bug fixes, small self-contained features, config changes, adding tests, straightforward CRUD, tasks where the solution is obvious)

   Present your reasoning briefly (1-2 sentences) and let the user confirm or override your recommendation.

---

### Quick Implementation Flow

If the Quick flow is selected, follow these streamlined steps:

1. **Delegate implementation** — Delegate directly to the `fabrico-software-engineer` subagent with the task description and any available context. The software engineer implements the solution following project conventions. The engineering manager must not write product code directly in the Quick flow.

2. **Run quality checks** — After implementation, run static code analysis, build the project, and run tests to verify correctness.

3. **Delegate code review** — Delegate to the `fabrico-code-reviewer` subagent via `$fabrico-review` (`.agents/skills/fabrico-review/SKILL.md`). The code reviewer runs all quality gates (unit, integration, E2E tests, linting, build).

4. **Before making any changes** to the original solution during review fixes, ask for confirmation.

---

### Full Implementation Flow

If the Full flow is selected, follow the complete workflow below:

1. **Review the current state of the task** - Check what's already done and decide whether you have enough context and information to start the implementation or if you need to delegate to the `fabrico-context-engineer` subagent to gather more context and requirements before starting the implementation. If the plan is missing, delegate to the `fabrico-architect` subagent to create a detailed implementation plan based on the feature context and requirements.

2. **Validate the plan** — After the architect produces or updates the `.plan.md`, delegate to the `fabrico-plan-reviewer` subagent via `$fabrico-review-plan` (`.agents/skills/fabrico-review-plan/SKILL.md`) to validate the plan's correctness, feasibility, and simplicity. If the reviewer returns REVISIONS NEEDED with BLOCKER findings, send the review report back to the architect for corrections and re-validate (max 3 iterations — then escalate to user). If the plan is already approved and unchanged since the last review, skip re-validation. Once approved, present the plan and review summary to the user for implementation confirmation. Only proceed once the plan is APPROVED and the user confirms.

3. **Review the plan** — Read the implementation plan and feature context thoroughly. Identify every task, its type (`[CREATE]`, `[MODIFY]`, `[REUSE]`), and which agent should handle it. Create a **todo for every task** in the plan — not one per phase. Each task gets its own todo.

   **Inventory UI verification tasks** — Scan the entire plan for `[REUSE]` tasks that involve the `fabrico-ui-reviewer` subagent or Figma verification. Also scan the plan — and the research file (`*.research.md`) if one exists — for all Figma URLs. Build an explicit list of UI components that require verification. You will use this inventory as a checklist — every item must be verified before code review.

4. **Confirm dev server URL** — If your UI verification inventory from step 3 contains ANY tasks, Ask the user directly **now** to ask the user for the dev server URL (e.g., "What URL is the frontend app running at?"). Do not defer this — you need the confirmed URL before any UI verification can start. Do not guess from running processes or port scans. Store the confirmed URL for all subsequent verifications.

5. **Delegate codebase analysis (if needed)** — Check if the plan file (`*.plan.md`) contains a populated **"Technical Context"** section. If it does, skip this step — the context was already captured during planning. If the section is missing or empty, use the `fabrico-architect` subagent to perform codebase analysis and technical context discovery to establish project conventions, coding standards, architecture patterns, and existing codebase patterns before implementing any feature. This will help you identify which agents to delegate specific tasks to during implementation.

6. **Confirm with user before implementation** — Confirm with the user before proceeding to the implementation phase after research and planning phases using the direct user question.

7. **Process each task in plan order.** For each task, based on its type:
   - **`[CREATE]` or `[MODIFY]`** → delegate to the appropriate agent (the `fabrico-software-engineer` subagent for application code, the `fabrico-devops-engineer` subagent for infrastructure, the `fabrico-prompt-engineer` subagent for LLM prompts). After the agent completes, run quality checks (tsc, lint, build).

   - **`[REUSE]` — UI verification tasks** → These tasks MUST be processed — do NOT skip them. Delegate each one to the `fabrico-ui-reviewer` subagent by spawning the `fabrico-ui-reviewer` custom agent with `$fabrico-review-ui` (`.agents/skills/fabrico-review-ui/SKILL.md`), passing: the Figma URL (for the **figma** MCP server to extract design specs), the confirmed dev server URL from step 4 (for the **playwright** MCP server to capture the actual implementation), and the component/section name. For the complete verification workflow (fix→verify iteration loop, confidence handling, escalation rules, verification gate), follow `$fabrico-implement-ui` (`.agents/skills/fabrico-implement-ui/SKILL.md`).

   - **`[REUSE]` — other tasks** → execute as described in the task definition — the task specifies which agent to delegate to and what context to pass.

   The engineering manager must not be the first writer of product code for any `[CREATE]` or `[MODIFY]` task when one of the specialized implementation agents above is applicable.

8. **After each task**, update the relevant plan to reflect progress by checking the box for the completed task step and:
   - Review the implementation against the plan and feature context to ensure all requirements are met.
   - Run static code analysis, build the project, and run unit and integration tests to verify that the implementation works as expected and does not introduce new issues.

9. **UI Verification Gate — MANDATORY before code review** — Before delegating code review, verify that **every** `[REUSE]` UI verification task from your step 3 inventory has been processed. Check each item:
   - Was it delegated to the `fabrico-ui-reviewer` subagent?
   - Did it receive a PASS, or was it escalated to the user with explicit approval to skip?

   If ANY UI verification task was not processed, go back and process it now. Do NOT proceed to code review with unverified UI components. If verification cannot be completed (tool errors, missing Figma links), document it in the plan's Changelog and get explicit user approval before continuing.

10. **Delegate code review** — Delegate to the `fabrico-code-reviewer` subagent via `$fabrico-review` (`.agents/skills/fabrico-review/SKILL.md`). Include E2E test execution as part of the review. The code reviewer runs all quality gates (unit, integration, E2E tests, linting, build).

11. **Before making any changes** to the original solution during implementation, ask for confirmation. Document changes in the plan file's Changelog section with timestamps.

If the engineering manager starts implementing product code directly instead of delegating, treat that as a workflow violation. Stop further direct implementation, delegate the remaining work to the correct agent, and record the deviation in the chat summary.

Ensure to write clean, efficient, and maintainable code following best practices and coding standards for the project.

