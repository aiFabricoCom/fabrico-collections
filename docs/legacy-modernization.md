# Legacy modernization

Fabrico can derive a platform-agnostic specification from an authorized running web app and rebuild it for a
modern web or mobile target. The workflow drives Chrome through the Playwright MCP server; no browser extension is
required.

## Entry workflow skills

```text
$fabrico-reverse-spec <url> [login/scope notes]
$fabrico-modernize <url | SPEC.md> [web | ios | react-native]
```

- **`$fabrico-reverse-spec`** crawls routes, captures screens and accessibility state, infers roles, flows, data,
  and integrations, then writes a platform-agnostic `SPEC.md` with acceptance criteria. It also produces
  `legacy-inventory.md`, `legacy-capture/`, and `reverse-spec-notes.md`, including source mapping from old screens
  to stories.
- **`$fabrico-modernize`** accepts a URL or an existing `SPEC.md`, loads the `fabrico-planning-migration`
  supporting skill, produces a migration and parity plan, pauses for review, and rebuilds under the
  [autopilot](autopilot.md) contract. Outputs include `MIGRATION-PLAN.md`, `BUILD-SUMMARY.md`, and a parity report.

The same `SPEC.md` can target modern web, native iOS, or React Native; choose the target at build time.

## Targets

| Target | Best when | Default stack |
| --- | --- | --- |
| `web` | browser reach, SEO, responsive web, fastest path | Next.js + TypeScript + Tailwind, Prisma + Postgres, Auth.js |
| `ios` | iOS-only product with deep platform integration | Swift + SwiftUI, SwiftData, URLSession |
| `react-native` | one mobile codebase for iOS and Android | Expo + React Native + TypeScript, React Navigation |

> The workflow can generate a buildable SwiftUI project and tests, but device distribution still requires Xcode
> and the appropriate Apple developer access.

## Capturing the app with Playwright

The `fabrico-reverse-engineering-spec` supporting skill drives the Playwright MCP server. Its detailed capture
recipe lives at
`.agents/skills/fabrico-reverse-engineering-spec/references/playwright-capture.md`.

Configure Playwright in the project `.codex/config.toml`. Check
`npx @playwright/mcp@latest --help` first because supported flags can change between versions.

### Persistent profile

Run headed Chrome with a persistent profile when you want an authenticated session to survive across runs:

```toml
[mcp_servers.playwright]
command = "npx"
args = [
  "@playwright/mcp@latest",
  "--browser", "chrome",
  "--user-data-dir", "/Users/<you>/.fabrico/chrome-profile",
  "--viewport-size", "1280,800",
]
```

Log in once through the visible browser. Later authorized runs reuse the same cookies and local storage.

### Attach to an existing Chrome session

For SSO or MFA, launch a separate Chrome debugging profile and log in manually:

```bash
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-debug
```

Then point the Playwright MCP server at that session:

```toml
[mcp_servers.playwright]
command = "npx"
args = [
  "@playwright/mcp@latest",
  "--cdp-endpoint", "http://localhost:9222",
]
```

Playwright controls the session you authenticated. A lighter alternative is a reusable `--storage-state` file.
Keep the browser headed while validating login and navigation behavior.

> **Authorization and safety:** inspect only applications you own or are explicitly authorized to analyze. Use a
> staging environment where possible. Treat the live app as read-only: do not delete data, make payments, send
> real messages, or attempt to bypass access controls.

## End-to-end example

```text
# Inspect first and review the generated spec.
$fabrico-reverse-spec https://my-old-app.example uses email-and-password login

# After reviewing SPEC.md and reverse-spec-notes.md, rebuild for mobile.
$fabrico-modernize SPEC.md react-native
```
