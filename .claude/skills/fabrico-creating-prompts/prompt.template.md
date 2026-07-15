---
# ============================================================
# FRONTMATTER
# Claude Code slash command. Place this file at
#   .claude/commands/fabrico-<name>.md   (project scope)
#   ~/.claude/commands/fabrico-<name>.md (global scope)
# and invoke it as /fabrico-<name>.
# ============================================================
description: "<one-sentence description of what the command does>"

# ============================================================
# OPTIONAL FIELDS
# Uncomment and fill in only when needed for the workflow.
# ============================================================
# argument-hint: "<hint text for the / menu, e.g. [Jira ID or task description]>"
# allowed-tools: Read, Grep, Glob, Bash, mcp__<server>__*   # omit to inherit the full toolset
# model: <opus|sonnet|haiku>                                 # omit to inherit the session model
---

<!-- ============================================================ -->
<!-- OPTIONAL: Delegation directive (FIRST line of the body)       -->
<!-- Uncomment if this workflow has a clear subagent owner.        -->
<!-- Use the owning subagent's fabrico- name (.claude/agents/).    -->
<!-- ============================================================ -->

<!--
> **Delegate to the `<fabrico-subagent-name>` subagent.** Launch it with the Task tool (subagent_type: `<fabrico-subagent-name>`), passing the user's request below and any referenced context. Adopt its operating contract; do not do this work in the main thread when the subagent applies.
-->

<!-- ============================================================ -->
<!-- TABLE OF CONTENTS                                             -->
<!-- This template defines the structure for .claude/commands/*.md  -->
<!-- files. Sections marked (Required) must be present in every     -->
<!-- command. Sections marked (Optional) can be removed if unused.  -->
<!-- ============================================================ -->
<!-- Sections:                                                     -->
<!--   0. Delegation directive ........ (Optional)                 -->
<!--   1. Goal Statement .............. (Required)                 -->
<!--   2. Prerequisites ............... (Optional)                 -->
<!--   3. Input Requirements .......... (Optional)                 -->
<!--   4. Required Skills ............. (Required)                 -->
<!--   5. Workflow .................... (Required)                 -->
<!--   6. Output Specification ........ (Optional)                 -->
<!--   7. Handoff .................... (Optional)                 -->
<!--   8. Constraints ................ (Optional)                 -->
<!-- ============================================================ -->

<!-- ============================================================ -->
<!-- REQUIRED: Goal Statement                                      -->
<!-- 1-2 paragraphs describing what the command accomplishes and   -->
<!-- the expected outcome. Be specific about the workflow purpose. -->
<!-- This is NOT the subagent's role — it's the task being         -->
<!-- triggered. If the command operates on user input, reference   -->
<!-- it with $ARGUMENTS (e.g. "The request: $ARGUMENTS").          -->
<!-- ============================================================ -->

<goal>
Describe in 1-2 paragraphs what this command accomplishes and the expected outcome.
Be specific about the workflow purpose. This is NOT the subagent's role — it's the task being triggered.

The request: $ARGUMENTS
</goal>

<!-- ============================================================ -->
<!-- OPTIONAL: Prerequisites                                       -->
<!-- Uncomment if this command depends on another command or file  -->
<!-- being completed first.                                        -->
<!-- ============================================================ -->

<!--
<prerequisites>
> **PREREQUISITE**: Before using this command, you MUST first <describe dependency>.

- `/fabrico-dependency-command` (`.claude/commands/fabrico-dependency-command.md`) — <why it must run first>
- `*.research.md` or `*.plan.md` — <what context it provides>
</prerequisites>
-->

<!-- ============================================================ -->
<!-- OPTIONAL: Input Requirements                                  -->
<!-- Uncomment if the workflow needs specific inputs or context    -->
<!-- to start. Inputs typically arrive via $ARGUMENTS / $1 / $2.   -->
<!-- ============================================================ -->

<!--
<input-requirements>
Before running this workflow, ensure you have:

1. **<input-1>** — <description of first required input>
2. **<input-2>** — <description of second required input>

If any input is missing: STOP and ask the user to provide it (the AskUserQuestion tool can collect it).
</input-requirements>
-->

<!-- ============================================================ -->
<!-- REQUIRED: Required Skills                                     -->
<!-- List skills that must be loaded before starting.              -->
<!-- Reference existing skills from .claude/skills/ only.          -->
<!-- Include a brief rationale for each skill.                     -->
<!-- ============================================================ -->

<required-skills>
## Required Skills

Before starting, load and follow these skills:
- `<skill-name-1>` - <why this skill is needed for the workflow>
- `<skill-name-2>` - <why this skill is needed for the workflow>
</required-skills>

<!-- ============================================================ -->
<!-- REQUIRED: Workflow                                             -->
<!-- Numbered steps defining the workflow sequence.                 -->
<!-- Each step should be clear and actionable.                     -->
<!-- Reference skills and tools where appropriate.                 -->
<!-- Keep focus on WHAT to do, not HOW to think (the subagent      -->
<!-- handles the reasoning approach based on its role).            -->
<!-- ============================================================ -->

<workflow>
## Workflow

1. **<step-title>**: <description of what to do in this step>.
2. **<step-title>**: <description of what to do in this step>.
3. **<step-title>**: <description of what to do in this step>.
4. **<step-title>**: <description of what to do in this step>.
</workflow>

<!-- ============================================================ -->
<!-- OPTIONAL: Output Specification                                -->
<!-- Uncomment if the workflow produces a specific deliverable     -->
<!-- (document, report, file). Define naming conventions,          -->
<!-- file location, structure, and success criteria.               -->
<!-- ============================================================ -->

<!--
<output-specification>
## Output

The file outcome should be a markdown file named `<naming-convention>` with `.<suffix>.md` extension.
The file should be placed in `<target-directory>`.

Follow the `<template-name>` template from the `<skill-name>` skill.

### Success Criteria

- <criterion-1>
- <criterion-2>
</output-specification>
-->

<!-- ============================================================ -->
<!-- OPTIONAL: Handoff                                             -->
<!-- Uncomment if the workflow should hand off at the end. Either   -->
<!-- delegate to another subagent via the Task tool, or suggest a   -->
<!-- follow-up slash command.                                       -->
<!-- ============================================================ -->

<!--
<handoff>
## Automatic Follow-up

After completing this workflow, hand off to the `<fabrico-target-subagent>` subagent via the Task tool
(subagent_type: `<fabrico-target-subagent>`) to <purpose of handoff> — or run the `/fabrico-<target-command>`
slash command. Update the changelog section of the plan file to indicate that <handoff action> was performed.
</handoff>
-->

<!-- ============================================================ -->
<!-- OPTIONAL: Constraints                                         -->
<!-- Uncomment if the workflow has specific limitations,           -->
<!-- anti-patterns, or scope boundaries that must be enforced.     -->
<!-- These are workflow-specific, NOT subagent personality rules.  -->
<!-- ============================================================ -->

<!--
<constraints>
## Constraints

- Do not <anti-pattern-1>.
- Do not <anti-pattern-2>.
- Focus ONLY on <scope boundary>.
- In case of <ambiguity>, ask for clarification before proceeding.
</constraints>
-->
