# Current State — cmux on this machine (baseline)

Snapshot of what cmux looks like *before* this repo customizes anything.
No PII in this file by design (machine paths/identities are referenced by
category only).

## Install

- **cmux** `0.64.13 (93)` — native macOS terminal app (Ghostty/libghostty engine), by Manaflow.
- Installed via **Homebrew cask**: `brew tap manaflow-ai/cmux && brew install --cask cmux`.
- Auto-updates in-app via Sparkle.
- Binary: `/opt/homebrew/bin/cmux` → `/Applications/cmux.app/...`.
- Bundle id: `com.cmuxterm.app`.

## What cmux actually is

A macOS-native terminal purpose-built to run many AI coding agents in parallel:
vertical workspace sidebar, split panes, embedded browser, markdown viewer,
notification feed, and a **Unix-socket control API** (the `cmux` CLI wraps it)
so agents can drive the app programmatically.

## Two config layers

| Layer | File | Format | Controls |
|-------|------|--------|----------|
| cmux app | `~/.config/cmux/cmux.json` (project override: `.cmux/cmux.json`) | JSONC | app, notifications, sidebar, shortcuts, automation, browser, customCommands |
| terminal | `~/.config/ghostty/config` | key=value | font, theme, clipboard, tmux/terminfo, keybinds |

`cmux reload-config` (or `Cmd+Shift+,`) reloads **both** live, no restart.

## What is configured today

- **cmux.json / settings.json**: **factory default templates — everything commented out.** Zero cmux-level customization. (Captured verbatim in `config/cmux/`.)
- **Ghostty config**: the only real customization — Apple System Colors theme, `term=screen-256color` (tmux compat), zsh shell-integration, SF Mono 13, clipboard/selection tuning, a few cmd keybinds. (Sanitized template in `config/ghostty/config`.)
- **macOS plist** (`com.cmuxterm.app.plist`): GUI-set UI state (window geometry, sidebar preset/opacity, appearance). Machine state — **not** portable, **not** committed.

## What is NOT configured (all default / absent)

| Area | State |
|------|-------|
| Keybindings | 100% cmux defaults (cmd-based). No tmux-prefix chords. |
| Notifications | Defaults (dock badge, pane flash, default sound). No custom command/hooks. |
| Agent hooks | None installed (`cmux hooks <agent> install` never run). |
| Skills | **Not installed** in `~/.codex/skills`, `~/.claude/skills`, opencode, or grok homes. |
| Worktrees | No custom commands / worktree automation configured. |
| Socket control mode | `cmuxOnly` (default). |
| Telemetry | `sendAnonymousTelemetry: true` (default, opt-out available). |

## Agent surface (from `cmux --help`)

Relevant subcommands already available in the installed binary:

- `cmux hooks setup|uninstall [--agent <name>]` and `cmux hooks <agent> install|uninstall|event` — wire agent lifecycle → cmux notifications/feed.
- `cmux claude-teams`, `cmux codex-teams`, `cmux omc` (oh-my-claudecode), `cmux omx` (oh-my-codex), `cmux omo` (oh-my-opencode) — multi-agent launchers using a tmux-shim.
- `cmux notify`, `cmux set-status`, `cmux set-progress`, `cmux log`, `cmux send`, `cmux send-key`, workspace/surface/window verbs — the programmatic control surface for agents.
- `cmux themes`, `cmux config doctor|check|validate`, `cmux settings`.

## PII handled (excluded from repo)

Machine state files (session JSON scrollback, event logs, plist, caches) contain
real identities — colleague names/emails, a company domain, production hostnames,
a third party's SSH public key, and `/Users/<username>/` paths. **None of these
are copied into the repo.** `.gitignore` blocks the file classes; the Ghostty
template strips the one PII path comment and machine-specific window geometry.
