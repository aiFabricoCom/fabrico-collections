<!--
  Nested / Scoped Memory (CLAUDE.md)
  ==================================
  Scoped conventions for the directory subtree this file lives in.

  Place this file inside the target directory, e.g.:
    src/api/CLAUDE.md          → applies to everything under src/api/
    src/components/CLAUDE.md    → applies to everything under src/components/

  This is plain Markdown — no frontmatter, no applyTo glob.
  Scope is determined entirely by file LOCATION, not a pattern.

  Guidelines:
  - Each rule should be a single, clear statement
  - Include reasoning for non-obvious rules ("because...")
  - Show preferred and avoided patterns with code examples
  - Don't duplicate rules from the root CLAUDE.md
  - Don't duplicate what linters/formatters already enforce
  - For content shared with other memory files, use @import instead of copying
-->

# Conventions for this directory

<!-- Describe the conventions that apply to files in this subtree -->
<!-- If a rule targets a specific file type (e.g. *.test.ts), say so in prose —
     there is no glob targeting; location + clear wording does the scoping. -->

## Preferred patterns

<!-- Show concrete code examples of the RIGHT way -->

## Avoided patterns

<!-- Show concrete code examples of what to AVOID and why -->

<!--
  Optional: pull in shared rules with @import, e.g.:
  @../../docs/conventions.md
-->
