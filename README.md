# Fabrico Collections

<p align="center">
  <img src="assets/hero.svg" alt="Fabrico Collections — an opinionated Codex setup" width="100%">
</p>

Opinionated **OpenAI Codex** setup for product discovery, implementation, review, autonomous builds, and legacy
modernization.

Fabrico combines **31 entry workflow skills**, **34 supporting skills**, and **21 custom agents** into a reusable
software-delivery system. It can research, plan, build, test, and review software while keeping meaningful
decisions visible to you.

> See [`AGENTS.md`](AGENTS.md) for repository conventions and orchestration rules, and
> [`docs/`](docs/README.md) for the full guide.

## Install in one command

```bash
curl -fsSL https://raw.githubusercontent.com/aiFabricoCom/fabrico-collections/main/install.sh | bash
```

The default installation makes `$fabrico-*` workflows and `fabrico-*` custom agents available across projects.
See [Installation](#installation) for project scope, MCP configuration, uninstall, and manual alternatives.

## What matters most

You do not need to learn every artifact first. Start with:

- `$fabrico-analyze-materials` — turn workshop inputs into structured, Jira-ready tasks
- `$fabrico-implement` — research, plan, implement, verify, and review a task end to end
- `$fabrico-review` — run a separate structured code review

The primary roles behind these workflows are:

- `fabrico-business-analyst` — discovery and backlog shaping
- `fabrico-engineering-manager` — implementation orchestration
- `fabrico-code-reviewer` — review and risk detection
- `fabrico-customization-orchestrator` — Codex customization design and review

Everything else is supporting structure loaded when the workflow needs it.

## Requirements

- [OpenAI Codex](https://developers.openai.com/codex/) — CLI, IDE extension, cloud, or desktop app
- this repository available on disk, or use the installer above
- for MCP-backed workflows: `npx` and `uvx` on `PATH` plus credentials for any enabled Figma, Jira, AWS, GCP,
  or other external services

## Installation

### Quick install

Install globally:

```bash
curl -fsSL https://raw.githubusercontent.com/aiFabricoCom/fabrico-collections/main/install.sh | bash
```

Install into one project and include the bundled MCP configuration:

```bash
curl -fsSL https://raw.githubusercontent.com/aiFabricoCom/fabrico-collections/main/install.sh \
  | bash -s -- --project /path/to/your-project --mcp
```

Uninstall Fabrico artifacts. The installer owns the `fabrico-*` namespace in the selected skills and agent
directories, so uninstall removes every artifact under that prefix:

```bash
curl -fsSL https://raw.githubusercontent.com/aiFabricoCom/fabrico-collections/main/install.sh \
  | bash -s -- --uninstall
```

Add `--mcp` to the same uninstall scope when you also want to remove tracked global MCP entries and any unchanged
global/project config that this installer created (including an agent-only config from a normal install):

```bash
# Global MCP entries created by Fabrico
curl -fsSL https://raw.githubusercontent.com/aiFabricoCom/fabrico-collections/main/install.sh \
  | bash -s -- --uninstall --mcp

# An unchanged project config created by Fabrico
curl -fsSL https://raw.githubusercontent.com/aiFabricoCom/fabrico-collections/main/install.sh \
  | bash -s -- --project /path/to/your-project --uninstall --mcp
```

| Option | Effect |
| --- | --- |
| none | Install globally into Codex user locations |
| `--global` | Explicitly select the global installation |
| `--project [DIR]` | Install into a project's `.agents/skills` and `.codex/agents` |
| `--mcp` | Register the complete missing global MCP bundle, or install the complete project config only when none exists |
| `--ref REF` | Install a branch, tag, or commit instead of `main` |
| `--uninstall` | Remove Fabrico skills and agents; combine with `--mcp` for tracked MCP entries and installer-owned config |
| `--help` | Show installer usage |

The installer never rewrites an existing config for agent settings or project MCP; global `--mcp` uses `codex mcp`
to add only missing server entries and preserves existing ones. When a project merge is needed, it prints a durable
source URL. A pre-existing config should set `agents.max_threads = 6` and
`agents.max_depth = 2`, or the installer reports the missing/undersized settings without rewriting the file. It
records ownership only for MCP entries or a global/project config that it creates itself. `--uninstall --mcp`
removes those records only while they remain unchanged; foreign or user-modified configuration is left intact.
Global agent/config locations honor `CODEX_HOME` when it is set, while global skills remain in `~/.agents/skills`.
Project-config ownership evidence is kept in that user-level Codex state directory rather than inside the project.
The script requires `curl` or `wget` and `tar`; it does not require git. Source:
[`install.sh`](install.sh).

### Use this repository directly

Codex discovers repository skills from `.agents/skills`, custom agents from `.codex/agents`, persistent guidance
from `AGENTS.md`, and trusted project configuration from `.codex/config.toml`.

Launch Codex from the repository root:

```bash
codex --sandbox workspace-write --ask-for-approval on-request
```

Then invoke a workflow in the Codex composer.

### Manual project install

```bash
mkdir -p /path/to/your-project/.agents/skills /path/to/your-project/.codex/agents
cp -R /path/to/fabrico-collections/.agents/skills/. /path/to/your-project/.agents/skills/
cp -R /path/to/fabrico-collections/.codex/agents/. /path/to/your-project/.codex/agents/
```

Merge relevant rules from Fabrico's `AGENTS.md` into the target repository's guidance. Also merge the following
delegation limits into the project's `.codex/config.toml`; Fabrico's root config adds optional MCP servers as well.
Do not overwrite an existing project config.

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

Personal cross-project guidance and agent configuration belong under `$CODEX_HOME` when set, otherwise `~/.codex`.
Ensure its `config.toml` contains the same `[agents]` limits shown above, and add global MCP servers with
`codex mcp add`.

### Plugin packaging

The repository also includes `.codex-plugin/plugin.json`, which packages the skills and optional MCP servers for
Codex plugin tooling. Codex plugins do not currently bundle project custom-agent TOML files, so use `install.sh`
when you want the complete Fabrico agent orchestration setup. Plugin component names are namespace-qualified: use
`$fabrico-collections:fabrico-implement` in a plugin-only installation, while repository and filesystem installs use
`$fabrico-implement`.

## First workflows to try

Type these into the Codex composer:

- `$fabrico-create-spec <product idea>` — one-line idea → complete `SPEC.md`
- `$fabrico-autopilot SPEC.md` — complete spec → working software
- `$fabrico-finish-project /path/to/project` — existing partial project → verified completion
- `$fabrico-improve-ui /path/to/project [web|ios|android]` — UI audit → improvements → verified implementation
- `$fabrico-reverse-spec <url>` — authorized running app → platform-agnostic `SPEC.md`
- `$fabrico-modernize <url|SPEC.md> [web|ios|react-native]` — spec → migration plan → rebuild
- `$fabrico-implement <task or Jira ID>`
- `$fabrico-review <task or Jira ID>`
- `$fabrico-review-ui <Figma URL and running app URL>`
- `$fabrico-analyze-materials <transcript, notes, links, or workshop assets>`

To extend Fabrico itself:

- `$fabrico-create-custom-agent`
- `$fabrico-create-custom-skill`
- `$fabrico-create-workflow` — creates a reusable entry workflow skill
- `$fabrico-create-custom-instructions`

## Connect MCP

The repository `.codex/config.toml` contains optional `[mcp_servers.*]` definitions. The most useful are:

- **context7** — current library documentation matched to dependency versions
- **atlassian** — Jira task context
- **figma** and **playwright** — design extraction, UI verification, and authorized legacy-app inspection
- **AWS and GCP servers** — infrastructure audits and cost analysis

The quick installer's `--mcp` option installs the complete bundle. For a selective setup, omit `--mcp` and manually
merge/register only the servers you need. Several servers require local executables, credentials, or a browser
session. Review tool requests and external actions before granting access.

## The golden path

Fabrico persists context between phases in reviewable intermediate files such as `*.research.md` and `*.plan.md`:

```text
$fabrico-analyze-materials → workshop inputs / notes / Figma → epics + user stories
        ↓
$fabrico-implement <task or Jira ID>
        ↓  fabrico-engineering-manager coordinates:
   research → plan → [you confirm] → implementation → UI verification → code review
        ↓
$fabrico-review <task> → separate structured review
```

Most of the time `$fabrico-implement` is enough. It selects a Quick or Full flow and delegates bounded work to the
architect, engineers, UI reviewer, and code reviewer.

### Autopilot — complete spec → working software

<p align="center">
  <img src="assets/demo-autopilot.svg" alt="$fabrico-autopilot building software from SPEC.md" width="90%">
</p>

For a hands-off build:

1. Generate `SPEC.md` with `$fabrico-create-spec <idea>`, or copy [`SPEC.template.md`](SPEC.template.md).
2. Review the scope, acceptance criteria, credentials, external effects, and autonomy boundaries.
3. Invoke `$fabrico-autopilot SPEC.md`.

Autopilot runs backlog → architecture → plan review → implementation → tests → code review →
`BUILD-SUMMARY.md`. It records material assumptions in `ASSUMPTIONS.md` and stops for missing credentials,
contradictory requirements, spending, deployments, destructive operations, or outbound actions requiring new
authority.

The normal local preset is:

```bash
codex --sandbox workspace-write --ask-for-approval on-request
```

Codex also supports `--dangerously-bypass-approvals-and-sandbox` for externally isolated automation environments.
It removes both approval prompts and sandbox protections, so do not use it on an ordinary workstation.

### Modernize or port a legacy app

<p align="center">
  <img src="assets/demo-modernize.svg" alt="$fabrico-reverse-spec and $fabrico-modernize rebuilding a legacy app" width="90%">
</p>

```text
$fabrico-reverse-spec https://your-old-app.example
$fabrico-modernize SPEC.md react-native
```

`$fabrico-reverse-spec` captures routes, screens, accessibility state, roles, flows, and integrations through the
Playwright MCP server, then writes a platform-agnostic `SPEC.md` with source mapping. `$fabrico-modernize` creates
a feature-parity migration plan and rebuilds for web, iOS, or React Native.

Inspect only applications you own or are explicitly authorized to analyze. Prefer staging, keep live inspection
read-only, and never use the workflow to bypass access controls.

## Getting the best results

1. **Give concrete context.** Include Jira IDs, Figma links, relevant paths, constraints, and observable acceptance
   criteria.
2. **Keep intermediate files.** Research, plans, assumptions, and summaries form the workflow's reviewable record.
3. **Review meaningful gates.** Plan confirmation and UI verification are deliberate quality controls.
4. **Let the manager delegate.** The orchestration agent coordinates specialists instead of implementing every
   concern itself.
5. **Connect only the MCP servers you need.**
6. **Start with a small task** before launching a large autonomous build.

Example:

```text
$fabrico-implement Add a POST /api/users endpoint with email validation and tests
```

## From prototype to production

Fabrico can produce a working, tested build, but production readiness also requires security, reliability,
observability, operations, performance, and long-term ownership.

> **Recommended — [Ship After AI](https://shipafterai.com/)**
> *Turn your AI-built app into production-grade software.* They audit AI-generated codebases, harden them for real
> users, and can provide ongoing engineering ownership.

See [Going to production](docs/going-to-production.md).

## Learn more

- [Full documentation](docs/README.md)
- [Entry workflow skills](docs/workflow-skills.md)
- [Custom agents](docs/agents.md)
- [Supporting skills](docs/skills.md)
- [Repository guidance](AGENTS.md)
- [Codex project configuration](.codex/config.toml)

## Acknowledgements

Fabrico Collections is derived from the *copilot-collections* project by The Software House, used under the MIT
License.

## License

MIT — see [`LICENSE`](LICENSE).
