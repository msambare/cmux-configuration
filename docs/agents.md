# Agent integrations

Wires cmux to your four agents so they (a) report lifecycle to cmux's
notifications + Feed and (b) can be launched as parallel "teams" inside cmux.
Hooks installed by [`scripts/install-agent-hooks.sh`](../scripts/install-agent-hooks.sh)
(`cmux hooks <agent> install`); skills by [`install-skills.sh`](../scripts/install-skills.sh).

## Matrix

| Agent | Lifecycle hook | Generated | Team launcher |
|-------|----------------|-----------|---------------|
| **Claude Code** | **auto** (cmux's `claude` wrapper) | — | `cmux claude-teams` |
| **Codex** | `cmux hooks codex install` | `~/.codex/hooks.json`, `config.toml` trust | `cmux codex-teams` · `cmux omx` (oh-my-codex) |
| **OpenCode** | `cmux hooks opencode install` | `~/.config/opencode/plugins/cmux-session.js`, `cmux-feed.js` | `cmux omo` (oh-my-opencode) |
| **Grok** | `cmux hooks grok install` | `~/.grok/hooks/cmux-session.json` | via `cmux omo` (Grok as a model) |

Hooks fire on stop / needs-input → cmux raises a notification (see
[`docs/notifications.md`](notifications.md)); nested sub-agent noise is suppressed
by `automation.suppressSubagentNotifications` (cmux default).

## Grok + isolated HOME

You run Grok with `HOME=~/.grok-isolated-home`. That directory's `.grok` is a
symlink to your real `~/.grok`, so the hook installed at `~/.grok/hooks/` is
visible to isolated Grok automatically — no separate install needed. (If you ever
point Grok at a non-symlinked HOME, re-run with that `HOME` set.)

## Team launchers (parallel agents inside cmux)

cmux can run multi-agent "teams", each agent in its own split, via a tmux-compat
shim: `cmux claude-teams`, `cmux codex-teams`, `cmux omc` (oh-my-claudecode),
`cmux omx` (oh-my-codex), `cmux omo` (oh-my-opencode). Prereqs per launcher are in
cmux's docs (e.g. `npm i -g oh-my-codex`).

## Uninstall

```sh
cmux hooks codex uninstall
cmux hooks opencode uninstall
cmux hooks grok uninstall
# or all at once:
cmux hooks uninstall
```
