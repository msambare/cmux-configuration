#!/usr/bin/env bash
# Install cmux's agent-control skills — teaches Claude Code, Codex, OpenCode, Grok
# to drive cmux (workspaces, panes, settings, browser, diagnostics) via the cmux CLI.
#
# NETWORK: fetches from manaflow-ai/cmux via the Vercel `skills` CLI (npx). Your
# safe-chain wrapper will engage — run this INTERACTIVELY so you can review/approve.
set -euo pipefail

if ! command -v npx >/dev/null 2>&1; then
  echo "npx not found — install Node.js first." >&2; exit 1
fi

echo "==> Installing cmux skills for all detected agents…"
echo "    (source: manaflow-ai/cmux · your safe-chain may prompt)"
npx skills add manaflow-ai/cmux -g -y

echo
echo "==> Done."
echo "    Grok runs with an isolated HOME (~/.grok-isolated-home) whose dotfiles symlink"
echo "    back to your real home, so it picks up skills installed in ~/.codex / ~/.claude."
echo "    Verify: ls ~/.codex/skills ~/.claude/skills 2>/dev/null | grep -i cmux"
echo "    Update: re-run this script.  Remove: delete the cmux-* skill directories."
