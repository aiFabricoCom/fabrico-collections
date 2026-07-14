# Playwright MCP capture recipe

Concrete procedure for observing a running web app through the **playwright** MCP server (it drives a real
Chromium/Chrome). Discover the operations exposed by the connected server at runtime because exact labels can vary
slightly by server version. Choose operations by capability rather than depending on client-internal tool names.

| Purpose | Required Playwright MCP capability |
| --- | --- |
| Open a URL | Browser navigation |
| Accessibility-tree snapshot (structured page model) | Structured page snapshot |
| Screenshot (visual evidence) | Screenshot capture |
| Click / type / select | Element interaction and form input |
| Read network requests | Network-request inspection |
| Read console messages | Browser-console inspection |
| Wait for load/text | Page-state or text waiting |
| List/switch tabs | Tab enumeration and selection |

The **accessibility snapshot** is usually more reliable than a screenshot for understanding structure (it exposes
roles, labels, form fields, table semantics). Use screenshots as evidence and for visual states.

## Recommended loop per screen

1. Navigate to the URL (or click through navigation to reach it).
2. Wait until key content is present (important for SPAs that render after load).
3. Capture a structured page snapshot and record interactive elements: forms (field name, type, required, validation text),
   tables/lists (columns, filters, sort, pagination controls), buttons/actions, links/nav, headings.
4. Capture a screenshot and save it to `legacy-capture/<screen-slug>.png`.
5. Exercise behavior to reveal hidden states: open a form and submit empty (capture validation), open modals/tabs,
   paginate once, trigger an error path. Snapshot each revealed state.
6. Inspect network requests and note backend endpoints and third-party calls (payments, maps, auth, analytics).
7. Append findings to `legacy-inventory.md` for this screen.

## Logging in & looking like a real browser

The `@playwright/mcp` server can authenticate and present as a normal browser via launch flags (set in
`.mcp.json` under the `playwright` server's `args`). Exact flags depend on the server version — check
`npx @playwright/mcp@latest --help`. Two reliable approaches:

**A) Persistent profile + drive the login form (default choice).** Run real Chrome, headed, with a persistent
profile so the session survives between runs:

```json
"playwright": {
  "command": "npx",
  "args": [
    "@playwright/mcp@latest",
    "--browser", "chrome",
    "--user-data-dir", "/Users/<you>/.fabrico/chrome-profile",
    "--viewport-size", "1280,800"
  ]
}
```

Log in once by driving the form (`browser_type` into email/password, `browser_click` submit); subsequent runs are
already authenticated. Real Chrome + headed + a genuine profile already look like a normal browser (real
user-agent, fonts, no obvious automation signals).

**B) Attach to the user's already-open Chrome (the most "normal browser" of all).** The user launches their real
Chrome with remote debugging and logs in manually (handling MFA/SSO themselves):

```bash
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-debug
```

```json
"playwright": { "command": "npx", "args": ["@playwright/mcp@latest", "--cdp-endpoint", "http://localhost:9222"] }
```

Playwright then controls the exact tab/session the user logged into — detection and MFA are non-issues.

**Look-human options:** `--user-agent "<real UA>"`, `--device "iPhone 15"` (mobile emulation), keep **headed**
(avoid `--headless`), and pace actions with `browser_wait_for`. A lighter alternative to a full profile is
`--storage-state auth.json` (saved cookies/localStorage), produced once and reused.

**Fallback in-session:** if the server runs without these flags, drive the real login form with `browser_type` +
`browser_click` using credentials the user provided. If login needs MFA/SSO you can't complete, STOP and ask the
user to log in / attach their session (approach B) — do not guess what's behind it.

**Scope & ethics:** only access apps the user owns or is authorized to inspect. These options exist to inspect
your *own* legacy apps for modernization — do not use evasion to bypass protections on third-party sites.

## Practical limits

- Don't crawl infinitely. Collapse list/detail and paginated pages into one representative example; record the
  *pattern* and the *volume*, not every row.
- Be gentle on production: read-only navigation, avoid submitting destructive actions (deletes, payments, emails).
  Prefer staging/localhost when available.
- If the playwright server isn't connected, tell the user to enable it (it's defined in `.mcp.json`).
