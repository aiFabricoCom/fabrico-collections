# Getting started

## Requirements

- [Claude Code](https://claude.com/claude-code) (CLI, desktop, web, or IDE extension).
- For MCP-backed commands: `npx` (Node) and `uvx` (Python/`uv`) on PATH, plus credentials for the servers you
  enable (Figma, Atlassian/Jira, AWS, GCP, etc.).

## Install

Claude Code discovers customizations from two places: the **project** (`.claude/` in the repo you open) and your
**user** config (`~/.claude/`). Pick the scope that fits.

### Use it in this repository

Claude Code automatically picks up `.claude/commands`, `.claude/agents`, `.claude/skills`, `CLAUDE.md`, and
`.mcp.json` when you run it here. Nothing to install — just open Claude Code and run a command.

### Use it in your own project

```bash
cp -R /path/to/fabrico-collections/.claude/commands  <your-project>/.claude/commands
cp -R /path/to/fabrico-collections/.claude/agents    <your-project>/.claude/agents
cp -R /path/to/fabrico-collections/.claude/skills     <your-project>/.claude/skills
cp    /path/to/fabrico-collections/.mcp.json         <your-project>/.mcp.json   # optional
```

### Install globally (recommended for solo use)

So `/fabrico-*` works in every project:

```bash
mkdir -p ~/.claude/commands ~/.claude/agents ~/.claude/skills
cp -R /path/to/fabrico-collections/.claude/commands/* ~/.claude/commands/
cp -R /path/to/fabrico-collections/.claude/agents/*   ~/.claude/agents/
cp -R /path/to/fabrico-collections/.claude/skills/*   ~/.claude/skills/
```

When you add new commands/skills later, re-copy just those files.

## MCP setup

`.mcp.json` declares the MCP servers the agents use. Copy it into your project, or register servers globally with
`claude mcp add`. Claude Code asks you to approve project MCP servers the first time you run it — enable only what
you need.

| Server | Used for |
| --- | --- |
| `context7` | Up-to-date library documentation (matches your dependency versions) |
| `atlassian` | Read Jira issues by ID |
| `figma` | Extract design specs for UI work |
| `playwright` | Drive Chrome to verify UI and to reverse-engineer legacy apps |
| `sequential-thinking` | Structured reasoning for complex tasks |
| `pdf-reader` | Read PDF workshop materials |
| `awslabs.aws-api-mcp-server`, `awslabs.aws-documentation-mcp-server` | AWS audits & cost analysis |
| `gcp-gcloud`, `gcp-observability`, `gcp-storage` | GCP audits & cost analysis |

Several servers need credentials or local tooling — set those up before running the commands that depend on them.

## For an autonomous, hands-off run

Start Claude Code in **auto-accept-edits** mode (press **Shift+Tab**) so it doesn't prompt for each file write, and
keep your work in **git** so every step is reversible. This matters most for [`/fabrico-autopilot`](autopilot.md)
and [`/fabrico-modernize`](legacy-modernization.md).

## Next

- [Workflows](workflows.md) — the day-to-day golden path.
- [Autopilot](autopilot.md) — spec → software.
- [Legacy modernization](legacy-modernization.md) — old app → modern rebuild.
