# Custom agents reference

Fabrico defines 21 project-scoped Codex agents in `.codex/agents/fabrico-*.toml`. Entry workflow skills tell Codex
which role to spawn and what bounded task to delegate. Each TOML file contains `name`, `description`, and
`developer_instructions`; specialized settings such as `model_reasoning_effort` and `sandbox_mode` are used only
where the role needs them.

The reasoning profile expresses workload, not a vendor-specific model family:

- **high** — orchestration, architecture, and adversarial review
- **medium** — implementation and focused customization work
- **low** — narrow, repeatable worker tasks

## Orchestration

| Custom agent | Reasoning | Role |
| --- | --- | --- |
| `fabrico-engineering-manager` | high | Coordinates end-to-end delivery and delegates implementation; does not write product code itself. |

## Planning & architecture

| Custom agent | Reasoning | Role |
| --- | --- | --- |
| `fabrico-architect` | high | Designs solution architecture and produces technical `*.plan.md` files. |
| `fabrico-plan-reviewer` | high | Stress-tests plans for failure modes and rework risk; writes the bounded `*.plan-review.md` result without changing implementation code. |
| `fabrico-context-engineer` | high | Gathers requirements and builds comprehensive feature context. |

## Implementation

| Custom agent | Reasoning | Role |
| --- | --- | --- |
| `fabrico-software-engineer` | medium | Implements software from requirements and technical designs. |
| `fabrico-devops-engineer` | medium | Handles Golden Paths, automation, cloud governance, and infrastructure. |
| `fabrico-e2e-engineer` | medium | Creates, maintains, and debugs Playwright end-to-end tests. |
| `fabrico-ui-reviewer` | medium | Verifies implemented UI against Figma and frontend guidelines. |
| `fabrico-prompt-engineer` | high | Designs, optimizes, and secures prompts used by LLM applications. |

## Review

| Custom agent | Reasoning | Role |
| --- | --- | --- |
| `fabrico-code-reviewer` | high | Performs structured code review, runs quality gates, and writes only requested review documentation or checklist updates. |

## Discovery & business analysis

| Custom agent | Reasoning | Role |
| --- | --- | --- |
| `fabrico-business-analyst` | high | Converts discovery materials into Jira-ready epics and stories and coordinates the BA workers below. |
| `fabrico-ba-transcript-worker` | low | Cleans and structures raw workshop transcripts. |
| `fabrico-ba-extraction-worker` | low | Drafts intent briefs and extracts epics and stories. |
| `fabrico-ba-analysis-worker` | low | Synthesizes workshop context, backlog overlap, and open questions. |
| `fabrico-ba-quality-worker` | low | Runs Lite or Full BA quality review passes. |
| `fabrico-ba-formatting-worker` | low | Produces Jira-ready formatting and read-back verification. |

## Codex customization

| Custom agent | Reasoning | Role |
| --- | --- | --- |
| `fabrico-customization-orchestrator` | high | Coordinates complex customization work through researcher → creator → reviewer. |
| `fabrico-customization-engineer` | high | Designs and improves Codex agents, skills, project guidance, and configuration. |
| `fabrico-customization-researcher` | medium | Researches current Codex formats and workspace patterns. Read-only. |
| `fabrico-customization-creator` | medium | Builds and updates Codex customization artifacts. |
| `fabrico-customization-reviewer` | high | Reviews customization artifacts against current formats and repository conventions. Read-only. |

Read-only roles use Codex sandbox configuration and behavioral constraints rather than a hard-coded tool-name
allowlist. The code and plan reviewers deliberately use `workspace-write` only to persist named review reports and
review-owned checklist updates; their contracts prohibit product-code changes. See [Extending](extending.md) to
create another custom agent.
