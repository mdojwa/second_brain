# ☀️ DAILY — daily briefing

> **What this is:** the registry of tasks that should happen **once a day, on the first session of the day** — and that can also be run **on demand**.
> This file is both the **execution instruction** (read by the CLI agent **and** by a remote agent) and the **state**: the last-run date is the baseline for the "what changed since last time" diff.

## How to run it

| Way | When |
|-----|------|
| **automatic** — SessionStart hook of your agent (`.claude/settings.json`, `.codex/config.toml` or `.gemini/settings.json` → [`scripts/daily-briefing.sh`](scripts/daily-briefing.sh)) | first session of a calendar day; later sessions that day stay silent |
| **on demand in the CLI** — "briefing" / "daily" / skill [`daily-briefing`](skills/daily-briefing/SKILL.md) | whenever you want; ignores the throttle |
| **on demand from a remote agent** — "run the briefing" | no shell there: it performs the steps below with its own tools (GitHub / tracker / chat MCP). If its access is **read-only** → it **reports but does not stamp** `last-run` (stamping belongs to the CLI session so the baseline stays consistent) |
| **manually in a terminal** — `scripts/daily-briefing.sh --force` | debugging the script itself |

<!-- daily-state — date of the last full run (YYYY-MM-DD). Read by the script (throttle) and by the model (diff baseline).
last-run: never
-->

## Briefing tasks

| # | Task | Who runs it | Output |
|---|------|-------------|--------|
| **T1** | [Refresh the tracker + chat, diff since last run](#t1--refresh-tracker--chat) | model (tracker / chat MCP) | change report + proposed updates to `TASKS.md`/`BRAIN.md` |

Add your own tasks here as you find things you check every morning — see [Maintaining this file](#maintaining-this-file).

After **all** tasks are done in a CLI session, stamp the run: `scripts/daily-briefing.sh --stamp`. Stamp **after** reporting — if the briefing does not finish, the next session should repeat it rather than lose the day.

---

### T1 — Refresh tracker + chat

Goal: say **what changed since the last briefing** — not dump the whole state (a full task review is a normal question about `TASKS.md`, not a briefing).

**Baseline** = `last-run` from the state block above. Missing / `never` → use `-2d`.

#### Step 1 — Tracker (one call, then `jq`)

Query the tracker for everything updated since the baseline, asking for **minimal fields only** (`status`, `assignee`, `summary`, `updated`, `type`). Example for Jira MCP (`searchJiraIssuesUsingJql`, `cloudId: {{JIRA_CLOUD_ID}}`):

```
jql:    project = {{JIRA_PROJECT}} AND updated >= "<baseline>" ORDER BY updated DESC
fields: ["status","assignee","summary","updated","issuetype"]
maxResults: 100
```

A result this size usually overflows the token limit and lands in a file — extract it in **one** `jq` pass instead of reading the file:

```bash
jq -r '.issues[] | [.key, .fields.status.name, (.fields.assignee.displayName // "Unassigned"), (.fields.updated|.[0:16]), .fields.summary] | @tsv' <file> | column -t -s$'\t'
```

- ⚠️ **Never ask for the `parent` field** — it nests a whole issue object and can blow the token limit on its own. Fetch a parent separately, only for the two or three keys that really need it.
- Scope the query **wider than your own team** if consumers of your work live in the same project — you want to see movement downstream.
- If `TASKS.md` → "🔁 Done on our side" holds open keys from other projects, run a second call: `key in (...) AND updated >= "<baseline>"`.

#### Step 2 — Classify the results

| Bucket | Condition | What to report |
|--------|-----------|----------------|
| **A. Our topics** | the key appears in `TASKS.md` | `KEY: <status in TASKS> → <live status>`, owner, one line "what it means" |
| **B. Movement outside the brain** | key **not** in `TASKS.md`, but the assignee is one of {{TEAM_MEMBERS}} **or** the summary carries one of our prefixes {{PREFIXES}} | **candidate to register** — propose a `TASKS.md` row + `P`, ask before adding |
| **C. The rest** | other teams, does not touch our rows | **one** aggregate line: "movement downstream: …", no detail |

#### Step 3 — Chat watchlist (public channels only)

Read **only messages newer than the baseline** (chat MCP with `oldest` = baseline epoch, concise output). ⛔ **Never** DMs or private channels (see BRAIN "Answering rules").

| Channel | Why we watch it |
|---------|-----------------|
| [{{#channel}}]({{link}}) (`{{CHANNEL_ID}}`) | {{what this channel decides for us — remove it when the topic closes}} |

Also: if the tracker (step 1) showed movement on a topic whose `TASKS.md`/`BRAIN.md` row **links a thread** — open that thread.

Take only three things out of chat: **(a)** questions/requests aimed at you or your group (they need a reaction), **(b)** decisions on open topics, **(c)** new signals with no ticket. Skip the rest (deploy bots, "+1", small talk).

#### Step 4 — Report

```
☀️ Briefing <today> · previous: <baseline>

⚠️ Needs your reaction
- …                                   ← questions from chat aimed at you, anything blocking someone else

🎫 Our topics — changes
- KEY (#no, P?): old → new status, owner — what it means

🆕 Outside the brain — register?
- KEY: summary (assignee) → suggest TASKS #.. P?

💬 Chat
- channel: decision / signal

Quiet: <channels/areas with no changes, one line>
```

Report rules: **concise** (one line per item), sorted by `P`, statuses always **live** (never from the brain), clickable links, **no ETAs** — the same rules as BRAIN "📏 Answering rules". Nothing changed → a single sentence, "quiet since `<baseline>`".

#### Step 5 — Persist

- **Do it straight away** (mechanical): update status/owner + `[live <date>]` in `TASKS.md` for bucket A — including **moving a row between "Active" and "Backlog" when the live status calls for it**. That is bookkeeping, not a decision.
- **Ask first**: new rows (bucket B), changing `P`, moving to "Completed", writing to `BRAIN.md`/`notes/`.
- Stamp the run (`--stamp`) and propose a commit at the end of the session.

---

## Maintaining this file

- **A new briefing task** = a row in the "Briefing tasks" table + a `### Tn` section with the steps. If a shell can do it — add a script under `scripts/` and call it from `daily-briefing.sh`; if it needs an MCP (tracker/chat/wiki) — write the steps for the model, so a shell-less remote agent can follow them too.
- **The chat watchlist lives here** (not in BRAIN) — add a channel when it starts to matter for an open topic, remove it when the topic closes. Always with its ID and the reason you watch it.
- **Do not keep briefing history here.** This file is instructions plus one date. What is worth remembering goes to `TASKS.md`/`BRAIN.md`, the wider narrative to `notes/`.
