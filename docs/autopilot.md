# Autopilot — complete spec → working software

`/fabrico-autopilot` takes a complete specification and builds the software end to end, **autonomously** — without
pausing at every gate. It's the path for "I'll write one good spec and let it run."

## How to use it

1. Copy the template into your project and fill it in:
   ```bash
   cp /path/to/fabrico-collections/SPEC.template.md ./SPEC.md
   ```
2. Start Claude Code in **auto-accept-edits** mode (Shift+Tab), keep the project in git, then run:
   ```text
   /fabrico-autopilot SPEC.md
   ```

It runs: **backlog → architecture (+ scaffold if greenfield) → plan (with plan review) → implement every story
with tests → quality gates → `git commit` per story → code review → `BUILD-SUMMARY.md`.**

## The autonomy contract

Autopilot replaces the usual per-step confirmation prompts with these rules:

- **No pausing between phases.** It flows straight through.
- **Decide when the spec is silent.** It picks conventional defaults, logs every decision to `ASSUMPTIONS.md`, and
  continues.
- **Halt only for true blockers:** a missing credential/secret (DB URL, Stripe key, …); an irreversible or
  paid/outbound action (deploy, charge a card, send real email); a contradiction in the spec; or the same step
  failing three times.
- **Prefer free/local/mocked defaults.** It never incurs cost or touches production without approval; unreachable
  external services are stubbed behind an interface and logged.
- **Quality gates stay on.** Autonomy removes *confirmation prompts*, not tests, lint, build, or code review.

Anything it can't finish (e.g. real payments without keys) is recorded in `BUILD-SUMMARY.md` under "Needs your
input" — nothing is dropped silently.

## What makes autopilot succeed: a complete spec

Autonomy quality is bounded by spec quality. `SPEC.template.md` covers:

1. Product summary
2. Users & roles
3. Scope (in / out for MVP)
4. **Features / user stories with acceptance criteria** — the most important section
5. Data model (entity sketch)
6. Tech stack & constraints (or "you decide")
7. Integrations & which credentials you'll supply
8. UI / UX (Figma links or written description)
9. Non-functional requirements
10. Deployment target (or "defer")
11. Autonomy boundaries — what it may assume freely vs. must ask about

The more you fill in — especially concrete acceptance criteria — the less it stops and the closer the result
matches your intent.

## Outputs

- working, committed code with tests
- `ASSUMPTIONS.md` — every decision made on your behalf
- `BUILD-SUMMARY.md` — per-story status, assumptions, what you must still provide (keys/accounts), and how to run
  the app

## Related

- A worked example spec ships as [`SPEC.md`](../SPEC.md) (a sports-club app).
- To build from an existing app instead of a written spec, see [Legacy modernization](legacy-modernization.md).
