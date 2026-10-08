---
name: weekly-report
description: Generate a weekly PPP (Progress/Problems/Priorities) report for leads from this brain (BRAIN.md/TASKS.md/notes) plus a live tracker refresh. Use when the user mentions "weekly report", "PPP report", "report for leads", "raport tygodniowy", or "Friday report".
---

# Weekly report for leads

Generate a PPP report **from the knowledge already in this repo** (`BRAIN.md`, `TASKS.md`, `notes/`) plus a live tracker refresh. **Do not ask the team for raw summaries** — everything needed is here. Report language: **English**.

## Workflow

1. Read `BRAIN.md` — team, priorities, projects, links.
2. Read `TASKS.md` for active tasks/statuses, and skim recent `notes/` for anything new.
3. Read `notes/weekly-report-history.md` (create it on the first run) — what was reported last week, so you show **deltas**, not repeats.
4. **Refresh every ticket live before drafting** — see "Freshness" below.
5. Build the draft yourself. **If anything is unclear — a status you cannot resolve, an item you are unsure belongs in the report, a conflict between sources — ask before finalising.** Do not guess.
6. Show the draft to the requester for review.
7. Once approved, append it to `notes/weekly-report-history.md`.
8. Only then post it to {{WHERE_THE_REPORT_GOES}} — and confirm with the user before sending.

## Report format

```
**Progress**
- ✅ [task name](ticket-link) — what shipped and why it matters
- 🔄 [task name](ticket-link) — what is in progress and where it stands

**Problems**
- current blockers (or "none")

**Priorities**
- [task name](ticket-link) — what is next (within two weeks)
```

## Style

- **Business level, not technical** — leads care about what was achieved, when it lands, and the impact.
- **Skip purely internal work** — refactors, data fixes, internal migrations. Exception: compliance and company-wide topics.
- **Skip minor bug fixes** — report features, milestones and outcomes, not routine fixes.
- **Do not report internal blockers** between your own tasks — only blockers that affect external delivery. Verify a blocker still exists before including it.
- **Link every item** to its ticket where one exists.

## Freshness — mandatory pre-draft checks

⚠️ `BRAIN.md`/`TASKS.md` are context only (scope, decisions, links); their statuses and "deployed where" notes may be stale. The live source always wins.

1. **Refresh every ticket live** — batch all keys into one query with minimal fields (`summary,status,assignee,type,updated`; never dump rich-text descriptions). **Refreshing also means reading new comments** since the last report — that is where blockers and real status surface, and it is a primary signal for the Problems section. If the tracker is unreachable, say "did not refresh" explicitly rather than guessing.
2. **Verify every release claim** with the method in `BRAIN.md` → "How to verify something is released". Never infer a deployment from ticket or PR state. If you cannot verify, downgrade the wording ("merged, rollout pending") instead of asserting an environment.

## Data handling

- ✅ Save **only the final approved report** to `notes/weekly-report-history.md`, newest last, under a `### YYYY-MM-DD (week YYYY-MM-DD → YYYY-MM-DD)` heading.
- ⛔ Do not save raw team summaries or anything sensitive.
- Report week range: Monday → Friday of the current week.
