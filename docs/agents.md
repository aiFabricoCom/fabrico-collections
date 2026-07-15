# Subagents reference

All 21 `fabrico-*` subagents. They auto-activate by their description, or are launched explicitly via the **Task**
tool (the model tier comes from each subagent's `model:` field). Pure reviewers are read-only (no Edit/Write).

## Orchestration

| Subagent | Model | Role |
| --- | --- | --- |
| `fabrico-engineering-manager` | opus | Orchestrator that delegates implementation to specialists; coordinates end-to-end feature delivery. Does not write product code itself. |

## Planning & architecture

| Subagent | Model | Role |
| --- | --- | --- |
| `fabrico-architect` | opus | Designs solution architecture and technical specifications; produces `*.plan.md`. |
| `fabrico-plan-reviewer` | opus | Adversarially stress-tests plans (`.plan.md`) for failure modes and rework risk. Returns APPROVED / REVISIONS NEEDED. Read-only. |
| `fabrico-context-engineer` | opus | Builds task context: gathers requirements, analyzes processes, assembles comprehensive feature context. |

## Implementation

| Subagent | Model | Role |
| --- | --- | --- |
| `fabrico-software-engineer` | sonnet | Implements software solutions from requirements and technical designs. |
| `fabrico-devops-engineer` | sonnet | DevOps: Golden Paths, automation, cloud governance, infrastructure. |
| `fabrico-e2e-engineer` | sonnet | Creates, maintains, and debugs end-to-end tests with Playwright. |
| `fabrico-ui-reviewer` | sonnet | Compares a running web UI against Figma with Playwright; not used for native or design-free audits. |
| `fabrico-prompt-engineer` | opus | Designs, writes, optimizes, and secures LLM application prompts. |

## Review

| Subagent | Model | Role |
| --- | --- | --- |
| `fabrico-code-reviewer` | opus | Performs structured code review and runs quality gates. Read-only. |

## Discovery & business analysis

| Subagent | Model | Role |
| --- | --- | --- |
| `fabrico-business-analyst` | opus | Converts discovery materials (transcripts, designs, codebase) into Jira-ready epics and user stories. Orchestrates the BA workers below. |
| `fabrico-ba-transcript-worker` | haiku | Cleans and structures raw workshop transcripts. |
| `fabrico-ba-extraction-worker` | haiku | Drafts intent briefs and extracts epics/stories. |
| `fabrico-ba-analysis-worker` | haiku | Synthesizes workshop context, backlog overlap, and open questions. |
| `fabrico-ba-quality-worker` | haiku | Runs Lite/Full BA quality review passes; returns structured findings. |
| `fabrico-ba-formatting-worker` | haiku | Prepares Jira-ready formatting and read-back verification. |

## Customization (meta — authoring Claude Code artifacts)

| Subagent | Model | Role |
| --- | --- | --- |
| `fabrico-customization-orchestrator` | opus | Orchestrates complex, multi-step customization work; delegates to researcher → creator → reviewer. |
| `fabrico-customization-engineer` | sonnet | Prompt/context/AI engineering for creating and improving Claude Code customizations. |
| `fabrico-customization-researcher` | sonnet | Gathers and summarizes information from codebases/docs for customization authoring. Read-only. |
| `fabrico-customization-creator` | sonnet | Builds and modifies customization artifacts (subagents, skills, commands, `CLAUDE.md`). |
| `fabrico-customization-reviewer` | sonnet | Evaluates customization artifacts against best practices; structured findings by severity. Read-only. |

> Model tiers: **opus** for orchestration/architecture/review reasoning, **sonnet** for implementation, **haiku**
> for lightweight workers. See [Extending](extending.md) to author your own.
