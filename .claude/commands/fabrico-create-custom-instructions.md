---
description: "Create Claude Code memory (CLAUDE.md) for a project. Analyzes existing project conventions, determines the appropriate memory scope and placement, creates the CLAUDE.md file(s), and validates against best practices."
argument-hint: "[conventions or standards to encode]"
---

> **Delegate to the `fabrico-customization-orchestrator` subagent.** Launch it with the Task tool (subagent_type: `fabrico-customization-orchestrator`), passing the user's request below and any referenced context. Adopt its operating contract; do not do this work in the main thread when the subagent applies.

The request: $ARGUMENTS

Create Claude Code memory (`CLAUDE.md`) for this project. Claude Code memory is scoped by file location rather than by glob patterns: a root `CLAUDE.md` applies to the whole project, and a nested `CLAUDE.md` placed in a subdirectory applies only to that subtree. You can also pull in shared content with `@import` references. The user's message following this command may contain specific requirements or conventions to encode.

## Required Skills

Before starting, load and follow these skills:
- `fabrico-creating-instructions` - for the memory file creation workflow, scope decisions, placement, and validation checklist
- `fabrico-technical-context-discovering` - for discovering project conventions and workspace patterns before creating
- `fabrico-codebase-analysing` - for analyzing the project for existing coding conventions and patterns

## Workflow

1. **Research project conventions**: Analyze the project for existing coding standards and conventions:
   - Project structure and technology stack
   - Existing coding patterns and standards
   - Any existing memory files (a root `CLAUDE.md` or nested `CLAUDE.md` files in subdirectories)
   - Note: this repository currently has NO memory files
2. **Determine memory scope**: Help the user choose the appropriate memory placement:
   - **Project-root** (`CLAUDE.md` at the repository root): applies to all Claude Code interactions in the project
   - **Scoped** (a nested `CLAUDE.md` in a subdirectory): applies only to interactions involving files within that subtree
   - There is no `applyTo` glob — scope is determined entirely by where the `CLAUDE.md` file lives. Use nested files (or `@import` references for shared content) to target specific areas of the codebase.
   - Guide the decision based on the user's needs and scope
3. **Clarify requirements**: Determine what conventions, standards, or behaviors to encode:
   - Coding standards and style preferences
   - Framework-specific patterns and conventions
   - Behavioral guidelines for Claude Code in this project
   - If the user's message already contains requirements, confirm understanding before proceeding
4. **Create the memory file**: Create the `CLAUDE.md` file(s) with appropriate placement, scope, and content. Apply the `fabrico-creating-instructions` skill workflow for structure and validation.
5. **Review and validate**: Review the created memory against best practices:
   - Verify the placement (root vs. nested) is appropriate for the intended scope
   - Confirm guidelines are clear and actionable for Claude Code
   - Check that any nested `CLAUDE.md` files live in the directories whose subtree they are meant to govern, and that any `@import` references resolve

## Guidelines

- **Project-root memory** (`CLAUDE.md` at the repository root): Applies to all Claude Code interactions in the project — use for project-wide coding standards, naming conventions, architecture decisions.
- **Scoped memory** (a nested `CLAUDE.md`): Place it in the directory whose subtree it should govern. Because scope follows file location, putting a `CLAUDE.md` in `frontend/` makes it apply to everything under `frontend/`. Use `@import` references to share common content across multiple memory files instead of duplicating it.
- This repository currently has NO memory files — the user is starting from scratch. Communicate this context during the research step.

If the user attaches files or provides a description, use them as input for memory design.

When in doubt about the placement or scope, ask the user for clarification rather than guessing.

<!-- FABRICO_COLLECTIONS:command:fabrico-create-custom-instructions:v1 -->
