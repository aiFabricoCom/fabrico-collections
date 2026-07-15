# <Product name> — Specification

> Copy this file into your project as `SPEC.md`, fill it in, then run `/fabrico-autopilot SPEC.md`.
> The more complete each section, the more of the build runs autonomously without stopping to ask you.
> Examples below are for a sports-club app — replace them with your product.

## 1. Product summary

One paragraph: what it is, who it's for, and the core problem it solves.

> _Example:_ A management app for an amateur football club (5 teams, ~120 players). Lets the club run member
> records, training/match schedules, attendance, and membership fees in one place instead of spreadsheets + chat.

## 2. Users & roles

List each role and what they can do.

> - **Admin** — manage club, teams, members, fees; see everything.
> - **Coach** — manage their team's schedule and attendance.
> - **Player / parent** — view their team's schedule, confirm attendance, pay fees.

## 3. Scope

**In scope (MVP):**
> - member registration & profiles, assigned to teams
> - training/match schedule (CRUD by coach, read by players)
> - attendance confirmation
> - membership fees via online payment
> - schedule-change notifications

**Out of scope (explicitly not now):**
> - native mobile apps, live match stats, public marketing site, multi-club tenancy

## 4. Features / user stories

The most important section. List concrete stories, each with acceptance criteria. Use this shape:

```
### F1. <Story title>
As a <role>, I want <capability> so that <benefit>.
Acceptance criteria:
- [ ] <observable, testable condition>
- [ ] <edge case / validation rule>
- [ ] <permission rule: who can/can't>
```

> _Example:_
> ### F1. Player attendance
> As a player, I want to mark "attending / not attending" for an upcoming training so the coach can plan.
> Acceptance criteria:
> - [ ] Player sees their team's trainings for the next 14 days.
> - [ ] Player can set/change their status until the training start time, not after.
> - [ ] Coach sees a per-training attendance list with counts.

## 5. Data model

Key entities and how they relate (you don't need full schemas — the architect designs those).

> _Example:_ `Club 1—* Team 1—* Member`; `Team 1—* Training`; `Training *—* Member` via `Attendance(status)`;
> `Member 1—* Payment(period, amount, status)`.

## 6. Tech stack & constraints

State your preference, or write **"you decide"** to let the architect choose sensible defaults.

> _Example:_ "You decide, but prefer: TypeScript, a popular web framework, a SQL database, server-side rendering,
> easy deploy to a managed host. No vendor lock-in I can't export from."

## 7. Integrations & external services

List each, and **mark which credentials you will provide** vs. which should be stubbed/mocked for now.

> _Example:_
> - Payments: **Stripe** — I'll provide test keys.
> - Email/notifications: stub for MVP (log instead of send); design behind an interface.
> - Auth: email + password to start.

## 8. UI / UX

Figma links if you have them; otherwise describe the look/flows in words. Note languages and devices.

> _Example:_ No Figma. Clean, mobile-first, Polish language UI. Bottom nav: Schedule / Attendance / Payments /
> Profile. Admin uses a wider dashboard layout.

## 9. Non-functional requirements

> _Example:_ role-based access control; responsive (mobile + desktop); Polish + English; basic input validation
> and error states; automated tests for every feature; runs locally with one command.

## 10. Deployment

Where it should run — or write **"defer"** to build and test locally only for now.

> _Example:_ "Defer. Build and run locally for MVP; I'll handle hosting later."

## 11. Autonomy boundaries

What the autopilot may decide freely, and what it must stop and ask you about.

> **May assume freely:** stack details, folder structure, library choices, naming, validation rules not specified,
> reasonable UI defaults.
> **Must ask me about:** anything needing my credentials/keys, any spending or deployment, any change that alters
> the product scope above, deleting or migrating real data.
