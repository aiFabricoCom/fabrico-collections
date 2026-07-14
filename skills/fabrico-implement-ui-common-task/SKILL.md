---
name: fabrico-implement-ui-common-task
description: "Implement UI using Figma as the visual source of truth."
---

> **Invocation portability:** `$fabrico-*` below means the discovered entry workflow. Use the unqualified name for repository or filesystem installs and `$fabrico-collections:fabrico-*` for plugin installs.

## Input

Use the user’s current request as the workflow input. Expected context: `[task or component to implement]`.
> **PREREQUISITE**: This workflow extends [$fabrico-implement-common-task](../fabrico-implement-common-task/SKILL.md). You MUST read and follow **all steps** from that base workflow first. This workflow adds UI-specific behaviors on top — it does not remove or replace any base workflow steps.

Implement the UI feature according to the **research context** and **implementation plan**, using Figma designs as the source of truth for visual implementation.

## Required Skills

In addition to the skills required by the base workflow, load and follow these skills before starting:

- `fabrico-implementing-frontend` — for component patterns, design system usage, composition, and performance guidelines
- `fabrico-ensuring-accessibility` — for WCAG 2.1 AA compliance, semantic HTML, ARIA, and automated axe-core verification

---

## Design References from Research & Plan

Always treat the **research** and **plan** files as the single source of truth for design links:

- Before starting implementation (during step 1–2 of the base workflow):
  - Open the **research file** (`*.research.md`) and look for:
    - Figma URLs in the `Relevant Links` section.
    - Any specific component/node links mentioned in `Gathered Information`.
  - Open the **plan file** (`*.plan.md`) and look for:
    - Figma URLs and design references in `Task details`.
    - If present, a structured "Design References" subsection mapping views/components to Figma URLs or node IDs.
- Use these Figma URLs as the **default source** for all calls to the **figma** MCP server during implementation.

### When Figma link is missing

If you cannot find a Figma URL for the component/section you are about to implement:

1. **Stop** — do not proceed with that component
2. **Ask the user** to provide the Figma link for the specific section
3. **Wait for the link** before proceeding with implementation
4. **Add the link** to the plan file once provided (in `Task details` or `Design References`)

Do NOT:

- Skip implementation because the link is missing
- Guess what the design should look like
- Proceed with implementation without a Figma reference

When you discover missing or updated design links during implementation, add them to the appropriate sections in the **plan** under `Task details` (and, if needed, note them in the Changelog).

---

## Additional Setup (before starting implementation)

Before step 6 of the base workflow (starting implementation), ensure:

- The local development server is running.
- You can access the page you're implementing (authenticated if needed).
- You have identified all relevant Figma URLs from the research/plan files.
- You understand the design system tokens and components available in the project.

---

## UI Verification Note

When this workflow runs inside the managed implementation flow, UI verification against Figma belongs to the
`fabrico-engineering-manager`, which delegates the verify-fix loop to `fabrico-ui-reviewer`; the implementing child
must return its evidence and must not spawn a sibling. When the workflow is invoked directly or custom agents are
unavailable, the calling thread owns that same verification gate and performs it locally with `fabrico-ui-verifying`
plus the available Figma/browser capabilities. If verification cannot run, report the limitation explicitly rather
than claiming a verified match. Apply any resulting fixes and repeat the gate as required by the plan.

