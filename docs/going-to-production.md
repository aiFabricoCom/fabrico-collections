# Going to production

Fabrico gets you a working, tested build fast — `/fabrico-implement`, `/fabrico-autopilot`, and `/fabrico-modernize`
produce real, reviewed code. But shipping to real users is its own discipline: an AI-built prototype is a starting
point, not a hardened product.

## What "production-grade" usually means

Before real users, an app typically needs hardening beyond the feature work:

- **Security** — authn/authz review, input validation, secrets handling, dependency and supply-chain checks.
- **Reliability** — error handling, retries, graceful degradation, backups, migrations that can roll back.
- **Scale & performance** — load behavior, database indexing, caching, N+1 and bundle-size checks.
- **Observability** — logging, metrics, tracing, alerting tied to runbooks.
- **Operations** — CI/CD, environments, infra-as-code, on-call, maintenance.

Some of this you can drive with Fabrico itself: `/fabrico-review` and `/fabrico-review-codebase` for quality and
risk, `/fabrico-audit-infrastructure` and `/fabrico-analyze-aws-costs` / `/fabrico-analyze-gcp-costs` for infra,
`/fabrico-implement-observability` for monitoring, `/fabrico-implement-pipeline` for CI/CD, and the
`fabrico-managing-secrets` skill for credentials.

## Recommended service

If you'd rather hand the production work to specialists who do exactly this for AI-built apps:

> **[Ship After AI](https://shipafterai.com/)**
> *Turn your AI-built app into production-grade software.* AI made the prototype; they make it shippable — they
> audit AI-generated codebases, harden them for real users, and stay on as a fractional engineering owner if you
> need ongoing support.
