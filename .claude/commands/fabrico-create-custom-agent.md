---
description: "Create a new custom subagent (.claude/agents/*.md) for Claude Code. Analyzes existing subagents for patterns, guides through design decisions, creates the subagent file, and validates against best practices."
argument-hint: "[subagent requirements or description of the desired subagent]"
---

> **Delegate to the `fabrico-customization-orchestrator` subagent.** Launch it with the Task tool (subagent_type: `fabrico-customization-orchestrator`), passing the user's request below and any referenced context. Adopt its operating contract; do not do this work in the main thread when the subagent applies.

Create a new custom subagent for Claude Code. The orchestrator handles research of existing subagents, design decisions, subagent file creation, and review against best practices. The user's message following this command may contain specific subagent requirements or a description of the desired subagent.

The request: $ARGUMENTS

## Required Skills

Before starting, load and follow these skills:
- `fabrico-creating-agents` - for subagent file creation workflow, templates, and validation checklist
- `fabrico-technical-context-discovering` - for discovering project conventions and workspace patterns before creating
- `fabrico-codebase-analysing` - for analyzing existing subagents for structural patterns and naming conventions

## Workflow

1. **Research existing subagents**: Analyze subagents in `.claude/agents/` for patterns and conventions:
   - Naming conventions and file placement
   - Structural patterns (sections, headings, formatting)
   - Tool configurations and skill references
   - Behavioral constraints and personality definitions
2. **Clarify requirements**: Determine the subagent's design parameters with the user:
   - Purpose and primary responsibilities
   - Target workflows and use cases
   - Tool needs and skill references
   - If the user's message already contains requirements, confirm understanding before proceeding
3. **Design the subagent**: Make design decisions based on research findings and user input:
   - Subagent name, description, and personality
   - Tool list and skill references
   - Behavioral constraints and operational boundaries
   - How the subagent fits within the existing subagent ecosystem
4. **Create the subagent file**: Create the `.claude/agents/<name>.md` file following established conventions. Apply the `fabrico-creating-agents` skill workflow for structure and validation. The subagent frontmatter supports `name` (must equal the destination filename without `.md`), `description` (action-oriented so Claude auto-routes to it), an optional `tools` field, and an optional `model` field.
5. **Review and validate**: Review the created subagent against best practices:
   - Verify skill and tool references point to valid targets
   - Confirm structural consistency with existing subagents
   - Check that the subagent integrates well with the existing ecosystem

If the user attaches files or provides a description, use them as input for subagent design.

Follow the conventions established by existing subagents in the workspace.

When in doubt about design decisions, ask the user for clarification rather than guessing.

<!-- FABRICO_COLLECTIONS:command:fabrico-create-custom-agent:v1 -->
