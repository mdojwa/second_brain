---
name: use-brain
description: Load {{OWNER_NAME}}'s work knowledge base ({{ORG}}/{{REPO}}) — team context, active tasks, priorities, known bugs, recurring processes and technical decisions. Use when the user mentions "{{OWNER_NAME}}'s brain", "{{TOPICS}}", or needs context about {{OWNER_NAME}}'s team and work.
---

# Use {{OWNER_NAME}}'s brain

Read-only access to {{OWNER_NAME}}'s persistent work knowledge base (`{{ORG}}/{{REPO}}`). This is the skill **other people's** agents install to query this brain — keep its `description` accurate, that is what triggers it.

## Prerequisites

- `gh` CLI authenticated with access to the `{{ORG}}` org.

## Workflow

### Step 1 — fetch the repo

```bash
if [ -d /tmp/{{REPO}}-brain ]; then
  git -C /tmp/{{REPO}}-brain pull --quiet
else
  gh repo clone {{ORG}}/{{REPO}} /tmp/{{REPO}}-brain -- --depth 1 --quiet
fi
```

### Step 2 — read the core files (in parallel)

1. **`BRAIN.md`** — main memory (durable context): owner, team, stack, projects, topics, known bugs, links, processes. **Start from the table of contents; read detailed sections as needed.** ⚠️ Its opening section **"📏 Answering rules"** is binding on you — language, clickable links, live ticket status, completeness of "what's open" answers, no ETAs, chat privacy, no secrets.
2. **`TASKS.md`** — active tasks as state (status / owner / next) plus pointers into `BRAIN.md` and `notes/`.
3. **`CLAUDE.md`** — working conventions, cataloguing rules, and the ⛔ no-sensitive-data rule.

`DAILY.md` — read it **only** when asked for a briefing / "what changed"; then follow its steps and report. **Do not edit `last-run`** — this access is read-only, so stamping stays with the owner's CLI session.

### Step 3 — notes & archive on demand

- **Do NOT bulk-read `notes/`.** `BRAIN.md`/`TASKS.md` link the relevant note next to each topic — open one only when the question touches that topic.
- **`archive/`** holds history moved out of the core files. Read it only when history is explicitly asked about.

## Rules

- ⛔ **Read-only** — never modify anything in the repo.
- 🔄 **Always pull first** — the brain changes often; never answer from a previous read.
- 🎫 **Fresh ticket status** — refresh any ticket status/assignee live from the tracker before stating it (unless refreshed in the last 5 minutes). The brain's copies go stale; live wins.
- 🌐 **Language** — answer in the language the asker used.
- 🤷 **Not in the brain** — say so plainly. Never guess or invent.
