# VHS tape — generate a clean, short GIF of the autopilot flow.
#   1. Install VHS:            brew install vhs        # https://github.com/charmbracelet/vhs
#   2. Generate the GIF:       vhs assets/demo-autopilot.tape
#   3. It writes:              assets/demo-autopilot.gif
#   4. (optional) swap the SVG for the GIF in README.md:
#                              s|assets/demo-autopilot.svg|assets/demo-autopilot.gif|
#
# This records the scripted demo (assets/demo-autopilot.sh) for a deterministic, short clip.
# To record a REAL run instead, launch Codex, then type "$fabrico-autopilot SPEC.md" in the composer.

Output assets/demo-autopilot.gif

Set Shell "bash"
Set FontSize 20
Set Width 1180
Set Height 430
Set Theme "Dracula"
Set Padding 28
Set TypingSpeed 50ms

Hide
Type "clear" Enter
Show
Sleep 500ms
Type "bash assets/demo-autopilot.sh" Enter
Sleep 9s
