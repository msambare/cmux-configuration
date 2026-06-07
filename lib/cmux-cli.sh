#!/usr/bin/env bash
# cmux-configuration — locate the cmux CLI.
#
# cmux.app ships its CLI at  <app>/Contents/Resources/bin/cmux  but does NOT
# always symlink it onto $PATH (the in-app "install CLI" step may never have
# run on a fresh machine). These helpers let every script work whether or not
# cmux is on $PATH; install.sh uses them to create a $PATH symlink.
#
# Portable + no personal data: only $HOME and the standard /Applications path.

# Print a usable cmux CLI path: $PATH first, then the app bundle. Returns 1 if none.
cmux_cli_path() {
  if command -v cmux >/dev/null 2>&1; then
    command -v cmux
    return 0
  fi
  local c
  for c in "${CMUX_APP_CLI:-}" \
           "/Applications/cmux.app/Contents/Resources/bin/cmux" \
           "$HOME/Applications/cmux.app/Contents/Resources/bin/cmux"; do
    [ -n "$c" ] && [ -x "$c" ] && { printf '%s\n' "$c"; return 0; }
  done
  return 1
}

# True if a cmux CLI is available anywhere (PATH or app bundle).
cmux_present() { cmux_cli_path >/dev/null 2>&1; }

# Invoke the resolved cmux CLI, forwarding all args. Returns 127 if none found.
cmux_cli() {
  local bin
  bin="$(cmux_cli_path)" || return 127
  "$bin" "$@"
}
