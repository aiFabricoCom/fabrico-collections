---
name: fabrico-implement-e2e
description: "Map acceptance criteria to E2E scenarios, implement them, and report coverage."
---

> **Invocation portability:** `$fabrico-*` below means the discovered entry workflow. Use the unqualified name for repository or filesystem installs and `$fabrico-collections:fabrico-*` for plugin installs.

## Input

Use the user’s current request as the workflow input. Expected context: `[task, Jira ID, or path to plan/research file]`.

If a named custom agent is unavailable, as in a skills-only plugin installation, perform that delegated step in
the current thread with the referenced skills and the same review gates.

# E2E Test Workflow

**Non-interactive** - make reasonable decisions, document them.

## Required Skills

Before starting, load and follow these skills:
- `fabrico-task-analysing` - to determine the input source and gather task requirements
- `fabrico-technical-context-discovering` - to establish test conventions, existing patterns, and project configuration
- `fabrico-e2e-testing` - for Page Object patterns, test structure, mocking strategies, verification loop rules, error recovery, and CI readiness checklist

---

## 1. Context

Follow the `fabrico-task-analysing` skill's **Step 0 (Determine input source)** to identify whether context comes from research/plan files, a Jira ID, or directly from the prompt message.

Additionally, always:
- **Read the "Technical Context" section from the plan file** (`*.plan.md`) if it exists — it contains project conventions, test patterns, and commands already discovered during planning. Use it as your primary source and skip re-discovery for aspects already covered.
- Check `AGENTS.md` (root and any nested `AGENTS.md` files) only for aspects **not covered** by the plan's Technical Context
- Analyze `playwright.config.ts` + existing Page Objects
- Discover existing test patterns and locator strategies in the codebase

---

## 2. Planning

Map acceptance criteria to scenarios:

| Acceptance Criterion | Scenario Type | Test Name |
|---------------------|---------------|-----------|
| [from plan/prompt] | Happy/Error/Edge | `should [behavior] when [condition]` |

Checklist:
- [ ] Each criterion → at least one test
- [ ] API mocking needs documented
- [ ] Page Objects to create listed

---

## 3. Implementation & Verification

Follow the `fabrico-e2e-testing` skill for:
- Page Object patterns and test structure
- Mocking strategies (external APIs only)
- Verification loop rules and iteration limits
- Error recovery procedures
- CI readiness checklist

---

## 4. Summary (required output)

```markdown
## E2E Test Summary

### Coverage
| Criterion | Test | Status |
|-----------|------|--------|
| [from plan/prompt] | [file#test] | ✅/❌ |

Coverage: X/Y (Z%)

### Results
| File | Pass | Fail | Flaky | CI |
|------|------|------|-------|-----|
| login.spec.ts | 5 | 0 | 0 | ✅ |

### Issues
- 🐛 BUG: [desc] → test.fixme()
- ⚠️ FLAKY: [desc] → needs investigation

### Files
- NEW: tests/auth/login.spec.ts
- NEW: pages/login.page.ts
```

Update plan (if plan file exists): check acceptance criteria, add files to Change Log.

---

## 5. Code Review (automatic)

After completing E2E test implementation, always request an independent `fabrico-code-reviewer` pass against test
quality standards. When this workflow is running inside `fabrico-e2e-engineer`, return the review request and evidence
to the caller; do not spawn a sibling or parent. The caller owns that delegation. In a user-facing thread, spawn the
reviewer when available; otherwise perform a clearly labeled same-thread review. Update the plan changelog with the
review result.

