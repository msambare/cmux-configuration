#!/usr/bin/env bash
# Create (or attach to) a git worktree for <branch> and open it as a cmux workspace —
# the basis for running parallel agents on isolated branches.
#
#   worktree.sh <branch> [base-ref]
#
# Worktrees are grouped in a sibling "<repo>.worktrees/" dir (tidy + easy to group
# in cmux's sidebar via workspaceGroups.byCwd). Inside cmux it auto-opens the
# workspace; otherwise it prints the path. Remove with `git worktree remove`.
set -euo pipefail
[ $# -ge 1 ] || { echo "usage: worktree.sh <branch> [base-ref]" >&2; exit 2; }
branch="$1"; base="${2:-HEAD}"

root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "not inside a git repo" >&2; exit 1; }
name=$(basename "$root")
wtroot="$(dirname "$root")/${name}.worktrees"
wt="$wtroot/$branch"
mkdir -p "$wtroot"

if [ -d "$wt" ]; then
  echo "worktree already exists: $wt"
elif git -C "$root" show-ref --verify --quiet "refs/heads/$branch"; then
  git -C "$root" worktree add "$wt" "$branch"          # existing branch
else
  git -C "$root" worktree add "$wt" -b "$branch" "$base"  # new branch off base
fi
echo "worktree: $wt"

if [ -n "${CMUX_SOCKET_PATH:-}" ] && command -v cmux >/dev/null 2>&1; then
  if cmux "$wt" >/dev/null 2>&1; then echo "opened in cmux."; else echo "(open manually: cmux \"$wt\")"; fi
else
  echo "(not in a cmux session — run: cmux \"$wt\")"
fi
echo "remove later: git -C \"$root\" worktree remove \"$wt\"  (then: git branch -d $branch)"
