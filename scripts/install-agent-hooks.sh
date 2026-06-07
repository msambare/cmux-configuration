#!/usr/bin/env bash
# Wire cmux agent lifecycle hooks → cmux notifications + Feed, for Codex / OpenCode / Grok.
# Claude Code is auto-injected by cmux's claude wrapper (nothing to install).
# cmux hooks are idempotent and reversible: `cmux hooks <agent> uninstall`.
# No network; uses the cmux CLI only.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/../lib/cmux-cli.sh"
cmux_present || { echo "cmux not found (checked \$PATH and /Applications/cmux.app) — install cmux first." >&2; exit 1; }

for agent in codex opencode grok; do
  if command -v "$agent" >/dev/null 2>&1; then
    echo "==> cmux hooks $agent install"
    cmux_cli hooks "$agent" install -y
  else
    echo "(skip $agent — not on PATH)"
  fi
done

cat <<'EOF'

==> Done.
    Claude Code : auto-injected by cmux's claude wrapper (no install needed).
    Grok        : isolated HOME (~/.grok-isolated-home/.grok -> ~/.grok) sees its hook.
    Undo        : cmux hooks <agent> uninstall   (or: cmux hooks uninstall)
EOF
