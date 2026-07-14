# Entry workflow skills reference

Fabrico exposes 31 user-facing workflow skills. Invoke one in the Codex composer as
`$fabrico-<name> <context>`. These skills coordinate the relevant custom agents and supporting skills; see
[Custom agents](agents.md) and [Supporting skills](skills.md).

The table uses direct-install names. In a plugin-only installation, prefix the component with the plugin namespace:
`$fabrico-collections:fabrico-<name>`.

## Discovery & backlog

| Workflow skill | Context | What it does |
| --- | --- | --- |
| `$fabrico-analyze-materials` | `[workshop materials, or Jira issue/project keys]` | Process discovery materials into Jira-ready epics and user stories, or iterate on an existing backlog. |
| `$fabrico-explore-materials` | `[transcripts, designs, PDFs, or references]` | Explore workshop materials for business context before backlog extraction. |

## Implementation & review

| Workflow skill | Context | What it does |
| --- | --- | --- |
| `$fabrico-implement` | `[task description or implementation plan]` | Implement a feature according to the plan, orchestrated end to end. |
| `$fabrico-finish-project` | `[existing project path and completion context]` | Close all remaining in-scope gaps and prove whole-project completion. |
| `$fabrico-plan` | `[task or Jira ID]` | Prepare a detailed implementation plan from the feature context. |
| `$fabrico-research` | `[Jira ID or task description]` | Research a task and produce a comprehensive research document. |
| `$fabrico-review` | `[task or Jira ID, or plan/research paths]` | Check the implementation against its plan and feature context. |
| `$fabrico-review-codebase` | `[optional path or layer/app]` | Analyze dead code, duplication, and improvement opportunities. |
| `$fabrico-review-ui` | `[Figma URL and running app URL]` | Compare the implementation with its Figma design. |
| `$fabrico-improve-ui` | `[project path, platforms, screens, or runtime evidence]` | Audit and implement evidence-backed UI improvements for web, iOS, and Android. |

## Internal implementation sub-workflows

These are specialized building blocks the engineering manager uses and that you can invoke directly.

| Workflow skill | Context | What it does |
| --- | --- | --- |
| `$fabrico-implement-common-task` | `[path to *.plan.md or feature]` | Implement a feature strictly from its plan and feature context. |
| `$fabrico-implement-ui` | `[task or Jira ID]` | Implement UI with iterative verification against Figma. |
| `$fabrico-implement-ui-common-task` | `[task or component]` | Implement UI using Figma as the visual source of truth. |
| `$fabrico-implement-e2e` | `[task, Jira ID, or plan/research path]` | Map acceptance criteria to E2E scenarios, implement them, and report coverage. |
| `$fabrico-review-plan` | `[task or Jira ID]` | Stress-test an implementation plan before coding. |

## Autonomous build

| Workflow skill | Context | What it does |
| --- | --- | --- |
| `$fabrico-create-spec` | `[one-line product idea]` | Turn a short idea into a complete, build-ready `SPEC.md`. |
| `$fabrico-autopilot` | `[spec path, e.g. SPEC.md]` | Build from a complete spec: backlog → architecture → plan → implementation → tests → review. See [Autopilot](autopilot.md). |

## Legacy modernization

| Workflow skill | Context | What it does |
| --- | --- | --- |
| `$fabrico-reverse-spec` | `<url> [login/scope notes]` | Reverse-engineer a platform-agnostic `SPEC.md` from an authorized running web app. |
| `$fabrico-modernize` | `<url \| SPEC.md> [web\|ios\|react-native]` | Create a migration plan and rebuild on the selected target. See [Legacy modernization](legacy-modernization.md). |

## Infrastructure & cloud

| Workflow skill | Context | What it does |
| --- | --- | --- |
| `$fabrico-implement-pipeline` | `[pipeline task or Jira ID]` | Create or modify CI/CD pipelines with deployment protections and secure authentication. |
| `$fabrico-implement-terraform` | `[infrastructure task or Jira ID]` | Create or modify Terraform with IaC safety guardrails and cost estimation. |
| `$fabrico-implement-observability` | `[task or Jira ID]` | Implement metrics, logs, traces, and alerting. |
| `$fabrico-deploy-kubernetes` | `[service or workload]` | Create production-ready Kubernetes and Helm configuration. |
| `$fabrico-audit-infrastructure` | `[scope] [security/cost/best-practices/all]` | Audit infrastructure for security gaps, waste, and best-practice violations. |
| `$fabrico-analyze-aws-costs` | `[account/profile, region, or all] [focus]` | Audit AWS cost optimization and tagging compliance. |
| `$fabrico-analyze-gcp-costs` | `[project ID, region, or all] [focus]` | Audit GCP cost optimization and labeling compliance. |

## LLM application prompts

| Workflow skill | Context | What it does |
| --- | --- | --- |
| `$fabrico-engineer-prompt` | `[prompt text, file path, or requirements]` | Design, optimize, audit, or review prompts used by an LLM application. |

## Extending the system

| Workflow skill | Context | What it does |
| --- | --- | --- |
| `$fabrico-create-custom-agent` | `[agent requirements]` | Create a Codex custom agent in `.codex/agents/*.toml`. |
| `$fabrico-create-workflow` | `[workflow requirements]` | Create a reusable entry workflow skill under `.agents/skills/<name>/SKILL.md`. |
| `$fabrico-create-custom-skill` | `[skill requirements]` | Create a supporting skill under `.agents/skills/<name>/SKILL.md`. |
| `$fabrico-create-custom-instructions` | `[conventions or standards]` | Create or update `AGENTS.md` project guidance. |

See [Extending the system](extending.md) for current Codex formats and conventions.
