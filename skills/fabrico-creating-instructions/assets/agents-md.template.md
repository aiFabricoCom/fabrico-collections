<!-- Repository-root AGENTS.md template. Remove unused sections and every comment. -->

# Repository guidance

## Scope

- <What this repository contains and which directories are authoritative.>
- <Important ownership or architecture boundary.>

## Setup

- `<exact setup command>` — <when to run it and prerequisites>
- <Required runtime, package manager, or local service versions.>

## Repository map

- `<path>/` — <purpose and ownership>
- `<path>/` — <purpose and ownership>
- Generated files: `<path or pattern>`; regenerate with `<command>` and do not edit manually.

## Working conventions

- <Project-specific rule not enforced mechanically.>
- <Dependency, migration, compatibility, or generated-code policy.>
- Before changing `<area>`, inspect `<authoritative source>`.

## Verification

- Fast check: `<command>`
- Targeted tests: `<command and selection syntax>`
- Full test suite: `<command>`
- Lint and format: `<commands>`
- Build or type check: `<command>`

Run the smallest relevant checks during iteration and the complete required gate before declaring work finished.

## Review expectations

- Prioritize <correctness, compatibility, security, migrations, tests, or other repository-specific risks>.
- Include changed behavior, verification evidence, and unresolved limitations in the handoff.

## Safety boundaries

- Do not <destructive or externally visible action> without explicit authority.
- Never commit secrets; use `<example or documented mechanism>`.
- Preserve unrelated work in a dirty worktree.

## Scoped guidance

- Sessions launched under `<subdirectory>/` also load `<subdirectory>/AGENTS.md`.
- <Explain any intentional same-level AGENTS.override.md usage.>
