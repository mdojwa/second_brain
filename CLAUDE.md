# CLAUDE.md — instructions for the agent working in this brain

This repository is **{{OWNER_NAME}}'s second brain**: a personal work-organisation system.
The agent is an assistant that **remembers context between sessions** through the files in this folder.

> These instructions are read automatically by Claude Code. Codex CLI reads `AGENTS.md` and Gemini CLI reads `GEMINI.md` — both point here, so this file is the only one to maintain. Any agent works: the brain is Markdown in git, and the per-agent wiring (skills, session-start hook) is described in [`README.md`](README.md).

## At the start of every session

1. **Read `BRAIN.md`** — the main memory (durable context). Start from the table of contents; read detailed sections only as needed.
2. **Read `TASKS.md`** — current tasks, priorities, statuses (state + pointers).
3. **`DAILY.md` — daily briefing:** if the hook (`scripts/daily-briefing.sh`) reported "DAILY BRIEFING" or the owner asks for one, read `DAILY.md` and run its tasks **before** the rest of the greeting. Later sessions the same day: the hook stays silent, do nothing.
4. **Notes in `notes/` — on demand:** never bulk-read them. `BRAIN.md`/`TASKS.md` link the relevant note next to each topic — open a note only when the question touches it (progressive disclosure — less context, lower cost).
5. Greet briefly, summarise what you know about the current state of work, and ask what today is about.

## Working rules

- **Language**: {{LANGUAGE}} (unless the owner writes in another language). Anything public (Jira, Confluence, PRs, Slack posts) stays **English** unless told otherwise.
- **Keep files current**: after every meaningful session, update `BRAIN.md` and `TASKS.md` with what was established — following the cataloguing rules below.
- **Notes**: create notes in `notes/` with the date in the filename, e.g. `notes/2026-06-03-topic.md`.
- **Archive**: move completed/obsolete items to `archive/`.
- **Commit**: at the end of a session, propose a commit summarising the changes.
- **Be proactive**: remind about overdue items, suggest priorities, ask questions.
- **Be concise**: short, concrete answers. Expand only when asked.

## 🗂️ Cataloguing rules (brain upkeep — mandatory)

> Goal: `BRAIN.md` and `TASKS.md` stay small and fast to read (they are loaded every session, and by any agent that reads this brain remotely). History grows in `notes/`/`archive/`, never in the core files.

- **One home per topic:**
  - `BRAIN.md` = **durable context** (who the team is, decisions, architecture, watch-outs, environments, processes). The narrative of a topic lives here.
  - `TASKS.md` = **state** (status/owner/next) + a **pointer** to BRAIN or a note. Do NOT duplicate the BRAIN narrative here.
  - `notes/<date>-topic.md` = **dated history/changelog** of a topic (full evolution, chat threads, step-by-step decisions).
- **"Update, don't append":** when a topic moves, **rewrite the state line**; push the previous state into the note. Never leave stacked dated layers side by side in BRAIN/TASKS.
- **Dated entries / changelogs belong in notes only**, never in the BRAIN/TASKS core.
- **Table cells stay short** (≤ ~3 lines). If a topic needs an essay, the essay goes to a note and the table keeps a one-line pointer.
- **Closed/shipped/cancelled → `archive/` in the same session** (leave a one-line pointer under "Completed").
- **Lose nothing:** when moving content out of the core, first make sure the destination (note/archive) contains it — only then trim.
- **Freshness > completeness in the core:** live statuses (tickets, PRs) are refreshed from the source anyway — don't keep status snapshots in the core "for history".

## ⛔ Data security

> **ABSOLUTE RULE**: this repository must **NEVER** contain sensitive data.

In particular:
- **Passwords** (services, databases, accounts)
- **API keys / tokens** (cloud, GitHub, Slack, …)
- **Secrets** (private keys, certificates, env vars with sensitive values)
- **Personal data from outside the company** (end-customer PII)

**When in doubt** whether something is sensitive — **ask the owner** before saving it. Better one question too many than a leak.

## Directory structure

```
{{REPO}}/
├── CLAUDE.md         # These instructions (read automatically by Claude Code)
├── AGENTS.md         # Pointer to CLAUDE.md (read automatically by Codex CLI)
├── GEMINI.md         # Pointer to CLAUDE.md (read automatically by Gemini CLI)
├── BRAIN.md          # Main memory — durable context, decisions, architecture
├── TASKS.md          # Active tasks, priorities, statuses
├── DAILY.md          # Daily briefing — once-a-day tasks + on demand (state: last-run)
├── notes/            # Dated notes (YYYY-MM-DD-topic.md)
├── archive/          # Completed/obsolete material
├── scripts/          # Automation (daily briefing hook, checks)
├── skills/           # Agent skills (symlinked into .claude/skills and .agents/skills)
├── .claude/          # Claude Code: session-start hook + skills
├── .agents/skills/   # Codex CLI: the same skills
├── .codex/           # Codex CLI: session-start hook
└── .gemini/          # Gemini CLI: session-start hook
```
