---
description: "Audit infrastructure for security gaps, cost waste, and best practices violations."
argument-hint: "[scope: AWS/Azure/GCP/Kubernetes/CI-CD] [focus: security/cost/best-practices/all]"
---

> **Delegate to the `fabrico-devops-engineer` subagent.** Launch it with the Task tool (subagent_type: `fabrico-devops-engineer`), passing the user's request below and any referenced context. Adopt its operating contract; do not do this work in the main thread when the subagent applies.

# Infrastructure Audit Workflow

The request: $ARGUMENTS

This command performs a comprehensive infrastructure audit to identify security vulnerabilities, cost optimization opportunities, and best practices violations across your cloud environment. It systematically examines IaC configurations, CI/CD pipelines, and cloud resources to produce an actionable audit report with prioritized findings.

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
- Check `CLAUDE.md` (root and nested per-directory memory files) → project-specific conventions
- Analyze existing IaC files and CI/CD configurations
- Discover existing infrastructure patterns in the codebase

---

## 2. Assessment

Follow the relevant skills to audit each focus area:
- **Security**: IAM, encryption, network exposure, compliance
- **Cost**: Follow `fabrico-optimizing-cloud-cost` skill for unused resources, rightsizing, reservations
- **Secrets**: Follow `fabrico-managing-secrets` skill for exposure risks
- **Best practices**: Tagging, IaC coverage, documentation

Classify findings by severity:
- **Critical**: Immediate security risk or compliance violation
- **High**: Significant cost waste or security gap
- **Medium**: Best practice deviation with moderate impact
- **Low**: Minor improvements or nice-to-haves

---

## 3. Architect Consultation

Spawn the `fabrico-architect` subagent via the Task tool (subagent_type: `fabrico-architect`) when findings require architectural changes:
- Security findings requiring network redesign
- Cost findings requiring infrastructure re-architecture
- Compliance gaps requiring structural changes

Skip for: adding tags, updating configurations, simple fixes.

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
1. [Critical] Description → `/fabrico-implement-terraform`
2. [High] Description → `/fabrico-deploy-kubernetes`
3. [Medium] Description → `/fabrico-implement-observability`
```

---

## Scope

**Does NOT handle** (redirect to):
- Implementing fixes → `/fabrico-implement-terraform`, `/fabrico-deploy-kubernetes`, `/fabrico-implement-pipeline`, `/fabrico-implement-observability`
- Application code security → coordinate with software engineer

<!-- FABRICO_COLLECTIONS:command:fabrico-audit-infrastructure:v1 -->
