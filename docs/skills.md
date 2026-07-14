# Supporting skills reference

These 34 `fabrico-*` skills package reusable procedures and domain knowledge for Codex. They live under
`.agents/skills/<name>/SKILL.md` and use progressive disclosure: Codex sees their names and descriptions first,
then loads full instructions and references only when needed. Entry workflows normally activate them
automatically, though you can mention a supporting skill explicitly with `$<skill-name>`.

The 31 user-facing starting points are documented separately in
[Entry workflow skills](workflow-skills.md).

## Discovery & business analysis

| Supporting skill | What it covers |
| --- | --- |
| `fabrico-task-analysing` | Analyze a task, run gap analysis, expand context, build a PRD, and gather information. |
| `fabrico-task-extracting` | Identify and structure epics and user stories from workshop materials. |
| `fabrico-task-quality-reviewing` | Find quality gaps and missing edge cases in extracted stories. |
| `fabrico-transcript-processing` | Clean transcripts and extract decisions, action items, and open questions. |
| `fabrico-jira-task-formatting` | Format epics and stories for Jira with field mapping and review gates. |

## Architecture & context

| Supporting skill | What it covers |
| --- | --- |
| `fabrico-architecture-designing` | Design implementation architecture from task context. |
| `fabrico-codebase-analysing` | Analyze dependencies, business logic, structure, and duplication. |
| `fabrico-technical-context-discovering` | Establish repository conventions, standards, and patterns. |
| `fabrico-implementation-gap-analysing` | Compare a plan with current state and identify missing work. |
| `fabrico-designing-multi-cloud-architecture` | Select and integrate services across AWS, Azure, and GCP. |

## Frontend

| Supporting skill | What it covers |
| --- | --- |
| `fabrico-implementing-frontend` | Components, composition, design tokens, and Figma-to-code workflow. |
| `fabrico-implementing-forms` | Form architecture, schema validation, and multi-step flows. |
| `fabrico-writing-hooks` | Reusable hooks and composables, including lifecycle and testability. |
| `fabrico-ensuring-accessibility` | WCAG 2.1 AA, semantics, keyboard access, focus, and contrast. |
| `fabrico-optimizing-frontend` | Rendering, code splitting, memoization, bundles, and memory. |
| `fabrico-reviewing-frontend` | Frontend review criteria and common anti-patterns. |
| `fabrico-ui-verifying` | UI verification criteria, severity, and Figma tolerances. |

## Backend & data

| Supporting skill | What it covers |
| --- | --- |
| `fabrico-implementing-backend` | REST/GraphQL APIs, CRUD, auth, testing, integrations, logging, and Docker. |
| `fabrico-sql-and-database-understanding` | Schema design, SQL, indexes, transactions, and ORM integration. |

## Quality & testing

| Supporting skill | What it covers |
| --- | --- |
| `fabrico-code-reviewing` | Code quality, acceptance-criteria verification, and review practices. |
| `fabrico-e2e-testing` | Playwright Page Objects, mocking, flaky-test fixes, and CI readiness. |

## DevOps & cloud

| Supporting skill | What it covers |
| --- | --- |
| `fabrico-implementing-ci-cd` | CI/CD pipeline and deployment-strategy patterns. |
| `fabrico-implementing-kubernetes` | Kubernetes, Helm, scaling, and cluster-management patterns. |
| `fabrico-implementing-observability` | Logging, monitoring, alerting, metrics, and tracing. |
| `fabrico-implementing-terraform-modules` | Reusable Terraform modules for AWS, Azure, and GCP. |
| `fabrico-managing-secrets` | Secret storage, rotation, and CI/CD authentication. |
| `fabrico-optimizing-cloud-cost` | Rightsizing, tagging, pricing models, and spend analysis. |

## LLM application prompts

| Supporting skill | What it covers |
| --- | --- |
| `fabrico-engineering-prompts` | Provider-neutral prompt engineering for LLM applications: structure, security, evaluation, and optimization. |

## Legacy modernization

| Supporting skill | What it covers |
| --- | --- |
| `fabrico-reverse-engineering-spec` | Build a platform-agnostic `SPEC.md` from an authorized running app with Playwright. |
| `fabrico-planning-migration` | Plan web, iOS, or React Native migration, including parity, data, auth, UX, and risk. |

## Codex customization

| Supporting skill | What it covers |
| --- | --- |
| `fabrico-creating-agents` | Author Codex custom agents in `.codex/agents/*.toml`. |
| `fabrico-creating-workflows` | Author reusable entry workflow skills. |
| `fabrico-creating-skills` | Author skills in `.agents/skills/<name>/SKILL.md` with progressive disclosure. |
| `fabrico-creating-instructions` | Author root or nested `AGENTS.md` and `AGENTS.override.md` guidance. |
