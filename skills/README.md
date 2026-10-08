# 🛠 Skills

Reusable, task-specific instructions the agent loads on demand.

| Skill | What it does |
|-------|--------------|
| [`setup-brain`](setup-brain/SKILL.md) | First-run setup: interview the owner, fill in every placeholder, first commit. **Delete it once done.** |
| [`use-brain`](use-brain/SKILL.md) | Read-only access to this brain — the skill **other people** install to ask questions of it |
| [`daily-briefing`](daily-briefing/SKILL.md) | The once-a-day briefing defined in [`DAILY.md`](../DAILY.md) |
| [`weekly-report`](weekly-report/SKILL.md) | Weekly PPP report for leads, built from the brain + a live tracker refresh |
| [`brain-upkeep`](brain-upkeep/SKILL.md) | End-of-session maintenance pass — fold in what was established, archive what closed |

## How they are wired

`skills/` is the source of truth; [`.claude/skills/`](../.claude/skills) and [`.agents/skills/`](../.agents/skills) hold a symlink per skill — the two places Claude Code and Codex CLI look — so every skill here is live the moment the repo is cloned, with no install step. Gemini CLI has no skills mechanism: name the playbook you want and it reads the `SKILL.md` like any other file.

Add a skill → add both symlinks:

```bash
ln -s ../../skills/<name> .claude/skills/<name>
ln -s ../../skills/<name> .agents/skills/<name>
```

## Installing them elsewhere

Teammates who do not clone the repo can install its skills into their own agent environment:

```bash
npx skills@latest add {{ORG}}/{{REPO}}                    # Claude Code
npx skills@latest add {{ORG}}/{{REPO}} --agent codex       # Codex CLI
npx skills@latest add {{ORG}}/{{REPO}} --agent gemini-cli
```

## Adding your own

One directory per skill, holding a `SKILL.md` with YAML frontmatter (`name`, `description`) — the `description` is what makes the agent pick the skill up, so write it as "what it does + when to use it", including the phrases you actually say. Long reference material goes in a sibling file the skill links to, so it loads only when needed.
