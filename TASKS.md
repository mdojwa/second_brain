# 📋 TASKS — active tasks and priorities

> **`P` = team priority (P0 → P3)**, assigned by the owner — definitions, tie-break and the meaning of `—` → [BRAIN.md "Priorities P0–P3"](BRAIN.md#-priorities-p0p3--how-to-read-and-assign-them). The tracker's own priority field is a hint, not the source of truth.
> Status icons: 🔴 urgent | 🟡 in progress | 🟢 done | ⚪ backlog · **Always refresh status/owner live from the tracker** (see BRAIN.md "Answering rules"). This file = state + pointer; the full narrative and decisions → `BRAIN.md` and `notes/`.
> Rows are **sorted by `P`**. `Blocked` does not lower `P` — it is a label.

## Active (in progress — has an owner)

| P | # | St. | Task (ticket) | Owner | State + pointer |
|---|---|-----|---------------|-------|-----------------|
| **P0** | 1 | 🟡 | [{{TICKET-123}}]({{link}}) {{short title}} | @{{owner}} | {{one line: where it stands, what is next}} · [BRAIN]({{#anchor}}) / [note](notes/) |

## Backlog (takeable)

| P | # | St. | Task (ticket) | Owner | State + pointer |
|---|---|-----|---------------|-------|-----------------|
| **P2** | 2 | ⚪ | [{{TICKET-124}}]({{link}}) {{short title}} | — | {{what is needed to start}} |

## ⏳ Pending / signals for the future (no ticket)

> Things that exist but have no ticket yet. They **still count as open** — list them in "what's open" answers.

| P | Topic | Signal / source | Next step |
|---|-------|-----------------|-----------|
| — | {{topic}} | {{where it came from — thread, meeting, doc}} | {{decision needed / who to ask}} |

## 🔁 Done on our side — tracking downstream

> Our part is finished, but the topic is not closed until the consumer (frontend / another team / another service) ships theirs.

| # | Topic | Our part | Waiting on | Pointer |
|---|-------|----------|-----------|---------|
| 3 | {{topic}} | ✅ {{what we shipped}} | {{team / ticket}} | {{link}} |

## Completed (archived)

> One line per closed item, newest first. Detail and history → `archive/`.

- {{YYYY-MM-DD}} — {{TICKET / topic}}: {{one-line outcome}} → [archive](archive/)
