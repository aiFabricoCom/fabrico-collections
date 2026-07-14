---
name: fabrico-reverse-spec
description: "Reverse-engineer a platform-agnostic `SPEC.md` from an authorized running web app."
---

> **Invocation portability:** `$fabrico-*` below means the discovered entry workflow. Use the unqualified name for repository or filesystem installs and `$fabrico-collections:fabrico-*` for plugin installs.

## Input

Use the user’s current request as the workflow input. Expected context: `<url of the running app> [login/scope notes]`.
## Goal

Produce a faithful, behavioral `SPEC.md` for an existing web application by observing it in a real browser — so it
can be rebuilt on a modern stack or ported to mobile. You describe **what the app does** (screens, data, roles,
flows, integrations), not how its legacy code is written.

## Required skills

Load and follow these before starting:
- `fabrico-reverse-engineering-spec` — the end-to-end capture → spec procedure (and its `references/playwright-capture.md`).
- `fabrico-task-extracting` — for turning observed behavior into well-formed epics and user stories.

## Workflow

1. **Confirm inputs.** Read the URL from `the user’s request`. If no URL is given, or a required area is behind a login you
   can't pass, ask the user directly to get the URL / credentials / scope. This is the one true blocker —
   don't guess behind auth.
2. **Verify access.** Open the app with the **playwright** MCP server. If the playwright server is
   not connected, tell the user to enable it (it's defined in `.mcp.json`) and stop.
3. **Run the reverse-engineering process** from the `fabrico-reverse-engineering-spec` skill: route inventory →
   per-screen capture → infer data model, roles, flows, integrations → synthesize features into user stories with
   acceptance criteria. For a large app, you may delegate non-overlapping section crawls in batches of at most five
   concurrent workers from a user-facing thread, or four when this caller itself has a parent. Every worker returns
   evidence to this calling thread and must not spawn another worker.
4. **Write the artifacts:** `SPEC.md` (platform-agnostic, with a **Target (fill at build time)** section and a
   **Source mapping** appendix), plus `legacy-inventory.md`, `legacy-capture/` (screenshots), and
   `reverse-spec-notes.md` (open questions/assumptions).
5. **Coverage gate.** Confirm every inventoried screen maps to a story or is explicitly out-of-scope. Then present a
   short summary and the list of open questions for the user to confirm.

## Output

- `SPEC.md` — compatible with `$fabrico-autopilot SPEC.md` and `$fabrico-modernize SPEC.md`.
- `legacy-inventory.md`, `legacy-capture/`, `reverse-spec-notes.md` — evidence and open questions.

## Constraints

- Read-only inspection: never submit destructive actions (deletes, payments, real emails) against the live app;
  prefer staging/localhost. Only inspect apps the user owns or is authorized to analyze.
- Base every acceptance criterion on observed behavior. Flag uncertainties in `reverse-spec-notes.md` — do not
  invent features, and do not silently drop ones you saw.
