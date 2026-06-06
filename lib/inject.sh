#!/usr/bin/env bash
# cmux-configuration — idempotent marker-block injection helpers.
# Markers:  # >>> <marker> >>>   ...   # <<< <marker> <<<
# `#` comments are valid in zsh, fish, and ghostty config, so one scheme covers all.

_cmux_ts() { date +%Y%m%d-%H%M%S; }

cmux_backup() { # file
  local file="$1"
  [ -f "$file" ] && cp "$file" "$file.cmux-bak.$(_cmux_ts)" || true
}

cmux_remove_block() { # file marker
  local file="$1" marker="$2"
  [ -f "$file" ] || return 0
  local start="# >>> ${marker} >>>" end="# <<< ${marker} <<<"
  awk -v s="$start" -v e="$end" '
    $0==s { skip=1; next }
    skip && $0==e { skip=0; next }
    !skip { print }
  ' "$file" > "$file.cmuxtmp" && mv "$file.cmuxtmp" "$file"
}

cmux_inject() { # file marker blockfile
  local file="$1" marker="$2" blockfile="$3"
  local start="# >>> ${marker} >>>" end="# <<< ${marker} <<<"
  mkdir -p "$(dirname "$file")"; touch "$file"
  cmux_backup "$file"
  cmux_remove_block "$file" "$marker"
  { printf '\n%s\n' "$start"; cat "$blockfile"; printf '%s\n' "$end"; } >> "$file"
}
