# assets

Visuals used by the project [`README.md`](../README.md).

## Contents

| File | Type | Notes |
| --- | --- | --- |
| `hero.svg` | static SVG | Codex-oriented project banner. |
| `demo-autopilot.svg` | static SVG | Terminal illustration of `$fabrico-autopilot`. |
| `demo-modernize.svg` | static SVG | Terminal illustration of `$fabrico-reverse-spec` and `$fabrico-modernize`. |
| `demo-autopilot.sh` | bash | Deterministic representative output for recording a GIF. |
| `demo-autopilot.tape` | VHS tape | Recipe that renders `demo-autopilot.gif`. |

The SVG files render directly on GitHub. The tape and shell script generate a short deterministic animation.

## Generate an animated GIF

```bash
brew install vhs
vhs assets/demo-autopilot.tape
```

To use the generated GIF in the project overview:

```bash
sed -i '' 's|assets/demo-autopilot.svg|assets/demo-autopilot.gif|' README.md
```

## Record a real Codex session

VHS can also drive the real CLI in a disposable demo project. Replace the scripted-demo lines in the tape with:

```text
Type "codex --sandbox workspace-write --ask-for-approval on-request" Enter
Sleep 2s
Type "$fabrico-autopilot SPEC.md" Enter
Sleep 30s
```

Use `--dangerously-bypass-approvals-and-sandbox` only in an externally isolated, disposable recording
environment.

## Make a demo for another workflow

Copy `demo-autopilot.{sh,tape}`, rename it, and edit the displayed workflow and representative output. Keep clips
short and the terminal near 1180×430 so text stays crisp inline.
