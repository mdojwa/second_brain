---
name: brain-upkeep
description: End-of-session (or on-demand) maintenance pass over this brain — fold what was established into BRAIN.md/TASKS.md, move dated history to notes/, archive what closed, and propose the commit. Use when the user says "update the brain", "wrap up the session", "zaktualizuj brain", "podsumuj sesję", or when the core files have grown stale or bloated.
---

# Brain upkeep

Keep `BRAIN.md` and `TASKS.md` **small, current and trustworthy**. They are read at the start of every session and by every agent that queries this brain — bloat there costs context on every single read.

The rules themselves live in [`CLAUDE.md`](../../CLAUDE.md) → "🗂️ Cataloguing rules". This skill is the pass that applies them.

## The pass

1. **Collect what this session established** — decisions, new scope, changed owners, new signals, things that closed.
2. **Route each item to exactly one home:**
   | Item | Home |
   |------|------|
   | durable context (decision, architecture, watch-out, process, link) | `BRAIN.md` |
   | state (status / owner / next step) + a pointer | `TASKS.md` |
   | dated evolution, threads, step-by-step history | `notes/<date>-topic.md` |
   | closed / shipped / cancelled | `archive/` + a one-line pointer under `TASKS.md` "Completed" |
3. **Rewrite, don't append.** Update the existing state line; push the previous state into the note. Never stack dated layers in the core files.
4. **Trim safely.** Before removing anything from a core file, confirm the destination note/archive already contains it.
5. **Check the shape** of what you touched:
   - table cells ≤ ~3 lines; longer → note + one-line pointer;
   - every open row has a `P` (unsure → P2; `—` only with a stated reason);
   - no dated `▶️` entries left in `BRAIN.md`/`TASKS.md`;
   - every topic in `BRAIN.md` that has a note links it, and vice versa;
   - no status snapshots kept "for history" — those are refreshed live anyway.
6. **Ask before**: adding new `TASKS.md` rows for topics the owner has not confirmed, changing a `P`, or moving something to "Completed". Do the mechanical updates (status/owner/`[live <date>]`, moving a row between Active and Backlog to match the live status) on your own.
7. **Propose a commit** — a one-line summary of what changed in the brain, e.g. `docs(brain): <topic> — <what changed>`. Do not push without asking.

## Guardrails

- ⛔ **Never write secrets, tokens, credentials or customer PII** into the repo. When unsure whether something is sensitive — ask.
- Unverified information (something heard in chat, not confirmed by the owner) gets labelled as unverified, or stays out.
- Nothing gets deleted outright — it moves to `notes/` or `archive/`.
