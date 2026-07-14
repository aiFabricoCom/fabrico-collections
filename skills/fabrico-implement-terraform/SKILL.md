---
name: fabrico-implement-terraform
description: "Create or modify Terraform with IaC safety guardrails and cost estimation."
---

> **Invocation portability:** `$fabrico-*` below means the discovered entry workflow. Use the unqualified name for repository or filesystem installs and `$fabrico-collections:fabrico-*` for plugin installs.

## Input

Use the user’s current request as the workflow input. Expected context: `[infrastructure task or Jira ID]`.

If a named custom agent is unavailable, as in a skills-only plugin installation, perform that delegated step in
the current thread with the referenced skills and the same safety and verification gates.

# Terraform Implementation Workflow
This workflow creates or modifies Terraform modules and provisions cloud infrastructure following established IaC patterns and safety guardrails. It ensures consistent resource configuration with proper naming, tagging, state management, and cost estimation before any infrastructure changes are applied.

The workflow respects existing project conventions, validates all changes through `terraform plan`, and automatically escalates architectural decisions (VPC design, service selection, multi-region) to the `fabrico-architect` subagent. Every implementation includes cost impact analysis and step-by-step apply instructions.

## Required Skills
Before starting, load and follow these skills:
- `fabrico-implementing-terraform-modules` - for module patterns, state management, and safe infrastructure changes
- `fabrico-technical-context-discovering` - to establish project conventions and existing Terraform patterns

---

## 1. Context

Follow the `fabrico-technical-context-discovering` skill to identify existing Terraform setup.

Additionally, always:
- **Read the "Technical Context" section from the plan file** (`*.plan.md`) if it exists — it contains project conventions and patterns already discovered during planning. Use it as your primary source and skip re-discovery for aspects already covered.
- Check root and nested `AGENTS.md` guidance only for aspects **not covered** by the plan's Technical Context
- Analyze existing Terraform modules and state configuration
- Discover environment organization (workspaces, Terragrunt)

---

## 2. Implementation

Follow the `fabrico-implementing-terraform-modules` skill for:
- Module structure and interfaces
- Resource configurations with proper naming and tagging
- Variable definitions with validation
- State backend configuration

**Guardrails:**
- Always run `terraform plan` before any apply
- Never suggest `terraform apply -auto-approve` for production
- Ensure remote state is configured before applying
- Flag resources with significant cost impact (>10% increase)

---

## 3. Architect Consultation

Request `fabrico-architect` consultation when:
- Designing new VPC/network topology
- Selecting between competing cloud services (ECS vs EKS, RDS vs Aurora)
- Implementing multi-region or disaster recovery architecture
- Making decisions with significant cost impact (>10% increase)

Skip for: adding resources to existing modules, updating versions, fixing bugs, adding tags.

When already running inside `fabrico-devops-engineer`, return a focused architecture-decision request to the caller;
do not spawn a sibling or parent. Otherwise delegate to the architect when available, or perform the consultation in
the current thread with `fabrico-architecture-designing`.

---

## 4. Summary (required output)

```markdown
## Terraform Implementation Summary

### Current State
- [existing IaC configuration]

### Proposed Configuration
- Provider: [AWS / Azure / GCP]
- Resources: [list of resources to create/modify]

### Variables
| Variable | Type | Required | Description |
|----------|------|----------|-------------|

### State Backend
- [remote state configuration]

### Cost Estimate
- [approximate monthly cost for new resources]

### Apply Instructions
1. `terraform init`
2. `terraform plan -out=tfplan`
3. Review plan output
4. `terraform apply tfplan`

### Files
- NEW/MODIFIED: [list of files created or modified]
```

---

## Scope

**Does NOT handle** (redirect to):
- CI/CD pipelines for Terraform → `$fabrico-implement-pipeline`
- Kubernetes workload configuration → `$fabrico-deploy-kubernetes`
- Monitoring infrastructure → `$fabrico-implement-observability`

