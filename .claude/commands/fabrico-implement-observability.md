---
description: "Implement comprehensive observability covering metrics, logs, traces, and alerting — following RED/USE methodology, SLOs/SLIs with error budgets, and actionable alerts linked to runbooks."
argument-hint: "[task or Jira ID]"
---

# Observability Implementation Workflow

The request: $ARGUMENTS

This command implements comprehensive observability solutions covering metrics, logs, traces, and alerting. It establishes monitoring infrastructure that enables teams to understand system behavior, detect issues proactively, and maintain service level objectives through well-designed dashboards and alert rules.

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
- Check `CLAUDE.md` memory (root, nested per-directory, or `@import` references) only for aspects **not covered** by the plan's Technical Context
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

Delegate to the `fabrico-architect` subagent via the **Task** tool (subagent_type: `fabrico-architect`) when:
- Selecting observability stack for greenfield projects
- Designing cross-service tracing architecture
- Implementing centralized logging with compliance requirements

Skip for: adding alerts, creating dashboards, configuring log retention, adding metrics to existing stack.

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
- Infrastructure provisioning → `/fabrico-implement-terraform` (`.claude/commands/fabrico-implement-terraform.md`)
- CI/CD pipelines → `/fabrico-implement-pipeline` (`.claude/commands/fabrico-implement-pipeline.md`)

<!-- FABRICO_COLLECTIONS:command:fabrico-implement-observability:v1 -->
