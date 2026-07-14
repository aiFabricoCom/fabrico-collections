---
name: fabrico-create-spec
description: "Turn a short idea into a complete, build-ready `SPEC.md`."
---

> **Invocation portability:** `$fabrico-*` below means the discovered entry workflow. Use the unqualified name for repository or filesystem installs and `$fabrico-collections:fabrico-*` for plugin installs.

## Input

Use the user’s current request as the workflow input. Expected context: `[one-line product idea, e.g. "a management app for an amateur football club"]`.
## Goal

Produce a complete `SPEC.md` from a short idea, so the user can hand it straight to
[`$fabrico-autopilot`](../fabrico-autopilot/SKILL.md) without writing the spec by hand. The spec must follow the structure of
the bundled [`references/SPEC.template.md`](references/SPEC.template.md) and be concrete enough that an autonomous
build rarely has to stop and ask.

## Required skills

- `fabrico-task-extracting` — to turn the idea into well-formed epics and user stories with acceptance criteria.
- `fabrico-task-analysing` — to expand context, spot gaps, and pressure-test scope before writing.

## Workflow

1. **Get the idea.** Read it from `the user’s request`. If empty, ask the user for a one-line product idea (direct user question).

2. **Ask only the high-leverage questions.** ask the user directly to batch 2–4 questions that
   materially shape the spec — typically:
   - target **users/roles**,
   - **MVP scope**: the few must-have features (and anything explicitly out of scope),
   - **platform**: web / iOS / React Native, or "you decide",
   - **integrations** (payments, auth, email, etc.) and **which credentials the user will supply**.
   Keep it to one round. If the user says "just assume" / "one-shot it", skip the questions, choose sensible
   defaults, and record them in the spec's Assumptions/Autonomy section instead.

3. **Draft the full spec.** Read the bundled [`references/SPEC.template.md`](references/SPEC.template.md), then fill
   **every** section:
   product summary · users & roles · scope (in / out) · **features → epics with user stories AND testable
   acceptance criteria** · data-model sketch · tech stack (or "you decide") · integrations + which keys the user
   provides · UI/UX (described behaviorally) · non-functional requirements · deployment (or "defer") · autonomy
   boundaries (what to assume freely vs. ask about).

4. **Decide where the spec is silent.** Make conventional, widely-supported choices, mark genuinely uncertain
   points inline, and never invent scope unrelated to the idea. Keep the spec **platform-agnostic** unless the user
   pinned a platform.

5. **Write the file.** Save to `SPEC.md` (or a path the user names). Then give a 3–5 line summary: the scope you
   chose, the key assumptions, and exactly what the user should tweak or provide (e.g. API keys).

## Output

- `SPEC.md` — complete and ready for `$fabrico-autopilot SPEC.md`.

## Next step / handoff

Tell the user they can now build it autonomously with `$fabrico-autopilot SPEC.md`, or — if this is a rebuild of an
existing app — use `$fabrico-modernize` instead.

## Constraints

- Base every feature and acceptance criterion on the idea and the user's answers; don't pad with unrelated features.
- Acceptance criteria must be concrete and testable (observable behavior, validation rules, permissions).
- For any integration whose keys the user hasn't provided, note it under "what to provide" so the later build can
  stub it rather than stall.

