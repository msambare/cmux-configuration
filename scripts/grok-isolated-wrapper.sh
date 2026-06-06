#!/usr/bin/env bash
# grok — isolated wrapper around Grok Build
#
# Keeps Grok fully independent of claude/claude-code AND every other coding agent.
# Grok must not discover any other agent's skills/plugins/MCPs/hooks/rules.
#
# Strategy:
#   - Run grok with $HOME -> $FAKE_HOME (~/.grok-isolated-home)
#   - $FAKE_HOME mirrors real $HOME as symlinks EXCEPT agent/AI paths (HIDE_PATTERNS)
#   - ~/.config is rebuilt as a real dir with ONLY non-agent subdirs symlinked
#   - $GROK_HOME -> real ~/.grok so grok's own auth/config/skills/hooks still work
#
# Refresh isolation without launching grok:  GROK_WRAPPER_SYNC_ONLY=1 grok
# Install: ~/.local/bin/grok (must precede ~/.grok/bin in $PATH).

set -euo pipefail

# Real $HOME from passwd (not $HOME, which may already be redirected)
REAL_HOME="$(dscl . -read /Users/$(id -un) NFSHomeDirectory 2>/dev/null | awk '{print $2}')"
[[ -z "${REAL_HOME:-}" ]] && REAL_HOME="$(eval echo "~$(id -un)")"
FAKE_HOME="$REAL_HOME/.grok-isolated-home"

# Resolve the real grok binary (bypass the ~/.grok/bin/grok symlink chain)
if [[ -L "$REAL_HOME/.grok/bin/grok" ]]; then
    target="$(readlink "$REAL_HOME/.grok/bin/grok")"
    case "$target" in
        /*) GROK_BIN="$target" ;;
        *)  GROK_BIN="$(cd "$REAL_HOME/.grok/bin" && cd "$(dirname "$target")" && pwd)/$(basename "$target")" ;;
    esac
elif [[ -x "$REAL_HOME/.grok/bin/grok" ]]; then
    GROK_BIN="$REAL_HOME/.grok/bin/grok"
else
    echo "grok-wrapper: cannot find grok binary at $REAL_HOME/.grok/bin/grok" >&2
    exit 127
fi

# Top-level $REAL_HOME entries Grok must NOT see (glob patterns).
HIDE_PATTERNS=(
    '.claude*'                          # .claude, .claude.json(.bak/.tmp/.lock), .claude-mem, .claude-server-commander*
    'CLAUDE.md' 'AGENTS.md'             # foreign agent instruction files
    '.agents'                           # universal ~/.agents/skills shared across agents
    '.grok-isolated-home'
    '.config'                           # rebuilt selectively below
    '.codex' '.codexbar' '.cursor' '.gemini'
    '.antigravity' '.antigravity-ide' '.factory' '.cherrystudio' '.agent-browser'
    '.lmstudio' '.lmstudio-home-pointer'
    '.aider' '.continue' '.cline' '.windsurf' '.copilot' '.kiro' '.qoder'
    '.codebuddy' '.rovodev' '.pi' '.omp' '.amp' '.goose'
)
# ~/.config subdirs (other agents / AI tools) Grok must NOT see.
CONFIG_HIDE=(amp opencode goose ai-builder tmuxai caveman)

matches_hide() {            # $1=basename -> 0 if it should be hidden
    local b="$1" p
    for p in "${HIDE_PATTERNS[@]}"; do
        if [[ "$b" == $p ]]; then return 0; fi
    done
    return 1
}

sync_fake_home() {
    mkdir -p "$FAKE_HOME"
    shopt -s dotglob nullglob
    # 1) remove any now-hidden symlinks already present (cleanup of prior leaks)
    for dst in "$FAKE_HOME"/*; do
        b="${dst##*/}"
        if matches_hide "$b" && [[ -L "$dst" ]]; then rm -f "$dst"; fi
    done
    # 2) add missing non-hidden symlinks (new dotfiles auto-picked-up)
    for src in "$REAL_HOME"/*; do
        b="${src##*/}"
        if matches_hide "$b"; then continue; fi
        dst="$FAKE_HOME/$b"
        if [[ -e "$dst" || -L "$dst" ]]; then continue; fi
        ln -s "$src" "$dst"
    done
    # 3) ~/.config rebuilt as a real dir with only non-agent subdirs symlinked
    rm -rf "$FAKE_HOME/.config"
    mkdir -p "$FAKE_HOME/.config"
    for csrc in "$REAL_HOME/.config"/*; do
        cb="${csrc##*/}"
        chide=0
        for h in "${CONFIG_HIDE[@]}"; do
            if [[ "$cb" == "$h" ]]; then chide=1; break; fi
        done
        if [[ $chide -eq 1 ]]; then continue; fi
        ln -s "$csrc" "$FAKE_HOME/.config/$cb"
    done
    shopt -u dotglob nullglob
}

sync_fake_home

if [[ "${GROK_WRAPPER_SYNC_ONLY:-0}" == "1" ]]; then
    echo "grok isolation re-synced: $FAKE_HOME"
    exit 0
fi

export HOME="$FAKE_HOME"
export GROK_HOME="$REAL_HOME/.grok"

# Self-heal: grok records $HOME-based plugin paths; rewrite them back to real ~/.grok.
REG="$REAL_HOME/.grok/installed-plugins/registry.json"
[[ -f "$REG" ]] && sed -i "" "s#$FAKE_HOME/.grok/#$REAL_HOME/.grok/#g" "$REG"

exec "$GROK_BIN" "$@"
