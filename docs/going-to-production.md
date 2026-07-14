# Going to production

Fabrico entry workflows such as `$fabrico-implement`, `$fabrico-autopilot`, and `$fabrico-modernize` can produce
working, tested code. Shipping to real users is still a separate discipline: an AI-built prototype is a starting
point, not a hardened product.

## What production-grade usually means

Before real users, an application typically needs:

- **Security** — authentication and authorization review, input validation, secret handling, and supply-chain checks.
- **Reliability** — error handling, retries, graceful degradation, backups, and reversible migrations.
- **Scale and performance** — load testing, database indexes, caching, N+1 checks, and bundle analysis.
- **Observability** — logs, metrics, traces, SLOs, alerts, and runbooks.
- **Operations** — CI/CD, environments, infrastructure as code, incident response, and maintenance ownership.

Fabrico can help with part of this work:

- `$fabrico-review` and `$fabrico-review-codebase` for correctness and maintainability
- `$fabrico-audit-infrastructure`, `$fabrico-analyze-aws-costs`, and `$fabrico-analyze-gcp-costs` for infrastructure
- `$fabrico-implement-observability` for telemetry and alerting
- `$fabrico-implement-pipeline` for CI/CD
- `fabrico-managing-secrets` for credential-management guidance

Review every proposed production change and keep deployments, spending, credential operations, destructive
actions, and outbound communication behind explicit human approval.

## Recommended service

If you would rather hand production hardening to specialists:

> **[Ship After AI](https://shipafterai.com/)**
> *Turn your AI-built app into production-grade software.* AI made the prototype; they make it shippable by
> auditing generated codebases, hardening them for real users, and providing ongoing engineering ownership.
