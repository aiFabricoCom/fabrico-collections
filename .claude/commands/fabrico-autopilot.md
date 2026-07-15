---
description: "Autonomously build working software from a complete spec file: backlog → architecture → plan → implement every story → test → review, end to end with minimal interruptions."
argument-hint: "[path to spec file, e.g. SPEC.md]"
---

> **Delegate to the `fabrico-engineering-manager` subagent.** Launch it with the Task tool (subagent_type: `fabrico-engineering-manager`), passing this entire command plus the spec. Adopt its operating contract, but REPLACE its interactive per-step confirmation gates with the Autonomy Contract below.

The spec: $ARGUMENTS

If `$ARGUMENTS` is empty, default to reading `./SPEC.md`.

## Goal

Take a complete product specification and build the software end to end — autonomously. You drive discovery,
architecture, planning, implementation, testing, and review yourself, delegating to the specialized `fabrico-*`
subagents, and you keep going without asking the user to confirm each step. The user provided a spec precisely so
they would NOT have to babysit the build.

## Autonomy Contract (this overrides the default "ask at every gate" behavior)

- **Do not pause for confirmation between phases.** Flow straight through: backlog → context/stack → plan →
  implementation (all stories) → review → summary.
- **When the spec is silent, decide.** Pick conventional, widely-supported defaults, record EVERY such decision in
  `ASSUMPTIONS.md` (append, with a one-line rationale), and continue. Do not stall on choices you can make reasonably.
- **HALT and ask the user ONLY for genuine blockers:**
  - a credential / secret / API key required to proceed (DB URL, Stripe key, OAuth client, etc.)
  - an irreversible or paid/outbound action (deploying, charging a card, deleting data, sending real email/SMS)
  - a contradiction in the spec that would materially change the product
  - the same step failing 3 times in a way you cannot resolve
- **Prefer free / local / mocked defaults.** Never incur cost or touch production without explicit approval.
  For external services you can't reach, stub them behind an interface and log it.
- Run the **Full Implementation Flow** autonomously (no per-gate pauses). Keep all quality gates (tests, lint,
  build, code review) — autonomy removes *confirmation prompts*, not *quality checks*.

## Workflow

1. **Read the spec.** If the file is missing or essentially empty → STOP and ask the user to provide one (point
   them at `SPEC.template.md`). Otherwise, summarize your understanding in 3–5 bullets and proceed (no confirmation).
2. **Derive the backlog.** If the spec lists concrete user stories with acceptance criteria, use them. If it is
   feature-level, delegate to `fabrico-business-analyst` to produce epics + user stories. Save as `backlog.md`.
3. **Technical context & stack.** Delegate to `fabrico-architect` (use the `fabrico-technical-context-discovering`
   skill). If greenfield and the spec doesn't fix a stack, choose a sensible default, log it to `ASSUMPTIONS.md`,
   and scaffold the base project (structure, lint, test runner, a hello-world that builds).
4. **Plan.** The architect produces a `*.plan.md` per epic/feature; `fabrico-plan-reviewer` validates it.
   Auto-apply BLOCKER fixes (max 3 iterations), then proceed — do not wait for user approval of the plan.
5. **Implement every story in plan order.** Delegate `[CREATE]`/`[MODIFY]` tasks to the right agent
   (`fabrico-software-engineer` for app code, `fabrico-devops-engineer` for infra, `fabrico-prompt-engineer` for
   LLM prompts). After each story: run tests + lint + build; fix failures; then `git commit` with a clear message
   referencing the story. For web UI stories, verify the running browser app with `playwright` and use
   `fabrico-ui-reviewer` when Figma is provided. For iOS, Android, or shared-mobile UI, follow
   `fabrico-improving-ui` and verify with the project's build, simulator/emulator or device, accessibility, UI,
   screenshot, lint, and test paths. Never use the web-only reviewer as native evidence. If the required runtime is
   unavailable, record the limitation rather than claiming visual verification.
6. **Review.** Delegate to `fabrico-code-reviewer`; auto-fix findings; re-run all gates until green.
7. **Output `BUILD-SUMMARY.md`.** Include: what was built (per-story status table), the full list of assumptions,
   exactly what the user must still provide (API keys, accounts, env vars), and step-by-step instructions to run
   the app locally.

## Constraints

- **Never commit secrets.** Use `.env.example` with placeholders; list required env vars in the summary.
- **Never deploy, charge, send real messages, or modify production** without explicit user approval.
- Keep changes minimal and tested. No speculative features beyond the spec.
- When you must assume: **assume → log → continue.** Do not stall, and do not silently drop scope — anything you
  cannot complete goes into `BUILD-SUMMARY.md` under "Needs your input".

## What makes autopilot succeed: a complete spec

Autonomy quality is bounded by spec quality. A good spec (see `SPEC.template.md`) covers: product summary; users &
roles; in-scope vs out-of-scope (MVP); concrete features/user stories **with acceptance criteria**; key data
entities; preferred tech stack (or "you decide"); external integrations and which keys the user will supply; UI
notes or Figma links; non-functional needs (auth, roles, languages, devices); and what the system may assume
freely vs. must ask about. The more of this you provide, the more of the build runs without stopping.

<!-- FABRICO_COLLECTIONS:command:fabrico-autopilot:v2 -->
