# Legacy modernization

Have an old web app you want rebuilt on a modern stack — or ported to mobile/iOS? The system reverse-engineers a
spec straight from the **running** app (driving a real Chrome via the **playwright** MCP — no browser extension
needed) and then rebuilds it on a target you choose.

## Commands

```text
/fabrico-reverse-spec <url> [login/scope notes]              # running app → platform-agnostic SPEC.md
/fabrico-modernize <url | SPEC.md> [web | ios | react-native]  # reverse-spec → migration plan → rebuild
```

- **`/fabrico-reverse-spec`** crawls the routes, captures every screen (screenshot + accessibility tree + DOM),
  infers the data model, roles, flows, and integrations, and writes user stories with acceptance criteria. Output:
  a **platform-agnostic** `SPEC.md` (it describes *behavior*, not pixels) plus `legacy-inventory.md`,
  `legacy-capture/` (evidence), and `reverse-spec-notes.md` (open questions). It includes a **Source mapping**
  appendix (old screen → story) so nothing is lost.
- **`/fabrico-modernize`** takes a URL (runs reverse-spec first) or an existing `SPEC.md`, plans the migration with
  the `fabrico-planning-migration` skill (target choice, feature-parity matrix, data/auth/UX migration, risks),
  pauses once for your review, then rebuilds autonomously using the [autopilot](autopilot.md) contract. Output:
  `MIGRATION-PLAN.md`, `BUILD-SUMMARY.md`, and a parity report.

The spec is **platform-agnostic**, so the same `SPEC.md` can target modern web, native iOS, or React Native — you
pick the target at build time.

## Targets

| Target | Best when | Default stack |
| --- | --- | --- |
| `web` | browser reach, SEO, desktop+mobile web, fastest path | Next.js + TS + Tailwind, Prisma + Postgres, Auth.js |
| `ios` | iOS-only, deep platform integration, App Store first | Swift + SwiftUI, SwiftData, URLSession |
| `react-native` | iOS **and** Android from one codebase | Expo + React Native + TS, React Navigation |

> **iOS note:** the buildable SwiftUI project and tests are produced regardless, but running on-device needs Xcode
> and an Apple Developer account — that's recorded in the build summary.

## Capturing the app with Playwright (Chrome)

The `fabrico-reverse-engineering-spec` skill drives the **playwright** MCP server (a real Chromium/Chrome). It
takes accessibility snapshots (structured, reliable) and screenshots, exercises forms and flows to reveal
validation and hidden states, and reads network requests to spot integrations. Full recipe:
`.claude/skills/fabrico-reverse-engineering-spec/references/playwright-capture.md`.

### Logging in & looking like a real browser

Most legacy apps are behind a login. Configure the **playwright** server's launch flags in `.mcp.json` (exact
flags depend on the `@playwright/mcp` version — check `npx @playwright/mcp@latest --help`). Two reliable
approaches:

**A) Persistent profile + drive the login form (default).** Run real Chrome, headed, with a persistent profile so
the session survives between runs:

```json
"playwright": {
  "command": "npx",
  "args": [
    "@playwright/mcp@latest",
    "--channel", "chrome",
    "--user-data-dir", "/Users/<you>/.fabrico/chrome-profile",
    "--viewport-size", "1280,800"
  ]
}
```

Log in once (the agent types into the email/password fields and clicks submit); later runs are already
authenticated. Real Chrome + headed + a genuine profile already present as a normal browser (real user-agent,
fonts, no obvious automation signals).

**B) Attach to your already-open Chrome (the most "normal browser" of all).** Launch your real Chrome with remote
debugging and log in manually (handling MFA/SSO yourself):

```bash
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-debug
```

```json
"playwright": { "command": "npx", "args": ["@playwright/mcp@latest", "--cdp-endpoint", "http://localhost:9222"] }
```

Playwright then controls the exact tab/session you logged into — detection and MFA stop being problems.

**Look-human options:** `--user-agent "<real UA>"`, `--device "iPhone 15"` (mobile emulation), keep **headed**
(avoid `--headless`), and pace actions with `browser_wait_for`. A lighter alternative to a full profile is
`--storage-state auth.json` (saved cookies/localStorage), produced once and reused.

> **Scope & ethics:** these options exist to inspect apps **you own or are authorized to analyze** for
> modernization. Don't use evasion to bypass protections on third-party sites. Run read-only against the live
> app — never submit destructive actions (deletes, payments, real emails); prefer staging/localhost.

## End-to-end example

```text
# inspect first, review the generated spec
/fabrico-reverse-spec https://my-old-app.example  uses email+password login

# …review SPEC.md and reverse-spec-notes.md, then rebuild on mobile
/fabrico-modernize SPEC.md react-native
```
