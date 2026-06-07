# cmux-configuration — managed zsh block.

# (1) Inside cmux: force $SHELL=zsh so sub-shells/tools spawned in cmux stay zsh.
[ -n "$CMUX_BUNDLE_ID" ] && export SHELL=/bin/zsh

# (2) Inside cmux: load cmux's zsh shell-integration (powers sidebar cwd/git/branch).
#     We launch zsh outside cmux's own ZDOTDIR wrapper, so we source the integration here.
if [ -n "$CMUX_BUNDLE_ID" ] && [ -n "$CMUX_SHELL_INTEGRATION_DIR" ]; then
  [ "${CMUX_LOAD_GHOSTTY_ZSH_INTEGRATION:-0}" = "1" ] && [ -r "$CMUX_SHELL_INTEGRATION_DIR/ghostty-integration.zsh" ] && source "$CMUX_SHELL_INTEGRATION_DIR/ghostty-integration.zsh"
  [ "${CMUX_SHELL_INTEGRATION:-1}" != "0" ] && [ -r "$CMUX_SHELL_INTEGRATION_DIR/cmux-zsh-integration.zsh" ] && source "$CMUX_SHELL_INTEGRATION_DIR/cmux-zsh-integration.zsh"
fi

# (2b) Inside cmux: on reopen-after-quit, cmux replays the pre-quit terminal buffer AND
#      relaunches the shell -> two stacked prompts (one stale, one live). Wipe the restored
#      screen + scrollback once so the relaunched shell shows a SINGLE clean prompt.
#      Interactive cmux shells only; a no-op on a fresh pane (already empty).
if [ -n "$CMUX_BUNDLE_ID" ] && [[ $- == *i* ]]; then
  printf '\033[2J\033[3J\033[H'
fi

# (3) Standalone Ghostty.app ONLY (not cmux): auto-attach tmux 'work'.
#     Non-exec, so detaching (Ctrl+B d) drops to this shell instead of quitting Ghostty.
if [ -z "$CMUX_BUNDLE_ID" ] && [ -z "$TMUX" ] && [[ $- == *i* ]] && { [ "$TERM_PROGRAM" = "ghostty" ] || [ -n "$GHOSTTY_RESOURCES_DIR" ] || [ -n "$GHOSTTY_BIN_DIR" ]; }; then
  tmux new-session -A -s work
fi
