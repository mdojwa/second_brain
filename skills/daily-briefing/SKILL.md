---
name: daily-briefing
description: Run the daily briefing for this brain — things waiting on the owner, a live tracker refresh scoped to what changed since the last run, and the watched public chat channels. Use when the user says "briefing", "daily", "what changed", "odprawa", or when the SessionStart hook reports the briefing is due.
---

# Daily briefing

Once-a-day routine for this brain: report **what changed since the last briefing** — requests waiting on the owner, tracker movement, and the watched chat channels.

**The task registry and the full step-by-step instructions live in [`DAILY.md`](../../DAILY.md) in the repo root. Read it and follow it — this skill only routes you there and covers the on-demand entry point.**

## Workflow

1. **Read `DAILY.md`** (repo root). It holds: the task list, the `last-run` state block (= diff baseline), the chat watchlist, the report format, and what to persist afterwards.
2. Also read `TASKS.md` — the classification step needs to know which keys the brain already tracks, and their recorded status.
3. Execute every task in the registry, then report in the format `DAILY.md` defines.
4. Stamp the run: `scripts/daily-briefing.sh --stamp`. **After** reporting, never before.

## Entry points

- **Automatic**: the SessionStart hook (`.claude/settings.json` → `scripts/daily-briefing.sh`) fires on the first session of the day in this repo only, and prints the trigger plus the diff baseline into context.
- **On demand (this skill)**: run whenever asked, ignoring the throttle. Use the `last-run` value as the baseline even if the briefing already ran today, and say so if the window is short ("only since this morning — little movement").
- **Without a shell (remote agent)**: no scripts — run the registry tasks with the available MCP tools, then edit the `last-run:` line in `DAILY.md` directly (only if that agent has write access; a read-only agent reports without stamping).

## Guardrails

- Chat: **public channels only** — never DMs or private channels.
- Ticket statuses always come from the live query, never from `BRAIN.md`/`TASKS.md` snapshots.
- No ETAs or deadline forecasts — facts only.
- Persist only the mechanical updates (status/owner/`[live <date>]` in `TASKS.md`) on your own; ask before adding rows, changing `P`, or writing to `BRAIN.md`.
