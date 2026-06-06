# cmux-configuration — managed fish block.
# In cmux, run zsh. cmux launches the OS login shell (fish), so we switch to zsh here.
# Defensive: only triggers when cmux actually launched fish; harmless if cmux launched
# zsh directly via Ghostty `command`. Gated on CMUX_BUNDLE_ID so other terminals stay fish.
if status is-interactive; and set -q CMUX_BUNDLE_ID; and test -z "$ZSH_VERSION"
    set -gx SHELL /bin/zsh
    exec /bin/zsh -l
end
