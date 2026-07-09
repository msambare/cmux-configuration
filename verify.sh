#!/usr/bin/env bash
# cmux-configuration — verify the managed config is in place and valid.
set -uo pipefail
pass=0; fail=0
chk() { local d="$1"; shift; if "$@" >/dev/null 2>&1; then printf 'OK    %s\n' "$d"; pass=$((pass+1)); else printf 'FAIL  %s\n' "$d"; fail=$((fail+1)); fi; }

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GC="$HOME/.config/ghostty/config"; FC="$HOME/.config/fish/config.fish"
ZC="$HOME/.zshrc"; CJ="$HOME/.config/cmux/cmux.json"

echo "== cmux-configuration verify =="
chk "ghostty: managed block present"      grep -q 'cmux-config:ghostty' "$GC"
chk "ghostty: theme = Catppuccin Mocha"   grep -q 'theme = Catppuccin Mocha' "$GC"
chk "ghostty: command = /bin/zsh -l"      grep -q 'command = /bin/zsh -l' "$GC"
# 2026-07-04 refactor: install.sh no longer injects inline shell blocks; the
# dotfiles now SOURCE the repo block files directly. Verify that wiring instead.
chk "fish:    sources managed block"      grep -q 'blocks/config.fish.cmux.fish' "$FC"
chk "zsh:     sources managed block"      grep -q 'blocks/zshrc.cmux.sh' "$ZC"
chk "zsh:     SHELL override in block"    grep -q 'export SHELL=/bin/zsh' "$REPO/blocks/zshrc.cmux.sh"
chk "cmux.json present"                    test -f "$CJ"
. "$REPO/lib/cmux-cli.sh"
if cmux_present; then
  CMUX_BIN="$(cmux_cli_path)"
  chk "cmux.json valid (config doctor)"   bash -c "'$CMUX_BIN' config doctor 2>&1 | grep -q 'JSONC syntax is valid'"
fi
echo
echo "PASS=$pass FAIL=$fail"
[ "$fail" -eq 0 ]
