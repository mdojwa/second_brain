#!/usr/bin/env bash
# Daily briefing for this brain — see DAILY.md for the task registry.
#
# Entry point for the SessionStart hook of every supported agent (.claude/
# settings.json, .codex/config.toml, .gemini/settings.json). Emits the
# briefing only on the first session of a calendar day; later sessions the same
# day exit silently. State (last-run date) lives in DAILY.md, so the CLI and any
# remote agent share one baseline.
#
#   scripts/daily-briefing.sh            # hook path: emit if due today
#   scripts/daily-briefing.sh --force    # emit regardless of the throttle
#   scripts/daily-briefing.sh --json     # same, wrapped for a Gemini CLI hook
#   scripts/daily-briefing.sh --status   # print last-run + whether due
#   scripts/daily-briefing.sh --stamp    # mark today as done (run AFTER reporting)

set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DAILY="$REPO_DIR/DAILY.md"
TODAY="$(date +%F)"

last_run() {
	local value
	value="$(grep -m1 '^last-run:' "$DAILY" 2>/dev/null | sed 's/^last-run:[[:space:]]*//')"
	[[ -n "$value" && "$value" != "never" ]] && printf '%s' "$value"
}

case "${1:-}" in
--stamp)
	if ! grep -q '^last-run:' "$DAILY" 2>/dev/null; then
		echo "No 'last-run:' line in $DAILY — nothing to stamp." >&2
		exit 1
	fi
	if ! sed "s/^last-run:.*/last-run: $TODAY/" "$DAILY" >"$DAILY.tmp"; then
		rm -f "$DAILY.tmp"
		echo "Could not stamp DAILY.md — set 'last-run:' to $TODAY by hand." >&2
		exit 1
	fi
	mv "$DAILY.tmp" "$DAILY"
	echo "Briefing stamped: last-run: $TODAY"
	exit 0
	;;
--status)
	BASELINE="$(last_run)"
	echo "last-run: ${BASELINE:-never} · today: $TODAY · briefing: $([[ "$BASELINE" == "$TODAY" ]] && echo "already done" || echo "due")"
	exit 0
	;;
esac

FORCE=0
JSON=0
for arg in "$@"; do
	case "$arg" in
	--force) FORCE=1 ;;
	--json) JSON=1 ;;
	esac
done

BASELINE="$(last_run)"

if [[ "$FORCE" -eq 0 && "$BASELINE" == "$TODAY" ]]; then
	exit 0
fi

# Chat MCPs want an epoch for `oldest`; hand it over ready-made, anchored at
# midnight of the baseline day (a bare date would inherit the current time).
BASELINE_EPOCH=""
if [[ -n "$BASELINE" ]]; then
	BASELINE_EPOCH="$(date -j -f '%Y-%m-%d %H:%M:%S' "$BASELINE 00:00:00" +%s 2>/dev/null || date -d "$BASELINE 00:00:00" +%s 2>/dev/null)"
fi

MESSAGE="☀️ DAILY BRIEFING — $TODAY (previous: ${BASELINE:-never}). Run it at the start of your first reply in this session: read DAILY.md and execute its task registry. Diff baseline: ${BASELINE:--2d}${BASELINE_EPOCH:+ (chat oldest=$BASELINE_EPOCH)}. After reporting: scripts/daily-briefing.sh --stamp"

# Claude Code and Codex take plain stdout as session context; Gemini CLI reads
# only JSON on stdout and ignores anything else.
if [[ "$JSON" -eq 1 ]]; then
	printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$MESSAGE"
else
	echo "$MESSAGE"
fi

# A briefing task that a shell can do (e.g. "open requests assigned to me")
# belongs here: add scripts/<check>.sh, call it below, and its output lands in
# the model's context together with the trigger above.
