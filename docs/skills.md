# Skills reference

All 34 `fabrico-*` skills. Skills are **model-invoked**: Claude pulls in the relevant skill automatically when a
task matches its description. You don't call them directly.

## Discovery & business analysis

| Skill | What it covers |
| --- | --- |
| `fabrico-task-analysing` | Analyse a task, run gap analysis, expand context, build a PRD, gather info from multiple sources. |
| `fabrico-task-extracting` | Identify and structure epics and user stories from workshop materials. |
| `fabrico-task-quality-reviewing` | Find quality gaps and missing edge cases in extracted stories; accept/reject suggestions. |
| `fabrico-transcript-processing` | Clean raw transcripts; extract decisions, action items, open questions. |
| `fabrico-jira-task-formatting` | Format epics/stories into Jira-ready output; field mapping and two-gate review. |

## Architecture & context

| Skill | What it covers |
| --- | --- |
| `fabrico-architecture-designing` | Design an architecture to solve a task following best practices. |
| `fabrico-codebase-analysing` | Analyse the codebase: dependencies, business logic, duplications. |
| `fabrico-technical-context-discovering` | Establish project conventions, standards, and patterns before implementing. |
| `fabrico-implementation-gap-analysing` | Compare plan to current state; verify what exists vs. what's needed. |
| `fabrico-designing-multi-cloud-architecture` | Decision framework for selecting/integrating services across AWS, Azure, GCP. |

## Frontend

| Skill | What it covers |
| --- | --- |
| `fabrico-implementing-frontend` | Component patterns, composition, design tokens, Figma-to-code workflow. |
| `fabrico-implementing-forms` | Form architecture, schema validation, field composition, multi-step flows. |
| `fabrico-writing-hooks` | Reusable hooks/composables: naming, composition, stable returns, cleanup, testing. |
| `fabrico-ensuring-accessibility` | WCAG 2.1 AA: semantic HTML, ARIA, keyboard nav, focus, screen readers, contrast. |
| `fabrico-optimizing-frontend` | Rendering optimization, code splitting, memoization, bundle size, memory. |
| `fabrico-reviewing-frontend` | Frontend review criteria: component anti-patterns, hooks quality, rendering. |
| `fabrico-ui-verifying` | UI verification criteria, structure checklists, severity, Figma tolerance rules. |

## Backend & data

| Skill | What it covers |
| --- | --- |
| `fabrico-implementing-backend` | REST/GraphQL APIs, CRUD, auth, testing, integrations, logging, Docker (Node/PHP/.NET/Java/Go). |
| `fabrico-sql-and-database-understanding` | Schema design, performant SQL, indexing, transactions, ORM integration. |

## Quality & testing

| Skill | What it covers |
| --- | --- |
| `fabrico-code-reviewing` | Code review: quality analysis, acceptance-criteria verification, best practices. |
| `fabrico-e2e-testing` | E2E patterns with Playwright: Page Objects, mocking, flaky-test fixes, CI readiness. |

## DevOps & cloud

| Skill | What it covers |
| --- | --- |
| `fabrico-implementing-ci-cd` | CI/CD pipeline design patterns and deployment strategies. |
| `fabrico-implementing-kubernetes` | K8s deployment patterns, Helm charts, scaling, cluster management. |
| `fabrico-implementing-observability` | Logging, monitoring, alerting, distributed tracing. |
| `fabrico-implementing-terraform-modules` | Reusable Terraform modules for AWS/Azure/GCP. |
| `fabrico-managing-secrets` | Secrets storage, rotation, and CI/CD authentication. |
| `fabrico-optimizing-cloud-cost` | Rightsizing, tagging, reserved instances, spend analysis. |

## LLM application prompts

| Skill | What it covers |
| --- | --- |
| `fabrico-engineering-prompts` | Prompt engineering for LLM apps: structure, optimization, security, evaluation. (Not for Claude Code customization — use `fabrico-creating-prompts`.) |

## Legacy modernization

| Skill | What it covers |
| --- | --- |
| `fabrico-reverse-engineering-spec` | Reverse-engineer a platform-agnostic `SPEC.md` from a running web app via Playwright/Chrome. |
| `fabrico-planning-migration` | Plan migration to a modern target (web / iOS / React Native): parity matrix, data/auth/UX, risks. |

## Customization (meta — authoring Claude Code artifacts)

| Skill | What it covers |
| --- | --- |
| `fabrico-creating-agents` | Author subagents (`.claude/agents/*.md`): templates, guidelines, process. |
| `fabrico-creating-prompts` | Author slash commands (`.claude/commands/*.md`). |
| `fabrico-creating-skills` | Author skills (`.claude/skills/<name>/SKILL.md`): naming, descriptions, progressive disclosure. |
| `fabrico-creating-instructions` | Author project memory (`CLAUDE.md`) and nested, directory-scoped memory. |
