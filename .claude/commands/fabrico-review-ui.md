---
description: "Single-pass web UI verification: compare a running browser implementation against Figma and report differences."
argument-hint: "[Figma URL] [running web app URL]"
---

> **Delegate to the `fabrico-ui-reviewer` subagent.** Launch it with the Task tool (subagent_type: `fabrico-ui-reviewer`), passing the user's request below and any referenced context. Adopt its operating contract; do not do this work in the main thread when the subagent applies.

The request: $ARGUMENTS

Perform a single verification pass comparing the running web implementation against the Figma design. Report all differences found — do not fix code. For native iOS or Android, shared-mobile runtime verification, or a design-free audit, stop as `NOT APPLICABLE` and use `/fabrico-improve-ui` instead.

This command can be used standalone (user invokes directly) or the same verification is performed when the `fabrico-ui-reviewer` subagent is called from `/fabrico-implement`.

## Required Skills

Before starting, load and follow these skills:

- `fabrico-ui-verifying` - verification process, criteria, tolerances, severity definitions, report format

## Workflow

Follow the 5-step verification process defined in the `fabrico-ui-verifying` skill. The skill contains the complete workflow including:

1. Validate inputs (Figma URL + running dev server)
2. Get EXPECTED from Figma via the **figma** MCP server (tools `mcp__figma__*`)
3. Get ACTUAL from implementation via the **playwright** MCP server (tools `mcp__playwright__*`) — structure, actual rendered dimensions, and visual screenshot
4. Compare following the skill's verification categories and tolerances
5. Generate structured report following the skill's report format

The Figma design is the **source of truth** for every comparison. When in doubt, the design wins.

**Enumerate ALL differences in a single pass.** Do not stop at the first critical finding — complete every verification category (Structure, Layout, Dimensions, Visual, Components) and report every difference found. The goal is to give the engineer a complete list so all fixes can be applied at once, minimizing the number of verify-fix iterations.

<!-- FABRICO_COLLECTIONS:command:fabrico-review-ui:v2 -->
