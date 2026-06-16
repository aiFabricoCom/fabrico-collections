# Workflows

## How the system works

The collection is built for **automated, multi-agent delivery**. You type a slash command; most commands delegate
to a specialized subagent via the **Task** tool, and that subagent may delegate further. Three building blocks:

- **Commands** (`.claude/commands/fabrico-*.md`) — entry points you invoke as `/fabrico-…`. Many begin with a
  delegation directive that routes the work to an owning subagent.
- **Subagents** (`.claude/agents/fabrico-*.md`) — specialized roles (architect, engineer, reviewer, …) that
  auto-activate by their description or are launched explicitly via the Task tool.
- **Skills** (`.claude/skills/fabrico-*/`) — procedural knowledge Claude pulls in automatically when a task matches
  the skill's description.

State flows between phases through **intermediate files**: `*.research.md`, `*.plan.md` (and `SPEC.md`,
`MIGRATION-PLAN.md`, `BUILD-SUMMARY.md` for the autonomous flows). Don't delete them — they are the memory the
agents resume from.

## The golden path

```
/fabrico-analyze-materials   →  workshop inputs / notes / Figma  →  epics + user stories (Jira-ready)
        ↓
/fabrico-implement <task or Jira ID>
        ↓  fabrico-engineering-manager orchestrates:
   research → plan → [you confirm the plan] → implementation → UI verification → code review
        ↓
/fabrico-review <task>       →  separate, structured code review
```

### 1. Discovery → backlog

`/fabrico-analyze-materials` turns raw inputs (transcripts, notes, Figma links, PDFs) into structured epics and
user stories. Behind it: `fabrico-business-analyst` orchestrating the BA worker subagents (transcript → extraction
→ analysis → quality → formatting). Use `/fabrico-explore-materials` first if you want to survey the material
before committing to extraction.

### 2. Implementation

`/fabrico-implement <task or Jira ID>` delegates to `fabrico-engineering-manager`, which:

1. ensures the task is ready (delegating to `fabrico-context-engineer` / `fabrico-architect` for research and a
   `*.plan.md` if missing),
2. has the plan stress-tested by `fabrico-plan-reviewer`,
3. **pauses for your confirmation** of the plan,
4. delegates each task to the right specialist (`fabrico-software-engineer`, `fabrico-devops-engineer`,
   `fabrico-prompt-engineer`), running tests/lint/build after each,
5. verifies UI work with `fabrico-ui-reviewer` (Figma + Playwright),
6. hands off to `fabrico-code-reviewer` for the quality gates.

For a single, well-scoped change it picks a **Quick flow** (engineer → review). For multi-component or ambiguous
work it picks the **Full flow** (research → plan → implement → verify → review).

### 3. Review

`/fabrico-review` runs a structured review against the plan and feature context. Related: `/fabrico-review-ui`
(implementation vs Figma), `/fabrico-review-codebase` (dead code, duplication, improvement opportunities),
`/fabrico-review-plan` (stress-test a plan before coding).

## The gates — where you stay in control

The Full flow intentionally pauses at a few points:

- **Flow choice** — Quick vs Full (you can override the recommendation).
- **Plan confirmation** — review and adjust the `*.plan.md` before any code is written. This is the single biggest
  quality lever.
- **UI verification gate** — every UI task must pass Figma/Playwright verification before code review.

If you'd rather not stop at each gate, use the autonomous flows below.

## Beyond the golden path

- **Autonomous build from a spec:** [`/fabrico-autopilot`](autopilot.md) runs the whole pipeline without per-gate
  pauses.
- **Legacy modernization:** [`/fabrico-reverse-spec` and `/fabrico-modernize`](legacy-modernization.md) turn an
  existing web app into a spec and rebuild it.
- **Infrastructure & cloud:** `/fabrico-implement-pipeline`, `/fabrico-implement-terraform`,
  `/fabrico-implement-observability`, `/fabrico-deploy-kubernetes`, `/fabrico-audit-infrastructure`,
  `/fabrico-analyze-aws-costs`, `/fabrico-analyze-gcp-costs`.
- **LLM application prompts:** `/fabrico-engineer-prompt` (distinct from authoring Claude Code commands — see
  [Extending](extending.md)).

See the full [Commands reference](commands.md).
