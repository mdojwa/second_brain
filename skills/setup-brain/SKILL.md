---
name: setup-brain
description: First-run setup of a brain repository created from the brain template — interview the owner, fill in every {{...}} placeholder across BRAIN.md/TASKS.md/DAILY.md/CLAUDE.md/skills, wire up the daily briefing, and make the first commit. Use when the repo still contains unfilled {{...}} markers, or when the user says "set up my brain", "initialise the brain", "skonfiguruj brain".
---

# Set up this brain

Turn a fresh copy of the brain template into **this owner's** brain. Run once, at the very first session.

## Step 0 — check it is needed

```bash
grep -rn '{{' --include='*.md' --include='*.sh' --include='*.json' . | grep -v skills/setup-brain
```

No hits → the brain is already set up; say so and stop. Hits → continue.

## Step 1 — interview (ask, don't guess)

Ask in **one batch**, in the user's language, and keep it short. Everything here is non-sensitive by design — never ask for tokens, keys or credentials.

1. **Who you are** — name, role, company; the area/product you own in one or two sentences.
2. **Team** — who is on it, their focus (names and roles only).
3. **Tech stack** — languages, datastores, infra you touch daily.
4. **Tracker** — which system, which project key(s), and the URL of one ticket (so links can be built correctly).
5. **Chat** — which public channels matter for your open topics (name + ID + why you watch each one).
6. **Repos** — the GitHub org/repo of *this* brain, plus the repos your work lives in.
7. **Working language** — the language the assistant should reply in (public artefacts stay English).
8. **Release verification** — how you can tell something is actually deployed (where versions are recorded, the traps).
9. **Recurring processes** — reports, metrics, reviews you owe someone, and when.

## Step 2 — fill the template

Replace every `{{...}}` placeholder with the answers, file by file:

| File | What to fill |
|------|--------------|
| `CLAUDE.md` | owner name, repo name, working language |
| `BRAIN.md` | About the owner, Team, Tech stack, Current work, release-verification method, recurring processes |
| `TASKS.md` | replace the example rows with real ones (or empty tables — never leave placeholder rows) |
| `DAILY.md` | tracker query (project key, cloud/instance id), team members + prefixes for bucket B, the chat watchlist |
| `skills/use-brain/SKILL.md` | owner name, org/repo, the topics this brain covers (its `description` is what makes teammates' agents load it) |
| `skills/weekly-report/SKILL.md` | audience, format, where the report is posted |
| `skills/README.md` | the org/repo in the install command |
| `README.md` | rewrite the opening paragraph so it describes **this** brain (whose it is, what it covers, how to reach it); keep sections 1-3, and swap `<your-org>/<your-brain>` for the real repo |

Rules while filling:
- **Ask rather than invent.** An unknown answer becomes an explicit `TODO:` line, not a plausible guess.
- **Never leave a `{{...}}` marker behind** — fill it, or delete the row/section it belongs to.
- Keep the pre-filled generic sections — **"📏 Answering rules"** and **"🎯 Priorities P0–P3"** — as they are. They are the calibration that makes the brain useful; add owner-specific rules, don't delete these.
- Empty is fine. A section with no content yet gets one line: `_(nothing here yet)_`.

## Step 3 — verify

1. `grep -rn '{{' --include='*.md' --include='*.sh' . | grep -v skills/setup-brain` → must be empty.
2. `scripts/daily-briefing.sh --status` → prints `last-run: never · … · briefing: due`.
3. Confirm the SessionStart hook is wired for the agent the owner uses: `.claude/settings.json` (Claude Code), `.codex/config.toml` (Codex CLI) or `.gemini/settings.json` (Gemini CLI).

## Step 4 — first commit

Propose (do not push without asking):

```
chore(brain): initial setup for <owner>
```

## Step 5 — tell the owner what happens next

Three sentences, no more:
- Every session starts by reading `BRAIN.md` + `TASKS.md`; the first session of the day also runs the briefing.
- They talk to the assistant, the assistant maintains the files — no hand-editing.
- Delete this skill once setup is done (`git rm -r skills/setup-brain .claude/skills/setup-brain .agents/skills/setup-brain`); it has no second use.
