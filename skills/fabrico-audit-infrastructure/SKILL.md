---
name: fabrico-audit-infrastructure
description: "Audit infrastructure for security gaps, waste, and best-practice violations."
---

> **Invocation portability:** `$fabrico-*` below means the discovered entry workflow. Use the unqualified name for repository or filesystem installs and `$fabrico-collections:fabrico-*` for plugin installs.

## Input

Use the user’s current request as the workflow input. Expected context: `[scope: AWS/Azure/GCP/Kubernetes/CI-CD] [focus: security/cost/best-practices/all]`.

> **Keep orchestration in the calling Codex thread.** After discovering the scope, split independent provider,
> focus-area, or resource-domain slices and spawn `fabrico-devops-engineer` specialists in parallel. The calling
> thread owns architecture escalations, merged prioritization, report synthesis, and the final response. If the
> agent profile is unavailable, as in a skills-only plugin installation, perform those slices in the current thread
> with the required skills and the same audit contract.

# Infrastructure Audit Workflow
This workflow performs a comprehensive infrastructure audit to identify security vulnerabilities, cost optimization opportunities, and best practices violations across your cloud environment. It systematically examines IaC configurations, CI/CD pipelines, and cloud resources to produce an actionable audit report with prioritized findings.

The audit covers three key dimensions: security (IAM, encryption, network exposure, secrets), cost (unused resources, rightsizing, reservations), and operational excellence (tagging, IaC coverage, documentation). Findings are classified by severity and linked to remediation commands for immediate action.

## Required Skills
Before starting, load and follow these skills:
- `fabrico-optimizing-cloud-cost` - for cost analysis patterns, rightsizing, and reservation recommendations
- `fabrico-managing-secrets` - for secrets management audit criteria and exposure risk assessment
- `fabrico-codebase-analysing` - to review IaC files, CI/CD configurations, and documentation coverage

---

## 1. Context

Determine audit scope (if not provided):
- **What to audit?** AWS, Azure, GCP, Kubernetes, CI/CD
- **Focus areas?** Security, cost, best practices, or all
- **Compliance requirements?** SOC2, HIPAA, PCI-DSS, or none

Additionally, always:
- Check root and nested `AGENTS.md` guidance → project-specific conventions
- Analyze existing IaC files and CI/CD configurations
- Discover existing infrastructure patterns in the codebase

---

## 2. Assessment

Partition the audit into independent work units. Prefer one unit per provider and focus area; for a single-provider,
single-focus audit, split a sufficiently broad scope by non-overlapping resource domains. From the calling Codex
thread, run at most five `fabrico-devops-engineer` specialists concurrently; if this caller itself has a parent,
reserve that thread and cap the batch at four. Batch any remaining work units after a worker returns. A truly
indivisible narrow audit may use one specialist.

Give every specialist its exact scope, relevant paths/accounts, read-only constraints, required evidence, and the
summary-table fields it must return. Each specialist must follow the relevant skills for its focus area and return
its findings to the calling orchestrator without spawning sibling, parent, or architect agents:
- **Security**: IAM, encryption, network exposure, compliance
- **Cost**: Follow `fabrico-optimizing-cloud-cost` skill for unused resources, rightsizing, reservations
- **Secrets**: Follow `fabrico-managing-secrets` skill for exposure risks
- **Best practices**: Tagging, IaC coverage, documentation

After all specialists return, the calling thread deduplicates cross-scope findings and assigns the final severity.

Classify findings by severity:
- **Critical**: Immediate security risk or compliance violation
- **High**: Significant cost waste or security gap
- **Medium**: Best practice deviation with moderate impact
- **Low**: Minor improvements or nice-to-haves

---

## 3. Architect Consultation

When a DevOps specialist returns an architecture escalation, the calling Codex thread — not that specialist —
spawns a `fabrico-architect` specialist. Run independent consultations in parallel when findings require architectural
changes in separate scopes, with at most five active from a user-facing caller or four when the caller itself has a
parent; batch additional consultations after one returns:
- Security findings requiring network redesign
- Cost findings requiring infrastructure re-architecture
- Compliance gaps requiring structural changes

Give the architect the finding evidence, current state, constraints, and the decision required. The architect returns
its recommendation to the calling thread and must not spawn a sibling or parent agent. Return the decision to the
relevant DevOps specialist only if more bounded analysis is required. Skip architect consultation for adding tags,
updating configurations, and other simple fixes.

---

## 4. Summary (required output)

```markdown
## Infrastructure Audit Summary

### Executive Summary
- Overall health: Critical / Warning / Good
- Findings: X Critical, Y High, Z Medium, W Low
- Top 3 priorities

### Security Findings
| Severity | Finding | Resource | Recommendation |
|----------|---------|----------|----------------|

### Cost Findings
| Severity | Finding | Monthly Impact | Recommendation |
|----------|---------|----------------|----------------|

### Best Practices Findings
| Severity | Finding | Area | Recommendation |
|----------|---------|------|----------------|

### Quick Wins
- [list immediate actions with high impact and low effort]

### Remediation Roadmap
1. [Critical] Description → `$fabrico-implement-terraform`
2. [High] Description → `$fabrico-deploy-kubernetes`
3. [Medium] Description → `$fabrico-implement-observability`
```

---

## Scope

**Does NOT handle** (redirect to):
- Implementing fixes → `$fabrico-implement-terraform`, `$fabrico-deploy-kubernetes`, `$fabrico-implement-pipeline`, `$fabrico-implement-observability`
- Application code security → coordinate with software engineer
