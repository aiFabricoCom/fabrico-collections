# assets

Visuals used in the project [`README.md`](../README.md).

## What's here

| File | Type | Notes |
| --- | --- | --- |
| `hero.svg` | static SVG | Banner. Renders directly in GitHub — no tooling needed. |
| `demo-autopilot.svg` | static SVG | Terminal "screenshot" of the `/fabrico-autopilot` flow. |
| `demo-modernize.svg` | static SVG | Terminal "screenshot" of `/fabrico-reverse-spec` + `/fabrico-modernize`. |
| `demo-autopilot.sh` | bash | Scripted, representative output for recording a GIF. |
| `demo-autopilot.tape` | VHS tape | Recipe to render `demo-autopilot.gif`. |

The SVGs are hand-made (not recordings) and work in the README out of the box. The `.tape` + `.sh` let you
generate a **real animated GIF** when you want motion.

## Generate an animated GIF

```bash
brew install vhs                  # https://github.com/charmbracelet/vhs
vhs assets/demo-autopilot.tape    # writes assets/demo-autopilot.gif
```

Then, if you prefer the GIF over the static SVG, point the README at it:

```bash
sed -i '' 's|assets/demo-autopilot.svg|assets/demo-autopilot.gif|' README.md
```

## Record a real session (recommended for an authentic demo)

VHS runs commands for real, so you can capture an actual Claude Code run. Edit the tape's body to drive the real
CLI in a demo project:

```
Type "claude" Enter
Sleep 2s
Type "/fabrico-autopilot SPEC.md" Enter
Sleep 30s        # let it work; trim length to taste
```

## Make a demo for another command

Copy `demo-autopilot.{sh,tape}`, rename, and edit the printed lines / typed command (e.g. a
`demo-modernize.sh` mirroring `demo-modernize.svg`). Keep clips short (8–15s) and the terminal ~1180×430 so they
look crisp inline.
