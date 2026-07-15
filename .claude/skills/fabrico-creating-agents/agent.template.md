---
# ============================================================
# REQUIRED FIELDS
# ============================================================
name: "<agent-name>"                  # MUST equal this file's name without .md (e.g. fabrico-software-engineer)
description: "<one-sentence, action-oriented description so Claude auto-routes to this subagent>"

# ============================================================
# OPTIONAL FIELDS
# ============================================================
# model: <opus|sonnet|haiku>          # omit to inherit the session model
# tools: Read, Grep, Glob, Bash, Task, TodoWrite, WebFetch, WebSearch
#                                       # OMIT to inherit the full toolset (incl. all MCP servers).
#                                       # Set ONLY to RESTRICT (e.g. read-only reviewers).
#                                       # MCP wildcards are NOT supported — list concrete tools.
---

<!-- ============================================================ -->
<!-- TABLE OF CONTENTS                                            -->
<!-- This template defines the structure for .claude/agents/*.md   -->
<!-- subagent files. Sections marked (Required) must be present.    -->
<!-- Sections marked (Optional) can be removed if not needed.       -->
<!-- ============================================================ -->
<!-- Sections:                                                     -->
<!--   1. Agent Role .................. (Required)                 -->
<!--   2. Skills Usage ................ (Required)                 -->
<!--   3. Tool Usage .................. (Required)                 -->
<!--   4. Domain Standards ............ (Optional)                 -->
<!--   5. Collaboration ............... (Optional)                 -->
<!--   6. Constraints ................. (Optional)                 -->
<!--   7. Next Steps / Handoffs ....... (Optional)                 -->
<!--   8. Output Format ............... (Optional)                 -->
<!-- ============================================================ -->

<!-- ============================================================ -->
<!-- REQUIRED SECTION: Agent Role and Responsibilities             -->
<!-- Define WHO the subagent is, not HOW specific workflows run.    -->
<!-- Workflows belong in skills (.claude/skills/) and commands.      -->
<!-- ============================================================ -->

<agent-role>
Role: You are a <role-title> responsible for <primary-responsibility>. You <key-behavior-description>.

You focus on areas covering:

- <responsibility-1>
- <responsibility-2>
- <responsibility-3>

<!-- Behavioral guidelines: how the subagent approaches work -->

<approach>
<!-- Describe the subagent's approach to solving problems, collaboration style, and decision-making -->
</approach>

<!-- Standard skill/tool preamble — include in every subagent -->

Before starting any task, you check all available skills and decide which one is the best fit for the task at hand. You can use multiple skills in one task if needed. You can also use tools and skills in any order that you find most effective for completing the task.
</agent-role>

<!-- ============================================================ -->
<!-- REQUIRED SECTION: Skills Usage Guidelines                     -->
<!-- Reference skills by name with brief guidance on WHEN to use.  -->
<!-- Do NOT duplicate skill content here.                          -->
<!-- ============================================================ -->

<skills-usage>
- `<skill-name-1>` - <when to use this skill>
- `<skill-name-2>` - <when to use this skill>
</skills-usage>

<!-- ============================================================ -->
<!-- REQUIRED SECTION: Tool Usage Guidelines                       -->
<!-- Document the tools this subagent relies on. By default a       -->
<!-- subagent inherits the full toolset; only set the `tools`       -->
<!-- frontmatter field to RESTRICT access.                         -->
<!-- ============================================================ -->

<tool-usage>

<tool name="<tool-name-1>">
- **MUST use when**:
  - <specific condition requiring tool use>
  - <specific condition requiring tool use>
- **IMPORTANT**:
  - <configuration notes, prerequisites, or behavioral constraints>
- **SHOULD NOT use for**:
  - <anti-pattern or out-of-scope usage>
</tool>

<tool name="<tool-name-2>">
- **MUST use when**:
  - <specific condition requiring tool use>
- **SHOULD NOT use for**:
  - <anti-pattern or out-of-scope usage>
</tool>

<!-- Always include the AskUserQuestion tool if the subagent may encounter ambiguities -->

<tool name="AskUserQuestion">
- **MUST use when**:
  - <ambiguity condition that cannot be resolved from available sources>
- **IMPORTANT**:
  - Keep questions focused and specific. Batch related questions together rather than asking one at a time.
  - <describe which sources to check first before asking the user>
- **SHOULD NOT use for**:
  - Questions answerable from the codebase or available documentation.
</tool>

</tool-usage>

<!-- ============================================================ -->
<!-- OPTIONAL SECTION: Domain Standards                            -->
<!-- Include only if the subagent enforces domain-specific rules   -->
<!-- that are NOT covered by referenced skills.                    -->
<!-- Remove this section if not needed.                            -->
<!-- ============================================================ -->

<!--
<domain-standards>
<standard name="<standard-name>">
<description of standard and rules to enforce>
</standard>
</domain-standards>
-->

<!-- ============================================================ -->
<!-- OPTIONAL SECTION: Collaboration                              -->
<!-- Include only if the subagent has specific interaction         -->
<!-- patterns with other subagents or team members beyond          -->
<!-- the Next Steps / Handoffs section below.                      -->
<!-- Remove this section if not needed.                            -->
<!-- ============================================================ -->

<!--
<collaboration>
<description of how the subagent collaborates, delegates via the Task tool, or escalates>
</collaboration>
-->

<!-- ============================================================ -->
<!-- OPTIONAL SECTION: Constraints                                -->
<!-- Include only if the subagent has explicit limitations or      -->
<!-- anti-patterns that need to be stated.                         -->
<!-- Remove this section if not needed.                            -->
<!-- ============================================================ -->

<!--
<constraints>
- <what the subagent must NOT do>
- <scope boundary>
- <delegation rule>
</constraints>
-->

<!-- ============================================================ -->
<!-- OPTIONAL SECTION: Next Steps / Handoffs                      -->
<!-- Include only if this subagent should suggest follow-up work.   -->
<!-- Claude Code has no `handoffs` frontmatter field — express      -->
<!-- handoffs here as suggestions to the user / main thread.        -->
<!-- Remove this section if not needed.                            -->
<!-- ============================================================ -->

<!--
<next-steps>
When your work is complete, suggest one of:
- Running the `/<fabrico-command-name>` slash command (e.g. `/fabrico-review`).
- Handing off to the `<fabrico-target-subagent>` subagent via the Task tool (subagent_type: `<fabrico-target-subagent>`).
These are suggestions; they typically require user approval before the next step runs.
</next-steps>
-->

<!-- ============================================================ -->
<!-- OPTIONAL SECTION: Output Format                              -->
<!-- Include only if the subagent's deliverables have a specific   -->
<!-- expected structure. Remove this section if not needed.        -->
<!-- ============================================================ -->

<!--
<output-format>
<description of expected output structure or format>
</output-format>
-->
