#!/usr/bin/env bash
# Install cmux's agent-control skills so each agent can drive cmux.
#
# ISOLATION: Grok is deliberately kept independent of claude/claude-code (its HOME
# ~/.grok-isolated-home has NO .claude). So Grok gets cmux skills in its OWN
# ~/.grok/skills — it NEVER reads claude's skills. Claude/Codex/OpenCode use the
# Vercel `skills` CLI, which installs to each agent's own dir.
#
# NETWORK: fetches manaflow-ai/cmux. The npx path goes through your safe-chain —
# run this interactively.
set -euo pipefail

# ── Claude Code / Codex / OpenCode (each into its own skills dir) ─────────
if command -v npx >/dev/null 2>&1; then
  echo "==> Claude/Codex/OpenCode: npx skills add manaflow-ai/cmux -g"
  npx skills add manaflow-ai/cmux -g -y
else
  echo "(skip npx skills — npx not found)"
fi

# ── Ensure Codex + OpenCode actually carry the skills in their OWN dirs ───────
#    (the universal ~/.agents/skills install isn't always read from each agent's
#    own skills dir, so link them explicitly to be certain.)
#    Gated on the agent being on PATH — skip (and create no dir) if absent.
if [ -d "$HOME/.agents/skills" ]; then
  link_cmux_skills() {  # $1 = agent command   $2 = that agent's skills dir
    command -v "$1" >/dev/null 2>&1 || { echo "(skip $1 skills — not on PATH)"; return; }
    mkdir -p "$2"
    for s in "$HOME/.agents/skills"/cmux*; do
      [ -e "$s" ] || continue
      name="$(basename "$s")"
      if [ ! -e "$2/$name" ]; then ln -s "$s" "$2/$name"; fi
    done
    echo "==> ensured $1 has cmux skills (linked into $2)"
  }
  link_cmux_skills codex    "$HOME/.codex/skills"
  link_cmux_skills opencode "$HOME/.config/opencode/skills"
fi

# ── Grok (ISOLATED): install cmux skills into grok's OWN dir, not via claude ──
if [ -d "$HOME/.grok" ]; then
  echo "==> Grok: installing cmux skills into ~/.grok/skills (isolated; grok never reads ~/.claude)"
  tmp="$(mktemp -d)"
  if git clone --depth 1 --filter=blob:none --sparse https://github.com/manaflow-ai/cmux "$tmp" >/dev/null 2>&1 \
     && git -C "$tmp" sparse-checkout set skills >/dev/null 2>&1; then
    mkdir -p "$HOME/.grok/skills"
    cp -R "$tmp"/skills/cmux* "$HOME/.grok/skills/"
    echo "    installed $(ls -d "$tmp"/skills/cmux* 2>/dev/null | wc -l | tr -d ' ') cmux skills into ~/.grok/skills"
  else
    echo "    clone failed — skipping grok skills"
  fi
  rm -rf "$tmp"
fi

echo
echo "==> Done."
echo "    Verify (per-agent, separate dirs):"
echo "      ls ~/.claude/skills ~/.codex/skills ~/.config/opencode/skills 2>/dev/null | grep -i cmux"
echo "      ls ~/.grok/skills | grep -i cmux        # grok's own, isolated"
echo "    Remove: delete the cmux* skill dirs from each location."
