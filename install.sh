#!/usr/bin/env bash
# cmux-configuration — install. Injects managed blocks into your shell/terminal config
# (idempotent, backs up every target first) and installs the cmux-only cmux.json.
# Re-runnable: re-running replaces the managed blocks in place; your personal lines are kept.
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$REPO/lib/inject.sh"

echo "==> cmux-configuration install"
echo "    backups: each target copied to <file>.cmux-bak.<timestamp> before changes"

# fresh machine with no ghostty config → seed from the full template first
if [ ! -f "$HOME/.config/ghostty/config" ]; then
  mkdir -p "$HOME/.config/ghostty"
  cp "$REPO/config/ghostty/config.template" "$HOME/.config/ghostty/config"
  echo "    seeded fresh ~/.config/ghostty/config from template"
fi
cmux_inject "$HOME/.config/ghostty/config"   "cmux-config:ghostty" "$REPO/blocks/ghostty.cmux.conf"
cmux_inject "$HOME/.config/fish/config.fish" "cmux-config:fish"    "$REPO/blocks/config.fish.cmux.fish"
cmux_inject "$HOME/.zshrc"                    "cmux-config:zshrc"   "$REPO/blocks/zshrc.cmux.sh"

# cmux.json is cmux-only (no personal secrets) → managed wholesale, with a backup.
mkdir -p "$HOME/.config/cmux"
[ -f "$HOME/.config/cmux/cmux.json" ] && cp "$HOME/.config/cmux/cmux.json" "$HOME/.config/cmux/cmux.json.cmux-bak.$(date +%Y%m%d-%H%M%S)"
cp "$REPO/config/cmux/cmux.json" "$HOME/.config/cmux/cmux.json"

cat <<'EOF'

==> Installed. Apply:
    cmux:    cmux reload-config   (or Cmd+Shift+,) then open a NEW tab for shell changes
    Ghostty: Cmd+Q, then reopen
    Verify:  ./verify.sh
    Undo:    ./uninstall.sh
EOF
