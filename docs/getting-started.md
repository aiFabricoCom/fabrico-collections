# Getting started

## Requirements

- [OpenAI Codex](https://developers.openai.com/codex/) — CLI, IDE extension, cloud, or desktop app.
- For MCP-backed workflows: `npx` (Node) and `uvx` (Python/`uv`) on `PATH`, plus credentials for the servers you
  enable (Figma, Atlassian/Jira, AWS, GCP, and others).

## Install

Fabrico uses the Codex-native customization locations:

- repository skills: `.agents/skills/<name>/SKILL.md`
- repository custom agents: `.codex/agents/<name>.toml`
- persistent project guidance: `AGENTS.md`
- project configuration and MCP servers: `.codex/config.toml`

### Quick install

Install globally so the `$fabrico-*` skills and agents are available in every project:

```bash
curl -fsSL https://raw.githubusercontent.com/aiFabricoCom/fabrico-collections/main/install.sh | bash
```

For a project-scoped installation, run:

```bash
curl -fsSL https://raw.githubusercontent.com/aiFabricoCom/fabrico-collections/main/install.sh \
  | bash -s -- --project /path/to/your-project --mcp
```

The installer owns and replaces the complete `fabrico-*` namespace in the selected skills and agent directories. It
does not rewrite an existing config for agent settings or project MCP; global `--mcp` adds only missing entries via
`codex mcp`. Review the durable source URL it reports before merging project settings manually. Existing configs
should set `agents.max_threads = 6` and `agents.max_depth = 2` for Fabrico's bounded orchestrator-to-worker
delegation.

To uninstall skills and agents, repeat the selected scope with `--uninstall`. Add `--mcp` when you also want to
remove tracked global MCP entries and any unchanged config created by the installer, including an agent-only config
from a normal install. Fabrico tracks only entries it created: an existing or later modified global MCP entry is
preserved, and a global or project `.codex/config.toml` is removed only when Fabrico created it and it is still
unchanged. Project ownership evidence lives in user-level Codex state, outside the project. Global Codex paths honor
`CODEX_HOME`; reuse the generated uninstall command so a custom location is preserved.

```bash
# Global installation, including unchanged MCP entries created by Fabrico
curl -fsSL https://raw.githubusercontent.com/aiFabricoCom/fabrico-collections/main/install.sh \
  | bash -s -- --uninstall --mcp

# Project installation, including an unchanged config created by Fabrico
curl -fsSL https://raw.githubusercontent.com/aiFabricoCom/fabrico-collections/main/install.sh \
  | bash -s -- --project /path/to/your-project --uninstall --mcp
```

### Use this repository directly

Codex discovers this repository's `.agents/skills`, `.codex/agents`, `AGENTS.md`, and trusted project
`.codex/config.toml`. Launch Codex from the repository root and invoke an entry workflow skill.

### Manual project install

```bash
mkdir -p /path/to/your-project/.agents/skills /path/to/your-project/.codex/agents
cp -R /path/to/fabrico-collections/.agents/skills/. /path/to/your-project/.agents/skills/
cp -R /path/to/fabrico-collections/.codex/agents/. /path/to/your-project/.codex/agents/
```

Merge the relevant guidance from the collection's `AGENTS.md` into the target project's `AGENTS.md`. Add the
delegation limits below to the target `.codex/config.toml`. If you need bundled MCP definitions, merge only the
relevant server tables from Fabrico's config rather than overwriting an existing project config.

```toml
[agents]
max_threads = 6
max_depth = 2
```

### Manual global install

```bash
mkdir -p ~/.agents/skills ~/.codex/agents
cp -R /path/to/fabrico-collections/.agents/skills/. ~/.agents/skills/
cp -R /path/to/fabrico-collections/.codex/agents/. ~/.codex/agents/
```

Global guidance, agents, and config belong under `$CODEX_HOME` when set, otherwise `~/.codex`. Ensure its
`config.toml` contains the same `[agents]` limits shown above. Register global MCP servers with `codex mcp add`
instead of copying a project config wholesale. Skills remain in `~/.agents/skills`.

### Plugin-only install

Plugin skills use Codex's component namespace. Invoke them as
`$fabrico-collections:fabrico-<workflow>`—for example,
`$fabrico-collections:fabrico-review`. The direct repository, project, and global filesystem installs documented
above use the shorter `$fabrico-<workflow>` form and also include the custom-agent profiles.

## MCP setup

The project `.codex/config.toml` contains `[mcp_servers.*]` entries used by Fabrico workflows. The quick installer's
`--mcp` option installs the complete bundle; for selective setup, omit it and merge/register only the servers you
need:

| Server | Used for |
| --- | --- |
| `context7` | Current library documentation matched to dependency versions |
| `atlassian` | Read Jira issues by ID |
| `figma` | Extract design context for UI work |
| `playwright` | Drive Chrome for UI verification and authorized legacy-app inspection |
| `sequential-thinking` | Structured reasoning for complex tasks |
| `pdf-reader` | Read PDF workshop materials |
| `aws-api`, `aws-documentation` | AWS audits and cost analysis |
| `gcp-gcloud`, `gcp-observability`, `gcp-storage` | GCP audits and cost analysis |

Several servers require credentials or local tooling. Configure them before invoking a dependent workflow and
review every external action before approval.

## Launch Codex with appropriate permissions

The normal local-development preset allows workspace edits while still asking before riskier operations:

```bash
codex --sandbox workspace-write --ask-for-approval on-request
```

Keep the project in git so changes stay reviewable and reversible. For a truly unattended run, Codex also supports
`--dangerously-bypass-approvals-and-sandbox`, but use it only inside an externally isolated, disposable
environment: it removes both approvals and sandbox protections.

Then type a workflow in the Codex composer, for example:

```text
$fabrico-implement Add a POST /api/users endpoint with validation and tests
```

## Next

- [Workflows](workflows.md) — the day-to-day golden path.
- [Autopilot](autopilot.md) — spec → software.
- [Legacy modernization](legacy-modernization.md) — old app → modern rebuild.
