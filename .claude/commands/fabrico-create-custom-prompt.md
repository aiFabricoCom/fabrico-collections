---
description: "Create a new custom slash command (.claude/commands/*.md) for Claude Code. Analyzes existing commands for patterns, identifies the right subagent to delegate to, creates the command file, and validates the workflow end-to-end."
argument-hint: "[description of the slash command to create, or attached requirements]"
---

> **Delegate to the `fabrico-customization-orchestrator` subagent.** Launch it with the Task tool (subagent_type: `fabrico-customization-orchestrator`), passing the user's request below and any referenced context. Adopt its operating contract; do not do this work in the main thread when the subagent applies.

The request: $ARGUMENTS

Create a new custom slash command for Claude Code. A command lives at `.claude/commands/<name>.md` and uses YAML frontmatter with `description` and (optionally) `argument-hint`, `allowed-tools`, and `model`; the body may use `$ARGUMENTS`/`$1` for user input and can DELEGATE to a subagent. The orchestrator handles research of existing commands and subagents, design decisions, command file creation, and end-to-end validation. The user's message following this command may contain specific requirements or a description of the desired command.

## Required Skills

Before starting, load and follow these skills:
- `fabrico-creating-prompts` - for slash-command file creation workflow, templates, and validation checklist
- `fabrico-technical-context-discovering` - for discovering project conventions and workspace patterns before creating
- `fabrico-codebase-analysing` - for analyzing existing commands for structural patterns and routing conventions

## Workflow

1. **Research existing commands**: Analyze commands in `.claude/commands/` for patterns and conventions:
   - Frontmatter format (`description`, `argument-hint`, optional `allowed-tools` and `model` fields)
   - Body structure (delegation directive, intro, Required Skills, Workflow, optional sections)
   - Skill reference format and conventions
   - Body size and level of detail
2. **Research available subagents**: Analyze subagents in `.claude/agents/` to determine the best delegation target for the new command:
   - Available subagent names (`name` field) and their responsibilities
   - Which subagent is best suited for the command's workflow
   - Existing command-to-subagent delegation patterns
3. **Clarify requirements**: Determine the command's design parameters with the user:
   - Purpose, target workflow, and expected user interaction
   - Which subagent should handle the command (based on subagent research)
   - Required skills the command should reference
   - If the user's message already contains requirements, confirm understanding before proceeding
4. **Create the command file**: Create the `.md` file in `.claude/commands/` with the correct delegation directive, frontmatter (`description`, `argument-hint`), and skill references. Apply the `fabrico-creating-prompts` skill workflow for structure and validation.
5. **Review and validate**: Review the created command against best practices:
   - Verify the delegation-target subagent exists in `.claude/agents/`
   - Confirm structural consistency with existing commands
   - Validate end-to-end workflow (command → subagent → skills → output)

## Important

- When a command should run as a specialized agent, it MUST DELEGATE to a subagent via the Task tool (using the subagent's `name` as `subagent_type`) — this is the established pattern for routing work in this repository. A command's frontmatter does not name an agent; instead the body opens with a delegation directive.
- Research available subagents in `.claude/agents/` before choosing the delegation target for the new command.

If the user attaches files or provides a description, use them as input for command design.

When in doubt about design decisions, ask the user for clarification (the **AskUserQuestion** tool) rather than guessing.

<!-- FABRICO_COLLECTIONS:command:fabrico-create-custom-prompt:v1 -->
