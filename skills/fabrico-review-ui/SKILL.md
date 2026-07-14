---
name: fabrico-review-ui
description: "Compare the implementation with its Figma design."
---

> **Invocation portability:** `$fabrico-*` below means the discovered entry workflow. Use the unqualified name for repository or filesystem installs and `$fabrico-collections:fabrico-*` for plugin installs.

## Input

Use the user’s current request as the workflow input. Expected context: `[Figma URL] (with a running dev server)`.

> **Prefer the `fabrico-ui-reviewer` subagent.** When that custom agent is available, spawn it with the user's request and referenced context and adopt its operating contract. If this workflow is already running inside `fabrico-ui-reviewer`, perform the verification locally and never spawn another UI reviewer. If the profile is unavailable, as in a skills-only plugin installation, perform the complete workflow in the current thread with the required skills and the same verification contract.
Perform a single verification pass comparing the current implementation against the Figma design. Report all differences found — do not fix code.

This workflow can be used standalone (user invokes directly) or the same verification is performed when the `fabrico-ui-reviewer` subagent is called from `$fabrico-implement`.

## Required Skills

Before starting, load and follow these skills:

- `fabrico-ui-verifying` - verification process, criteria, tolerances, severity definitions, report format

## Workflow

Follow the 5-step verification process defined in the `fabrico-ui-verifying` skill. The skill contains the complete workflow including:

1. Validate inputs (Figma URL + running dev server)
2. Get EXPECTED from Figma via the **figma** MCP server
3. Get ACTUAL from implementation via the **playwright** MCP server — structure, actual rendered dimensions, and visual screenshot
4. Compare following the skill's verification categories and tolerances
5. Generate structured report following the skill's report format

The Figma design is the **source of truth** for every comparison. When in doubt, the design wins.

**Enumerate ALL differences in a single pass.** Do not stop at the first critical finding — complete every verification category (Structure, Layout, Dimensions, Visual, Components) and report every difference found. The goal is to give the engineer a complete list so all fixes can be applied at once, minimizing the number of verify-fix iterations.

