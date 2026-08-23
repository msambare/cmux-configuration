# cmux-configuration — managed fish block.
# In cmux, run zsh. cmux launches the OS login shell; since 2026-08-23 that IS zsh on
# the Mac, so this block is now a DORMANT SAFETY NET — it only fires if fish ever ends
# up as the login shell again (or on a host where it still is). Keep it: it costs
# nothing and it is the thing that made cmux work while fish was login shell.
# Defensive: only triggers when cmux actually launched fish; harmless if cmux launched
# zsh directly. Gated on CMUX_BUNDLE_ID so other terminals are untouched.
if status is-interactive; and set -q CMUX_BUNDLE_ID; and test -z "$ZSH_VERSION"
    set -gx SHELL /bin/zsh
    exec /bin/zsh -l
end
