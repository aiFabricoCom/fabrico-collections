---
description: "Analyze the feature context file for the provided task or Jira ID and prepare a detailed, step-by-step implementation plan a software engineer can follow to deliver the feature."
argument-hint: "[task or Jira ID]"
---

The request: $ARGUMENTS

Analyze the feature context file for the provided task or Jira ID. Based on it, prepare a detailed implementation plan that a software engineer can follow step by step to deliver the feature.

The file outcome should be a markdown file named after the task Jira ID in kebab-case format or after task name (if no Jira task provided) with `.plan.md` suffix (e.g., `user-authentication.plan.md`). The file should be placed in the `specifications` directory under a folder named after the issue ID or the shortened task name in kebab-case format.

## Required Skills

Before starting, load and follow these skills:

- `fabrico-architecture-designing` - for the architecture design process and output template (`plan.example.md`)
- `fabrico-codebase-analysing` - for analyzing the existing codebase
- `fabrico-implementation-gap-analysing` - for verifying what exists vs what needs to be built
- `fabrico-technical-context-discovering` - for understanding project conventions and patterns
- `fabrico-sql-and-database-understanding` - when the feature involves database schema design, data model changes, migrations, or query-heavy implementation
- `fabrico-improving-ui` - when planning verification for web, iOS, Android, or shared-mobile UI

## Workflow

1. **Analyze context**: Review the feature context file (`.research.md`) thoroughly to understand the requirements and scope. Cross-check with industry, domain, and company best practices.
2. **Analyze tech stack**: Understand the project's tech stack, industry, and domain to identify best practices for implementation.
3. **Verify current implementation**: Before planning, perform a thorough analysis of the existing codebase:
   - Use the **Grep**/**Glob** tools to perform semantic search and find components, functions, hooks, utilities, or files related to the feature requirements.
   - Identify what is already implemented and functional.
   - Identify what exists but needs modification or extension.
   - Identify what needs to be created from scratch.
   - Document findings in the "Current Implementation Analysis" section.
4. **Persist technical context**: During steps 2-3, capture all discovered project conventions, coding standards, architecture patterns, tech stack details, testing patterns, and relevant `CLAUDE.md` memory rules. Save them in the **"Technical Context"** section of the plan file. This section is critical — downstream implementation agents will read it to avoid redundant codebase analysis. Be thorough: include framework conventions, naming patterns, test commands, linting rules, and any project-specific standards.
5. **Understand project standards**: Review project best practices and quality standards (check `CLAUDE.md` memory files — root `CLAUDE.md`, nested `CLAUDE.md` files per directory, and any `@import` references). Incorporate findings into the "Technical Context" section.
6. **Prepare implementation plan**: Create detailed code changes broken down into phases.
7. **Define tasks**: For each phase, identify specific tasks with:
   - Clear title
   - Description of what the task entails
   - Action type: `[CREATE]`, `[MODIFY]`, or `[REUSE]`
   - Definition of done as a checkbox list for each task
8. **Address security**: Include security considerations relevant to the implementation.
9. **UI verification tasks**: Classify visible UI work by target. For **web UI with a Figma design**, add a `[REUSE]` verification task immediately after implementation; reference `fabrico-ui-reviewer`, include the Figma URL and running-page context, and describe the verify-fix loop (max 5 iterations). For **native iOS/Android or design-free UI**, add a `[REUSE]` platform verification task that follows `fabrico-improving-ui` and names the required build, simulator/emulator or device, states, accessibility, screenshot, lint, and test evidence. Never assign native or design-free verification to `fabrico-ui-reviewer` or require Playwright for it. Non-visual tasks do not need UI verification tasks.
10. **Save the plan**: Follow the `plan.example.md` template from the `fabrico-architecture-designing` skill strictly.
11. **Scope control**: Focus ONLY on changes specific to THIS task. Do not include prerequisite work or dependencies - assume those are already done. Do not plan features not in the original requirements (document them separately in an Improvements section).
12. **Avoid duplication**: Never plan to create components, functions, or utilities that already exist. Use the "Current Implementation Analysis" section and plan to reuse or modify existing code.
13. **Bug fixes**: When planning bug fixes, include steps to reproduce the issue, root cause analysis, and implementation of a fix verified by tests.

Don't provide deployment plans, code pushing instructions, or code review instructions in the repository.

Follow the template structure and naming conventions strictly to ensure clarity and consistency.

In case of any ambiguities or missing information for the planning, ask for clarification before finalizing the plan.

Update the plan file after each interaction if new information is gathered.

<!-- FABRICO_COLLECTIONS:command:fabrico-plan:v2 -->
