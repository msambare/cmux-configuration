# cmux-configuration — managed zsh block.

# (1) Inside cmux: force $SHELL=zsh so sub-shells/tools spawned in cmux stay zsh.
[ -n "$CMUX_BUNDLE_ID" ] && export SHELL=/bin/zsh

# (2) Inside cmux: load cmux's zsh shell-integration (powers sidebar cwd/git/branch).
#     We launch zsh outside cmux's own ZDOTDIR wrapper, so we source the integration here.
if [ -n "$CMUX_BUNDLE_ID" ] && [ -n "$CMUX_SHELL_INTEGRATION_DIR" ]; then
  [ "${CMUX_LOAD_GHOSTTY_ZSH_INTEGRATION:-0}" = "1" ] && [ -r "$CMUX_SHELL_INTEGRATION_DIR/ghostty-integration.zsh" ] && source "$CMUX_SHELL_INTEGRATION_DIR/ghostty-integration.zsh"
  [ "${CMUX_SHELL_INTEGRATION:-1}" != "0" ] && [ -r "$CMUX_SHELL_INTEGRATION_DIR/cmux-zsh-integration.zsh" ] && source "$CMUX_SHELL_INTEGRATION_DIR/cmux-zsh-integration.zsh"
fi

# (3) Standalone Ghostty.app ONLY (not cmux): auto-attach tmux 'work'.
#     Non-exec, so detaching (Ctrl+B d) drops to this shell instead of quitting Ghostty.
#     Not inside an opsh secrets shell (nested zsh) — that would attach a second client.
#     If no tmux server is running, start it HERE via tmux-startup.sh (work/cheers-prod/
#     cheers-dev), never from launchd: macOS TCC attributes a launchd-spawned server to
#     tmux itself, so `op` in its panes is denied the 1Password group container and
#     reports "No accounts configured". A Ghostty-spawned server inherits Ghostty's grant.
if [ -z "$CMUX_BUNDLE_ID" ] && [ -z "$TMUX" ] && [ -z "$IN_OP_SHELL" ] && [[ $- == *i* ]] && { [ "$TERM_PROGRAM" = "ghostty" ] || [ -n "$GHOSTTY_RESOURCES_DIR" ] || [ -n "$GHOSTTY_BIN_DIR" ]; }; then
  tmux has-session 2>/dev/null || { [ -x "$HOME/.local/bin/tmux-startup.sh" ] && "$HOME/.local/bin/tmux-startup.sh" >/dev/null 2>&1; }
  tmux new-session -A -s work
fi
