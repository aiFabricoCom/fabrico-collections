# Platform UI audit checks

Use this reference after building the workflow's coverage matrix. Apply only checks supported by the target
platform, project requirements, and available evidence. Consult current official platform guidance when a
framework or operating-system rule is material to a finding.

## Shared checks

- Walk the primary user tasks and verify hierarchy, navigation clarity, feedback, recovery, and state coverage.
- Check consistency with existing components, typography, spacing, color, iconography, motion, and design tokens.
- Exercise default, loading, empty, error, validation, disabled, selected, and permission-denied states.
- Check readable content, localization expansion, text scaling, light and dark themes, reduced motion, and
  accessibility semantics where supported.
- Separate product-intent parity from pixel parity. Shared products may use platform-specific presentation and
  interaction conventions.

## Web

- Inspect the rendered app at supported responsive breakpoints and with pointer, touch, and keyboard input.
- Verify semantic structure, focus order and visibility, reflow and zoom, contrast, labels, announcements, and
  accessible names using `fabrico-ensuring-accessibility`.
- Capture representative screenshots, accessibility structure, computed layout where needed, interaction results,
  console errors, and automated accessibility findings.
- When an approved Figma reference exists, use `$fabrico-review-ui` for exact design comparison. Without Figma,
  verify against product intent, the existing design system, platform behavior, and before or after evidence.

## iOS

- Prefer an actual build on a supported simulator or device. Cover representative device classes, orientations,
  safe areas, text sizes, themes, and important application states.
- Inspect native navigation and dismissal behavior, touch interaction, keyboard behavior where relevant, system
  insets, text scaling, VoiceOver semantics and order, contrast, motion, and localization.
- Run the project's existing build, unit, UI, snapshot, lint, or accessibility checks when available.
- Treat source or preview inspection without a running build as inferred evidence, not visual verification.

## Android

- Prefer an actual build on a supported emulator or device. Cover representative screen classes, orientations,
  system insets, font scales, themes, and important application states.
- Inspect native navigation and back behavior, touch interaction, keyboard behavior where relevant, TalkBack
  semantics and order, contrast, motion, localization, and system-bar integration.
- Run the project's existing build, unit, instrumentation, UI, screenshot, lint, or accessibility checks when
  available.
- Treat source or preview inspection without a running build as inferred evidence, not visual verification.

## Shared mobile code

- Verify shared React Native, Flutter, Kotlin Multiplatform, or other cross-platform changes on every in-scope
  native target. A passing build or screenshot on one platform is not evidence for the other.
- Reuse shared tokens and components where they preserve product intent, but allow platform-specific navigation,
  controls, gestures, spacing, typography, and system integration.

## Evidence confidence

| Confidence | Minimum evidence |
| --- | --- |
| `HIGH` | Current rendered target, representative states and interactions, relevant accessibility checks, and executable project gates |
| `MEDIUM` | Current screenshots or recordings plus source inspection and successful build or tests, but no interactive target inspection |
| `LOW` | Source, design, preview, or stale captures only |

Do not make subjective visual changes from `LOW`-confidence evidence. Do not mark a platform `VERIFIED` without
`HIGH`-confidence after-state evidence.
