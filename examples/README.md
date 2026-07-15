# Examples — specs & prompts

The spec-driven flow turns a short idea into working software:

```
idea → /fabrico-create-spec → SPEC.md → /fabrico-autopilot → built, tested app
```

You can get a `SPEC.md` two ways:

1. **Generate it from a one-liner** — `/fabrico-create-spec <your idea>` drafts the full spec for you (asks a few
   questions, then fills the template). Best when you want to move fast.
2. **Write it by hand** — copy [`../SPEC.template.md`](../SPEC.template.md) to `SPEC.md` and fill it in. Best when
   you already know exactly what you want.

A complete worked example output ships in the repo: [`../SPEC.md`](../SPEC.md) — a sports-club management app.

## Example prompts (ready to paste)

Each line is a prompt you give Claude Code. `/fabrico-create-spec` expands it into a full `SPEC.md`.

| Domain | Prompt |
| --- | --- |
| **Sports club** | `/fabrico-create-spec a management app for an amateur football club — members, teams, training schedule, attendance, monthly fees` |
| **Booking / studio** | `/fabrico-create-spec a class-booking app for a yoga studio — schedule, reservations, memberships, waitlists, Stripe payments` |
| **SaaS dashboard** | `/fabrico-create-spec a SaaS analytics dashboard that ingests CSV/API data and shows charts, with team accounts and role-based access` |
| **Marketplace** | `/fabrico-create-spec a two-sided marketplace for local handymen — listings, search, bookings, reviews, escrow payments` |
| **Restaurant** | `/fabrico-create-spec a QR-code ordering app for a restaurant — menu, cart, kitchen tickets, payments, live order status` |
| **Internal tool** | `/fabrico-create-spec an internal admin tool for customer-support tickets with SLA tracking and Slack notifications` |

### Tips for a better spec (and a smoother autonomous build)

- **Name the must-haves.** A handful of concrete features beats a vague vision: "members, schedule, attendance,
  fees" gives the generator something to turn into user stories.
- **Say who uses it.** Roles (admin / coach / player) shape permissions and screens.
- **Mention integrations + keys.** e.g. "Stripe (I'll provide test keys)" lets the build stub or wire payments
  correctly.
- **Pick a platform or say "you decide."** Leaving it open keeps the spec portable (web / iOS / React Native).

## Full one-liner to working app

```text
/fabrico-create-spec a class-booking app for a yoga studio — schedule, reservations, memberships, Stripe payments
# review the generated SPEC.md, tweak anything, then:
/fabrico-autopilot SPEC.md
```

See [`../docs/autopilot.md`](../docs/autopilot.md) for how the autonomous build runs, and
[`../docs/README.md`](../docs/README.md) for the full guide.
