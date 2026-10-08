# 🧠 brain template

A ready-to-use **second brain** for someone who leads their own topics and their own team: a git repo that an AI agent reads at the start of every session, keeps up to date, and can serve to your teammates.

It ships empty — the structure, the cataloguing discipline and the core skills are there, the content is yours.

The memory is plain Markdown in git, so any coding agent can read and maintain it; the per-agent wiring for **Claude Code**, **Codex CLI** and **Gemini CLI** ships in this repo (see [§2](#2-which-agent-runs-it)). Nothing in `BRAIN.md`, `TASKS.md`, `DAILY.md` or the skills is vendor-specific — you can switch agents, or use different ones on different days, against the same brain.

## Quick start

1. **Create your repo** from this template — the *Use this template* button, or:
   ```bash
   gh repo create <your-org>/<your-brain> --template mdojwa/second_brain --private --clone
   ```
2. **Open it with your agent** and say *"set up my brain"*:
   ```bash
   cd <your-brain>
   claude      # Claude Code
   codex       # Codex CLI
   gemini      # Gemini CLI
   ```
   The [`setup-brain`](skills/setup-brain/SKILL.md) skill interviews you (who you are, team, stack, tracker, channels, processes), fills in every placeholder and makes the first commit.
3. **Delete the setup skill** (`git rm -r skills/setup-brain .claude/skills/setup-brain .agents/skills/setup-brain`) — it has no second use. From now on you just talk to your brain.

---

## 1. How to work with your brain

**Two ways in, one repo:**

- **Terminal** — `cd <your-brain>` and start your agent (`claude`, `codex`, `gemini`). This is the primary way: the agent has a shell, so hooks, scripts and git all work.
- **App** — the same repo opened in a desktop or web client (e.g. [claude.ai/code](https://claude.ai/code)). Same files, same instructions, so the agent behaves the same; handy from a phone or without a terminal.

**Do not edit the files by hand.** Talk to the agent instead — *"we decided X"*, *"this ticket is blocked on Y"*, *"remember this thread"*. The agent knows the cataloguing rules ([`CLAUDE.md`](CLAUDE.md)) and puts each thing in exactly one home, in the right shape. Hand-editing quietly breaks that: duplicated narrative, stacked dated layers, files that grow until every session pays for them in context.

**What lives where** — one home per kind of information:

| File | Holds | Grows? |
|------|-------|--------|
| [`BRAIN.md`](BRAIN.md) | **durable context** — team, stack, decisions, architecture, watch-outs, processes | no — stays small |
| [`TASKS.md`](TASKS.md) | **state** — status / owner / next step + a pointer, sorted by priority `P` | no — closed rows leave |
| [`notes/`](notes/) | **dated history** of a topic — full evolution, threads, decisions | yes |
| [`archive/`](archive/) | closed / shipped / cancelled material | yes |
| [`DAILY.md`](DAILY.md) | the once-a-day briefing: what to check, and when it last ran | no |

**The rhythm of a session:**

1. It opens by reading `BRAIN.md` + `TASKS.md`, and on the first session of a day it runs the **briefing** (`DAILY.md`): what is waiting on you, what moved in the tracker, what happened in the channels you watch.
2. You work — ask it questions, hand it threads and decisions, tell it what changed.
3. You close with *"update the brain"* ([`brain-upkeep`](skills/brain-upkeep/SKILL.md)): it folds the session into the files, archives what closed, and proposes the commit. **Commit at the end of a session** — the repo is the memory.

Two habits make the difference: **feed it** (paste the thread, say "remember this") and **let it clean up** (the upkeep pass, every session). A brain nobody feeds is a stale wiki; one nobody prunes becomes too expensive to read.

⛔ **Never** put passwords, keys, tokens or customer PII in here. The agent is instructed to ask when unsure — answer honestly.

---

## 2. Which agent runs it

The brain itself is agent-agnostic — Markdown plus a POSIX shell script. What differs between agents is only **wiring**: which file they auto-read, where they look for skills, and how a session-start hook is declared. All three are wired here:

| | Claude Code | Codex CLI | Gemini CLI |
|---|---|---|---|
| **Instructions read automatically** | [`CLAUDE.md`](CLAUDE.md) | [`AGENTS.md`](AGENTS.md) → points to `CLAUDE.md` | [`GEMINI.md`](GEMINI.md) → imports `CLAUDE.md` via `@./CLAUDE.md` |
| **Skills discovered from** | [`.claude/skills/`](.claude/skills) | [`.agents/skills/`](.agents/skills) | — no skills mechanism; name the playbook (*"run the weekly report"*) and it reads [`skills/<name>/SKILL.md`](skills/) |
| **Daily briefing on session start** | [`.claude/settings.json`](.claude/settings.json) hook | [`.codex/config.toml`](.codex/config.toml) hook | [`.gemini/settings.json`](.gemini/settings.json) hook |
| **If the hook does not fire** | — | just say *"briefing"* | just say *"briefing"* |

Both skill directories are symlinks to the one `skills/` tree, so a skill is written once and every agent sees the same file.

Worth knowing:

- **`CLAUDE.md` is the single source of instructions** for all of them — `AGENTS.md` and `GEMINI.md` are two-line pointers, so there is nothing to keep in sync. The filename is historical; rename it if the vendor-neutral name matters more to you than Claude Code's automatic read.
- **Codex** loads project hooks only once you let it trust the repo's `.codex/` layer (it asks on the first session), and there is an [open upstream bug](https://github.com/openai/codex/issues/17532) about repo-local `SessionStart` hooks not firing in interactive sessions. Two fallbacks: say *"briefing"* (same registry, no hook involved), or move the same hook block into `~/.codex/config.toml`, where user-level hooks always load.
- **Gemini** reads hook output only as JSON, which is why the briefing script has a `--json` mode; plain stdout (what Claude Code and Codex take as context) is ignored there.
- **Everything is degradable.** Miss the hook and you lose the automatic trigger, not the briefing; miss skill discovery and the skills are still Markdown files the agent will read when you point at them. No agent can end up with a brain it cannot use.

Verified on this repo: Claude Code 2.1 (hook fires, skills discovered) and Codex CLI 0.153 (`AGENTS.md` loaded as a project doc, all five skills discovered from `.agents/skills/`, checked with `codex debug prompt-input`). The Gemini CLI wiring follows its documented [hooks](https://geminicli.com/docs/hooks/reference/) and [context-file](https://geminicli.com/docs/cli/gemini-md/) schemas but has not been run here.

---

## What's in the box

```
├── CLAUDE.md          # agent instructions: session ritual, cataloguing rules, security
├── AGENTS.md          # pointer to CLAUDE.md (read automatically by Codex CLI)
├── GEMINI.md          # pointer + @./CLAUDE.md import (read automatically by Gemini CLI)
├── BRAIN.md           # durable context (pre-filled: answering rules + priorities P0–P3)
├── TASKS.md           # tasks as state + priority
├── DAILY.md           # daily briefing: task registry, instructions, last-run state
├── notes/ archive/    # dated history / closed material (conventions in their READMEs)
├── scripts/           # the daily-briefing hook (throttle + stamp, plain or --json output)
├── skills/            # setup-brain · use-brain · daily-briefing · weekly-report · brain-upkeep
├── .claude/           # Claude Code: SessionStart hook + skills/ symlinks
├── .agents/skills/    # Codex CLI: the same skills/ symlinks under the name Codex looks for
├── .codex/            # Codex CLI: SessionStart hook
└── .gemini/           # Gemini CLI: SessionStart hook (--json output)
```

Two sections of `BRAIN.md` come **pre-filled and are worth keeping**: *📏 Answering rules* (language, clickable links, live statuses over snapshots, completeness on "what's open", no ETAs) and *🎯 Priorities P0–P3* (what each level means, how to tie-break). They are the calibration that makes a brain answer usefully rather than plausibly — extend them, don't delete them.

Your teammates can install this brain's skills into their own agent with:

```bash
npx skills@latest add <your-org>/<your-brain>                  # Claude Code
npx skills@latest add <your-org>/<your-brain> --agent codex     # Codex CLI
npx skills@latest add <your-org>/<your-brain> --agent gemini-cli
```
