# Examples — specs and prompts

The spec-driven flow turns a short idea into working software:

```text
idea → $fabrico-create-spec → SPEC.md → $fabrico-autopilot → built, tested app
```

You can get a `SPEC.md` in two ways:

1. **Generate it from a one-liner** — `$fabrico-create-spec <your idea>` asks a few high-leverage questions and
   fills the template.
2. **Write it by hand** — copy [`../SPEC.template.md`](../SPEC.template.md) to `SPEC.md` and fill it in.

A complete worked example ships as [`../SPEC.md`](../SPEC.md).

## Example Codex prompts

Paste one line into the Codex composer:

| Domain | Prompt |
| --- | --- |
| **Sports club** | `$fabrico-create-spec a management app for an amateur football club — members, teams, training schedule, attendance, monthly fees` |
| **Booking / studio** | `$fabrico-create-spec a class-booking app for a yoga studio — schedule, reservations, memberships, waitlists, Stripe payments` |
| **SaaS dashboard** | `$fabrico-create-spec a SaaS analytics dashboard that ingests CSV/API data and shows charts, with team accounts and role-based access` |
| **Marketplace** | `$fabrico-create-spec a two-sided marketplace for local handymen — listings, search, bookings, reviews, escrow payments` |
| **Restaurant** | `$fabrico-create-spec a QR-code ordering app for a restaurant — menu, cart, kitchen tickets, payments, live order status` |
| **Internal tool** | `$fabrico-create-spec an internal admin tool for support tickets with SLA tracking and Slack notifications` |

## Tips for a better spec

- **Name the must-haves.** Concrete features give the generator useful story boundaries.
- **Say who uses it.** Roles shape permissions, flows, and screens.
- **Mention integrations and credentials.** State which test keys you will provide and which services should be mocked.
- **Choose a platform or say “you decide.”** An explicit choice narrows architecture; leaving it open preserves portability.
- **Review generated acceptance criteria.** Observable conditions make implementation and verification substantially stronger.

## Full one-liner to working app

```text
$fabrico-create-spec a class-booking app for a yoga studio — schedule, reservations, memberships, Stripe payments

# Review and adjust the generated SPEC.md, then:
$fabrico-autopilot SPEC.md
```

See [Autopilot](../docs/autopilot.md) for the autonomy contract and
[the full documentation](../docs/README.md) for installation and workflow details.
