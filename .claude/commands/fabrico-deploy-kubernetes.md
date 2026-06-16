---
description: "Creates Kubernetes deployments, Helm charts, and workload configurations following production-ready patterns for high availability, resource management, and secrets handling. Ensures consistent deployment practices across environments with proper health probes, scaling policies, and security configurations."
argument-hint: "[service or workload to deploy]"
---

The request: $ARGUMENTS

# Kubernetes Deployment Workflow

This command creates Kubernetes deployments, Helm charts, and workload configurations following production-ready patterns for high availability, resource management, and secrets handling. It ensures consistent deployment practices across environments with proper health probes, scaling policies, and security configurations.

The workflow matches existing project conventions (raw manifests, Helm, or Kustomize), configures appropriate QoS classes and resource limits, and validates all manifests before deployment. Architectural decisions involving service mesh, multi-cluster, or microservices topology are escalated to the architect subagent.

## Required Skills
Before starting, load and follow these skills:
- `fabrico-implementing-kubernetes` - for deployment patterns, Helm charts, resource configuration, and high availability settings
- `fabrico-managing-secrets` - for Kubernetes secrets management (Secrets, external-secrets, sealed-secrets)
- `fabrico-technical-context-discovering` - to establish project conventions and existing Kubernetes patterns

---

## 1. Context

Follow the `fabrico-technical-context-discovering` skill to identify existing Kubernetes setup.

Additionally, always:
- Check `CLAUDE.md` memory files (root and nested per directory) → project-specific conventions
- Analyze existing Kubernetes manifests, Helm charts, or Kustomize overlays
- Discover namespace organization and resource patterns

---

## 2. Implementation

Follow the `fabrico-implementing-kubernetes` skill for:
- Deployment/StatefulSet configuration
- Service and Ingress setup
- Resource requests/limits and QoS classes
- Health probes (liveness, readiness, startup)
- HPA, PDB, pod anti-affinity, topology spread

Follow the `fabrico-managing-secrets` skill for:
- Kubernetes Secrets or external secrets management
- Secret injection configuration

---

## 3. Architect Consultation

Spawn the `fabrico-architect` subagent via the Task tool (subagent_type: `fabrico-architect`) when:
- Designing new service architecture or microservices topology
- Implementing service mesh (Istio, Linkerd)
- Setting up multi-cluster or multi-region deployments

Skip for: HPA/PDB configuration, probes, resource limits, manifest fixes.

---

## 4. Summary (required output)

```markdown
## Kubernetes Deployment Summary

### Current State
- [existing Kubernetes configuration]

### Proposed Configuration
- Deployment method: [raw manifests / Helm / Kustomize]
- Namespace: [target namespace]
- Replicas: [count] with HPA [min-max]

### Prerequisites
| Resource | Description |
|----------|-------------|
| [namespace/secret/etc.] | [what must exist before deployment] |

### Deployment Instructions
1. [step-by-step instructions to apply]

### Verification Steps
1. [how to confirm successful deployment]

### Files
- NEW/MODIFIED: [list of files created or modified]
```

---

## Scope

**Does NOT handle** (redirect to):
- Cluster provisioning → `/fabrico-implement-terraform`
- CI/CD pipeline for deployment → `/fabrico-implement-pipeline`
- Monitoring and alerting → `/fabrico-implement-observability`

<!-- FABRICO_COLLECTIONS:command:fabrico-deploy-kubernetes:v1 -->
