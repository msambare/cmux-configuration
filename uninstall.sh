#!/usr/bin/env bash
# cmux-configuration — uninstall. Removes the managed blocks (keeps your personal lines).
# cmux.json is NOT auto-reverted; restore a <file>.cmux-bak.<timestamp> if you want the old one.
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$REPO/lib/inject.sh"

echo "==> cmux-configuration uninstall (managed blocks removed; backups kept)"

for pair in \
  "$HOME/.config/ghostty/config|cmux-config:ghostty" \
  "$HOME/.config/fish/config.fish|cmux-config:fish" \
  "$HOME/.zshrc|cmux-config:zshrc"
do
  file="${pair%%|*}"; marker="${pair##*|}"
  cmux_backup "$file"
  cmux_remove_block "$file" "$marker"
  echo "    removed $marker from $file"
done

echo "    NOTE: cmux.json left as-is. To revert: cp ~/.config/cmux/cmux.json.cmux-bak.<ts> ~/.config/cmux/cmux.json"
echo "==> Done. Restart Ghostty/cmux."
