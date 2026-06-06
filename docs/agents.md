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

## Grok + isolated HOME (independent of claude)

Grok runs with `HOME=~/.grok-isolated-home`, which **deliberately has no `.claude`**
— grok cannot import claude/claude-code skills, rules, hooks, or plugins. Grok is
fully self-contained: its own `~/.grok/{skills,hooks,installed-plugins,worktrees}`.

Nothing here couples grok to claude:
- **Hook** — `cmux hooks grok install` writes a **grok-specific** hook to
  `~/.grok/hooks/cmux-session.json` (it calls `cmux hooks grok …` / `--source grok`,
  no claude references). The isolated HOME's `.grok → ~/.grok` symlink makes it
  visible to grok; no separate install needed.
- **Skills** — installed into grok's own `~/.grok/skills/` (see
  [skills.md](skills.md)), never read from claude's dir.

So grok's cmux integration is notification/Feed wiring only — grok keeps its own
config and stays independent of claude. (Verified: `ls ~/.grok-isolated-home`
shows no `.claude`.)

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
