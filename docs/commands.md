# Commands reference

All 31 `/fabrico-*` slash commands. Invoke as `/fabrico-<name> <arguments>`. Many delegate to an owning subagent
(see [Subagents](agents.md)).

## Discovery & backlog

| Command | Arguments | What it does |
| --- | --- | --- |
| `/fabrico-analyze-materials` | `[workshop materials, or Jira issue/project keys]` | Process discovery workshop materials into Jira-ready epics and user stories, or iterate on an existing backlog. |
| `/fabrico-explore-materials` | `[transcripts, designs, PDFs, or references]` | Explore workshop materials for business context before backlog extraction. |

## Implementation & review

| Command | Arguments | What it does |
| --- | --- | --- |
| `/fabrico-implement` | `[task description or implementation plan]` | Implement a feature according to the plan — orchestrated end to end. |
| `/fabrico-plan` | `[task or Jira ID]` | Prepare a detailed, step-by-step implementation plan from the feature context. |
| `/fabrico-research` | `[Jira ID or task description]` | Research a task and produce a comprehensive research markdown file. |
| `/fabrico-review` | `[task or Jira ID, or path to plan/research files]` | Check the implementation against the plan and feature context. |
| `/fabrico-review-codebase` | `[optional path or layer/app to scope]` | Code quality analysis: dead code, duplications, improvement opportunities. |
| `/fabrico-review-ui` | `[Figma URL] [running web app URL]` | Single-pass web UI verification: browser implementation vs Figma. |
| `/fabrico-improve-ui` | `[project path] [web\|ios\|android] [optional scope]` | Audit and safely improve an existing UI with platform-specific before/after verification. |
| `/fabrico-finish-project` | `[project path and completion context]` | Close scoped gaps in an existing partial project and prove its definition of done. |

## Internal implementation sub-workflows

Specialized building blocks the engineering manager (or you) can invoke directly.

| Command | Arguments | What it does |
| --- | --- | --- |
| `/fabrico-implement-common-task` | `[path to *.plan.md or feature]` | Implement a feature strictly following a plan and feature context. |
| `/fabrico-implement-ui` | `[task or Jira ID]` | Implement a web UI feature with iterative browser verification against Figma. |
| `/fabrico-implement-ui-common-task` | `[task or component]` | Implement a web UI feature using Figma as the visual source of truth. |
| `/fabrico-implement-e2e` | `[task, Jira ID, or plan/research path]` | Map acceptance criteria to E2E scenarios, build Page Objects, verify, report coverage. |
| `/fabrico-review-plan` | `[task or Jira ID]` | Stress-test an implementation plan for failure modes before coding. |

## Autonomous build

| Command | Arguments | What it does |
| --- | --- | --- |
| `/fabrico-create-spec` | `[one-line product idea]` | Turn a short product idea into a complete, build-ready `SPEC.md`. |
| `/fabrico-autopilot` | `[path to spec file, e.g. SPEC.md]` | Build working software from a complete spec autonomously: backlog → architecture → plan → implement → test → review. See [Autopilot](autopilot.md). |

## Legacy modernization

| Command | Arguments | What it does |
| --- | --- | --- |
| `/fabrico-reverse-spec` | `<url> [login/scope notes]` | Reverse-engineer a platform-agnostic `SPEC.md` from a running web app via Playwright/Chrome. |
| `/fabrico-modernize` | `<url \| SPEC.md> [web\|ios\|react-native]` | Reverse-spec → migration plan → autonomous rebuild on a chosen target. See [Legacy modernization](legacy-modernization.md). |

## Infrastructure & cloud

| Command | Arguments | What it does |
| --- | --- | --- |
| `/fabrico-implement-pipeline` | `[pipeline task or Jira ID]` | Create/modify CI/CD pipelines with deployment stages, env protection, secure auth. |
| `/fabrico-implement-terraform` | `[infrastructure task or Jira ID]` | Create/modify Terraform modules with IaC safety guardrails and cost estimation. |
| `/fabrico-implement-observability` | `[task or Jira ID]` | Implement metrics, logs, traces, and alerting (RED/USE, SLOs/SLIs). |
| `/fabrico-deploy-kubernetes` | `[service or workload to deploy]` | Kubernetes deployments, Helm charts, production-ready workload configs. |
| `/fabrico-audit-infrastructure` | `[scope] [focus: security/cost/best-practices/all]` | Audit infrastructure for security gaps, cost waste, and best-practice violations. |
| `/fabrico-analyze-aws-costs` | `[Account/Profile, Region, or 'all'] [focus]` | AWS cost optimization & tagging compliance audit (IaC + live infra). |
| `/fabrico-analyze-gcp-costs` | `[Project ID, Region, or 'all'] [focus]` | GCP cost optimization & labeling compliance audit (IaC + live infra). |

## LLM application prompts

| Command | Arguments | What it does |
| --- | --- | --- |
| `/fabrico-engineer-prompt` | `[prompt text, file path, or requirements]` | Design, optimize, audit, or review LLM application prompts. |

## Extending the system

| Command | Arguments | What it does |
| --- | --- | --- |
| `/fabrico-create-custom-agent` | `[subagent requirements]` | Create a new subagent (`.claude/agents/*.md`). |
| `/fabrico-create-custom-prompt` | `[command description/requirements]` | Create a new slash command (`.claude/commands/*.md`). |
| `/fabrico-create-custom-skill` | `[skill description or requirements]` | Create a new skill (`.claude/skills/<name>/SKILL.md`). |
| `/fabrico-create-custom-instructions` | `[conventions or standards to encode]` | Create project memory (`CLAUDE.md`). |

See [Extending the system](extending.md) for formats and conventions.
