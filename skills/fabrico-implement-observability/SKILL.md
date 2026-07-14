---
name: fabrico-implement-observability
description: "Implement metrics, logs, traces, and alerting."
---

> **Invocation portability:** `$fabrico-*` below means the discovered entry workflow. Use the unqualified name for repository or filesystem installs and `$fabrico-collections:fabrico-*` for plugin installs.

## Input

Use the user’s current request as the workflow input. Expected context: `[task or Jira ID]`.

If a named custom agent is unavailable, as in a skills-only plugin installation, perform that delegated step in
the current thread with the referenced skills and the same safety and verification gates.

# Observability Implementation Workflow
This workflow implements comprehensive observability solutions covering metrics, logs, traces, and alerting. It establishes monitoring infrastructure that enables teams to understand system behavior, detect issues proactively, and maintain service level objectives through well-designed dashboards and alert rules.

The workflow follows RED/USE methodology for metrics collection, configures appropriate SLOs/SLIs with error budgets, and creates actionable alerts linked to runbooks. Decisions about new observability stacks, cross-service tracing architecture, or compliance-sensitive logging are escalated to the `fabrico-architect` subagent.

## Required Skills
Before starting, load and follow these skills:
- `fabrico-implementing-observability` - for metrics, logs, traces, alerting patterns, SLO definitions, and dashboard design
- `fabrico-technical-context-discovering` - to establish project conventions and existing monitoring patterns

---

## 1. Context

Follow the `fabrico-technical-context-discovering` skill to identify existing observability setup.

Additionally, always:
- **Read the "Technical Context" section from the plan file** (`*.plan.md`) if it exists — it contains project conventions and patterns already discovered during planning. Use it as your primary source and skip re-discovery for aspects already covered.
- Check the applicable root or nested `AGENTS.md`/`AGENTS.override.md` guidance only for aspects **not covered** by the plan's Technical Context
- Analyze existing monitoring configurations (Prometheus, Grafana, CloudWatch, etc.)
- Discover existing alerting rules and dashboards

---

## 2. Implementation

Follow the `fabrico-implementing-observability` skill for:
- Metrics collection configuration
- Log aggregation setup
- Distributed tracing instrumentation
- SLO/SLI definitions with error budgets
- Alert rules with runbooks
- Dashboard design

---

## 3. Architect Consultation

Request `fabrico-architect` consultation when:
- Selecting observability stack for greenfield projects
- Designing cross-service tracing architecture
- Implementing centralized logging with compliance requirements

Skip for: adding alerts, creating dashboards, configuring log retention, adding metrics to existing stack.

When already running inside `fabrico-devops-engineer`, return a focused architecture-decision request to the caller;
do not spawn a sibling or parent. Otherwise delegate to the architect when available, or perform the consultation in
the current thread with `fabrico-architecture-designing`.

---

## 4. Summary (required output)

```markdown
## Observability Implementation Summary

### Current State
- [existing observability infrastructure]

### Proposed Stack
- Metrics: [tool and configuration]
- Logs: [tool and configuration]
- Traces: [tool and configuration]

### SLO Definitions
| Service | SLI | Target | Error Budget |
|---------|-----|--------|--------------|

### Alert Rules
| Alert | Condition | Severity | Runbook |
|-------|-----------|----------|---------|

### Dashboards
- [list of dashboard definitions]

### Instrumentation Guide
- [what application teams need to add, if any]

### Files
- NEW/MODIFIED: [list of files created or modified]
```

---

## Scope

**Does NOT handle** (redirect to):
- Application code instrumentation → coordinate with the software engineer (the `fabrico-software-engineer` subagent)
- Infrastructure provisioning → `$fabrico-implement-terraform` (`.agents/skills/fabrico-implement-terraform/SKILL.md`)
- CI/CD pipelines → `$fabrico-implement-pipeline` (`.agents/skills/fabrico-implement-pipeline/SKILL.md`)

