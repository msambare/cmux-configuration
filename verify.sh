#!/usr/bin/env bash
# cmux-configuration — verify the managed config is in place and valid.
set -uo pipefail
pass=0; fail=0
chk() { local d="$1"; shift; if "$@" >/dev/null 2>&1; then printf 'OK    %s\n' "$d"; pass=$((pass+1)); else printf 'FAIL  %s\n' "$d"; fail=$((fail+1)); fi; }

GC="$HOME/.config/ghostty/config"; FC="$HOME/.config/fish/config.fish"
ZC="$HOME/.zshrc"; CJ="$HOME/.config/cmux/cmux.json"

echo "== cmux-configuration verify =="
chk "ghostty: managed block present"      grep -q 'cmux-config:ghostty' "$GC"
chk "ghostty: theme = Catppuccin Mocha"   grep -q 'theme = Catppuccin Mocha' "$GC"
chk "ghostty: command = /bin/zsh -l"      grep -q 'command = /bin/zsh -l' "$GC"
chk "fish:    managed block present"      grep -q 'cmux-config:fish' "$FC"
chk "zsh:     managed block present"      grep -q 'cmux-config:zshrc' "$ZC"
chk "zsh:     SHELL override present"      grep -q 'export SHELL=/bin/zsh' "$ZC"
chk "cmux.json present"                    test -f "$CJ"
if command -v cmux >/dev/null 2>&1; then
  chk "cmux.json valid (config doctor)"   bash -c "cmux config doctor 2>&1 | grep -q 'JSONC syntax is valid'"
fi
echo
echo "PASS=$pass FAIL=$fail"
[ "$fail" -eq 0 ]
