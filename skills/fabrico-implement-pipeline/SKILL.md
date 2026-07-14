---
name: fabrico-implement-pipeline
description: "Create or modify CI/CD pipelines with deployment protections and secure authentication."
---

> **Invocation portability:** `$fabrico-*` below means the discovered entry workflow. Use the unqualified name for repository or filesystem installs and `$fabrico-collections:fabrico-*` for plugin installs.

## Input

Use the user’s current request as the workflow input. Expected context: `[pipeline task or Jira ID]`.

If a named custom agent is unavailable, as in a skills-only plugin installation, perform that delegated step in
the current thread with the referenced skills and the same safety and verification gates.

# CI/CD Pipeline Implementation Workflow
This workflow creates or modifies CI/CD pipelines with proper deployment stages, environment protection, and secure authentication. It implements pipelines that follow established patterns for the project's platform (GitHub Actions, GitLab CI, Bitbucket Pipelines) with optimized caching and parallelization.

The workflow configures OIDC authentication for cloud providers, sets up environment-specific secrets handling, and implements appropriate deployment strategies (rolling, blue-green, canary). Complex GitOps workflows and multi-environment promotion pipelines are escalated to the `fabrico-architect` subagent for design validation.

## Required Skills
Before starting, load and follow these skills:
- `fabrico-implementing-ci-cd` - for pipeline patterns, deployment strategies, and GitOps workflows
- `fabrico-managing-secrets` - for OIDC authentication setup and secrets handling
- `fabrico-technical-context-discovering` - to establish project conventions and existing pipeline patterns

---

## 1. Context

Follow the `fabrico-technical-context-discovering` skill to identify existing CI/CD setup.

Additionally, always:
- **Read the "Technical Context" section from the plan file** (`*.plan.md`) if it exists — it contains project conventions and patterns already discovered during planning. Use it as your primary source and skip re-discovery for aspects already covered.
- Check root and nested `AGENTS.md` guidance only for aspects **not covered** by the plan's Technical Context
- Analyze existing pipeline configurations (GitHub Actions, GitLab CI, Bitbucket, etc.)
- Discover branching strategy and deployment targets

---

## 2. Implementation

Follow the `fabrico-implementing-ci-cd` skill for:
- Pipeline stages (lint, test, build, deploy)
- Deployment strategies (rolling, blue-green, canary)
- Caching and optimization

Follow the `fabrico-managing-secrets` skill for:
- OIDC authentication for cloud providers
- Secrets configuration in CI/CD platform
- Environment-specific variables

---

## 3. Architect Consultation

Request `fabrico-architect` consultation when:
- Designing new deployment strategies (blue-green, canary)
- Setting up multi-environment promotion pipelines
- Implementing complex GitOps workflows

Skip for: adding test stages, fixing pipeline bugs, updating versions, adding caching.

When already running inside `fabrico-devops-engineer`, return a focused architecture-decision request to the caller;
do not spawn a sibling or parent. Otherwise delegate to the architect when available, or perform the consultation in
the current thread with `fabrico-architecture-designing`.

---

## 4. Summary (required output)

```markdown
## CI/CD Pipeline Summary

### Current State
- [existing CI/CD configuration]

### Proposed Pipeline
- Platform: [GitHub Actions / GitLab CI / etc.]
- Stages: [list of stages]
- Deployment strategy: [rolling / blue-green / canary]

### Required Setup
| Secret/Variable | Description | Where to configure |
|-----------------|-------------|-------------------|

### Testing Instructions
- [how to validate the pipeline works]

### Files
- NEW/MODIFIED: [list of files created or modified]
```

---

## Scope

**Does NOT handle** (redirect to):
- Infrastructure provisioning → `$fabrico-implement-terraform`
- Kubernetes deployment configuration → `$fabrico-deploy-kubernetes`
- Monitoring and alerting → `$fabrico-implement-observability`

