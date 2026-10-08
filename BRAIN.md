# 🧠 BRAIN — context memory

> The assistant's main "memory". Read at the start of every session. **Holds DURABLE context** (who the team is, decisions, architecture, watch-outs, environments, processes). Statuses / progress / who-is-on-it → `TASKS.md` (always refreshed live from the tracker). Dated history → `notes/` and `archive/`.

## Table of contents
- [📏 Answering rules](#-answering-rules) — **always read**
- [🎯 Priorities P0–P3](#-priorities-p0p3--how-to-read-and-assign-them) — **read on every question about tasks**
- [About the owner](#about-the-owner) · [Team](#team) · [Tech stack](#tech-stack)
- [Current work](#current-work): [Priorities](#priorities) · [Upcoming](#upcoming) · [Background](#background-projects)
- [Topics (durable context)](#topics--durable-context)
- [How to verify something is released](#how-to-verify-something-is-released)
- [Important decisions & links](#important-decisions--links) · [Recurring processes](#recurring-processes)
- [Known bugs & watch-outs](#known-bugs)
- [☀️ Daily briefing (DAILY.md)](DAILY.md) — once-a-day tasks + on demand

## 📏 Answering rules

> Binding rules for how the assistant answers — in the CLI **and** for any agent that reads this brain remotely. Keep this section at the top; add a rule whenever a mistake repeats.

- 🌐 **Language**: answer in the language of the asker. Public artefacts (tracker / wiki / PRs / chat posts) in **English**, unless the owner says otherwise.
- 🔗 **Clickable links**: whenever a link exists (ticket, doc, PR, wiki, chat thread), give the **clickable link** instead of a bare ID.
- 🎫 **Fresh ticket status (HARD rule)**: **every time** an answer contains a ticket's status or assignee, **refresh it live from the tracker** (minimal fields — status/assignee/type/summary) unless you did so in the last **5 minutes**. `BRAIN.md`/`TASKS.md` are context only (scope, decisions, links) — their statuses may be stale and must not be presented as current. Live always wins. No access = say plainly "I did not refresh", never guess.
- 🔄 **Re-verify volatile facts live**: PR state (open/draft/merged), "released or not", who is on it — treat as potentially stale and **check the source** before answering. Flag any discrepancy with the brain explicitly.
- 🗂️ **"Open / takeable / what's on the table" = the full picture, not a sample**: for questions like *open, takeable, to do, what's waiting, what should I pick up, backlog* — **completeness > brevity**. Do not filter by assignment, phase or "cleanliness" — show everything and **label** it (status / owner / phase) instead of dropping it. List **every** row of `TASKS.md` (Active + Backlog + ⏳ Pending + 🔁 tracking downstream) plus background projects and open bugs from `BRAIN.md`. Group a long list, never trim it to a subset; propose narrowing only at the end.
- 🎯 **Sort by priority `P`**: every answer about tasks is ordered P0 → P3 and states each item's `P`. "What to pick up first" = **the highest `P` with no owner that is not `Blocked`**; if there is none, say so and point at the highest blocked/assigned one plus what unblocks it. `P` from `TASKS.md` wins over the tracker's own priority field.
- ⏱️ **Ignore time estimates**: on status questions, no ETAs / deadlines / "how much is left". Report facts (done, in progress, owner, last activity).
- 🔁 **Done on our side ≠ closed**: for anything needing another team downstream, track whether they finished it (see `TASKS.md` → "🔁 Done on our side").
- 🔒 **Chat privacy**: never read private channels or DMs unless the owner explicitly names one.
- ⛔ **No sensitive data**: never write passwords/keys/tokens/secrets/customer PII into this repo. When in doubt — ask.

## 🎯 Priorities P0–P3 — how to read and assign them

> One source of truth: the **`P`** column in `TASKS.md` (every open row + items without a ticket + background topics + open bugs). The owner assigns `P`; it is not written back to the tracker.

| P | Meaning | When to assign |
|---|---------|----------------|
| **P0** | Take it now | Blocks a release or another team · breaks data/production · hard quarterly commitment (OKR, roadmap acceptance criteria) |
| **P1** | Next in line | Current product iteration. "Finished something → take the topmost P1" |
| **P2** | Planned | Real value, but not this iteration: waiting on a decision, discovery, or the scope sits with another team (we only watch it) |
| **P3** | Filler | Done opportunistically / while waiting on something else |

- **Tie-break at equal `P`**: (1) blocks others → (2) smaller scope.
- **`Blocked` does NOT lower `P`** — it is a label, so a high priority stuck on something stays visible.
- **`—` (no P) = a deliberate decision, NOT a forgotten row.** Used when there is no decision yet whether to do the topic at all. Always with a reason. `—` items are **still listed** for "what's open" questions (at the end), just not queued as "what to take".
- **Not every row is a task.** An instruction / reference link / workshop material gets no `P` — it belongs under "Important decisions & links", not in `TASKS.md`.
- **Upkeep**: a new topic gets its `P` the moment it enters `TASKS.md` (unsure → **P2**); review P0/P1 once a week with the weekly report; closed → "Completed" in the same session.

## About the owner

- **{{OWNER_NAME}}** — {{ROLE}} @ {{COMPANY}}.
- **Main area**: {{MAIN_AREA — the product/platform you own, in one or two sentences}}.
- **Ways of working**: {{how you like to work — e.g. plan/review with a strong model, implement with a cheaper one; where specs live}}.

## Team

| Person | Role | Focus |
|--------|------|-------|
| {{name}} | {{role}} | {{what they own}} |

## Tech stack

- {{languages, datastores, infra, the tools you touch daily}}

## Current work

### Priorities
{{The 2–5 things the team is actually pushing right now. One line each, pointing at `TASKS.md` rows and, for the narrative, at a topic section or note.}}

### Upcoming
{{Next up — scope agreed, work not started.}}

### Background projects
{{Long-running / low-intensity threads that are still open. These must show up in "what's open" answers.}}

## Topics (durable context)

> One `###` section per topic that needs more than a table cell: what it is, decisions taken, watch-outs, links. **State and progress do not live here** — they live in `TASKS.md`. Dated evolution goes to `notes/`.

### {{Topic name}} ({{TICKET-123}})
- **What it is**: …
- **Decisions**: …
- **Watch-outs**: …
- **Links / note**: [`notes/YYYY-MM-DD-topic.md`](notes/)

## How to verify something is released

> Do not infer a release from a ticket or a PR. Write down here the **precise, repeatable method** for your stack — and prefer a hard artefact (the deployed version + a marker unique to the change) over a status field.

- **Where deployed versions are recorded**: {{repo/path/dashboard, per environment and region}}
- **Method**: read the deployed version of the service, then check a **marker** (a symbol/string unique to *this* change — not the mere existence of a file) in the code at that release point.
- **Traps**: {{e.g. an integration environment that deploys feature branches before merge — "PR open ≠ deployed nowhere"}}
- **Always state the basis**: service, deployed version, marker, result.
- **Fallback**: {{tracker status / release channel — say explicitly that it is a fallback}}

## Important decisions & links

| Topic | Decision / link |
|-------|-----------------|
| {{topic}} | {{one line + clickable link}} |

## Recurring processes

- **{{Weekly report}}** — {{format, audience, where it is posted}}. Skill: [`skills/weekly-report`](skills/weekly-report/SKILL.md).
- **{{Daily briefing}}** — once-a-day tasks + on demand. Registry, instructions and state (`last-run` = diff baseline) → [`DAILY.md`](DAILY.md); skill [`daily-briefing`](skills/daily-briefing/SKILL.md).
- **{{Monthly metrics / release verification / … }}** — {{one line + pointer to a note}}.

## Known bugs

> Closed bugs → `archive/`.

### {{Bug title}} ({{status, `P`, ticket or "no ticket — deliberate"}})
- {{what breaks, who is affected, why it is not fixed yet}}
- {{if deliberately untracked: "report it on every question about open/unaddressed items" — so it cannot get lost}}

### ⚠️ Watch-outs for the future
- {{things to check when a related change comes up — contract changes by other teams, race conditions, migration traps}}
