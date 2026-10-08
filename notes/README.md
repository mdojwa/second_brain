# 📝 notes/

Dated history of a topic — the full evolution, threads, step-by-step decisions. One file per topic:

```
notes/YYYY-MM-DD-topic-slug.md
```

The date is the day the note was **started**; keep appending to the same file as the topic evolves rather than opening a new one per update.

## Rules

- `BRAIN.md`/`TASKS.md` **link** the relevant note next to the topic. A note nobody links is a note nobody will read.
- Notes are read **on demand only** — never bulk-loaded at session start.
- Dated `▶️` entries and changelogs belong here, **never** in `BRAIN.md`/`TASKS.md`.
- Convert relative dates to absolute ones ("next week" → `2026-06-10`).
- ⛔ No secrets, tokens or customer PII — same rule as everywhere in this repo.

## Note skeleton

```markdown
# YYYY-MM-DD — <topic>

**State**: <one line: where this stands today>
**Ticket / links**: <clickable links>

## Context
Why this topic exists, who asked, what problem it solves.

## Decisions
- YYYY-MM-DD — <decision> (who decided, why)

## Open questions
- <question> — waiting on <person/team>

## History
- ▶️ YYYY-MM-DD — <what happened>
```
