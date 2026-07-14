# Workflows

## How the system works

Fabrico is built for **automated, multi-agent delivery**. You explicitly mention an entry workflow skill in the
Codex composer; Codex loads that workflow, delegates focused work to custom agents, and pulls in supporting skills
as needed.

- **Entry workflow skills** (`.agents/skills/fabrico-*/SKILL.md`) are the 31 user-facing starting points, invoked
  as `$fabrico-…`.
- **Custom agents** (`.codex/agents/fabrico-*.toml`) define 21 specialized roles such as architect, engineer,
  reviewer, and business analyst.
- **Supporting skills** (`.agents/skills/fabrico-*/SKILL.md`) provide 34 reusable procedures and domain knowledge.
  Codex normally activates them from the task and skill descriptions; you can also mention one explicitly with `$`.

State flows between phases through intermediate files such as `*.research.md` and `*.plan.md`. Autonomous flows
also use `SPEC.md`, `MIGRATION-PLAN.md`, `ASSUMPTIONS.md`, and `BUILD-SUMMARY.md`. Keep these files: they let
agents verify and resume work without reconstructing context.

## The golden path

```text
$fabrico-analyze-materials   → workshop inputs / notes / Figma → epics + user stories
        ↓
$fabrico-implement <task or Jira ID>
        ↓  fabrico-engineering-manager coordinates:
   research → plan → [you confirm the plan] → implementation → UI verification → code review
        ↓
$fabrico-review <task>       → separate, structured code review
```

### 1. Discovery → backlog

`$fabrico-analyze-materials` turns transcripts, notes, Figma links, and PDFs into structured epics and user
stories. The `fabrico-business-analyst` coordinates focused BA workers for transcript cleanup, extraction,
analysis, quality review, and formatting. Use `$fabrico-explore-materials` first when you only want to survey the
material.

### 2. Implementation

`$fabrico-implement <task or Jira ID>` routes the workflow to `fabrico-engineering-manager`, which:

1. establishes task context and asks `fabrico-context-engineer` or `fabrico-architect` for missing research and a
   `*.plan.md`,
2. asks `fabrico-plan-reviewer` to stress-test the plan,
3. **pauses for your confirmation** of the approved plan,
4. delegates implementation to the appropriate specialist, such as `fabrico-software-engineer`,
   `fabrico-devops-engineer`, or `fabrico-prompt-engineer`,
5. verifies Figma-based UI with `fabrico-ui-reviewer` and Playwright,
6. finishes with `fabrico-code-reviewer` and the required quality gates.

For a single, well-scoped change it can use a **Quick flow** (implement → review). Multi-component or ambiguous
work uses the **Full flow** (research → plan → implement → verify → review).

### 3. Review

`$fabrico-review` checks an implementation against its plan and feature context. Related entry workflows include
`$fabrico-review-ui` for Figma comparison, `$fabrico-review-codebase` for broader maintainability analysis, and
`$fabrico-review-plan` for adversarial plan review.

## The gates — where you stay in control

The Full flow intentionally stops at meaningful decision points:

- **Flow choice** — Quick or Full; you can override the recommendation.
- **Plan confirmation** — review and adjust `*.plan.md` before implementation.
- **UI verification gate** — Figma-based UI work must pass Playwright verification before code review.
- **External effects** — credentials, spending, deployment, destructive changes, and outbound actions require
  explicit authority.

Use an autonomous workflow only when its documented autonomy contract fits the task.

## Beyond the golden path

- **Autonomous build from a spec:** [`$fabrico-autopilot`](autopilot.md).
- **Finish an existing partial project:** `$fabrico-finish-project` closes scoped gaps and proves completion.
- **Cross-platform UI improvement:** `$fabrico-improve-ui` audits and implements evidence-backed improvements for
  existing web, iOS, and Android interfaces.
- **Legacy modernization:** [`$fabrico-reverse-spec` and `$fabrico-modernize`](legacy-modernization.md).
- **Infrastructure and cloud:** `$fabrico-implement-pipeline`, `$fabrico-implement-terraform`,
  `$fabrico-implement-observability`, `$fabrico-deploy-kubernetes`, `$fabrico-audit-infrastructure`,
  `$fabrico-analyze-aws-costs`, and `$fabrico-analyze-gcp-costs`.
- **LLM application prompts:** `$fabrico-engineer-prompt`, which is separate from authoring Codex customization
  artifacts; see [Extending](extending.md).

See the complete [Entry workflow skills reference](workflow-skills.md).
