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

## Grok — completely isolated from all other agents

Grok runs with `HOME=~/.grok-isolated-home` via a wrapper
([`scripts/grok-isolated-wrapper.sh`](../scripts/grok-isolated-wrapper.sh),
installed at `~/.local/bin/grok`). On **every launch** the wrapper re-mirrors the
real `$HOME` into the isolated home as symlinks, **excluding every other agent's
config** so grok cannot discover their skills/plugins/MCPs/hooks/rules.

What's hidden (`HIDE_PATTERNS`): `.claude*` (incl. `CLAUDE.md`, `.claude.json*`,
`.claude-mem`, `.claude-server-commander*`), `AGENTS.md`, `.agents` (the universal
skills dir), `.codex* .cursor .gemini .antigravity* .factory .cherrystudio
.agent-browser .lmstudio* .aider .copilot .kiro …`. `~/.config` is **rebuilt
selectively** — non-agent tool configs (git, gh, fish, cmux, ghostty, nvim, …) are
symlinked, but agent/AI subdirs (`amp opencode goose ai-builder tmuxai caveman`)
are omitted.

What grok keeps: its **own** `~/.grok/{skills,hooks,installed-plugins,worktrees}`,
shell + dev tooling, `.aikido` (safe-chain), `.ssh`, `.gitconfig`, and ordinary
project dirs (e.g. a cloned repo) — so it stays fully functional.

> **Why the wrapper, not manual deletion:** the wrapper re-creates the mirror on
> every launch, so hand-removing a symlink reverts on next run. Isolation must be
> maintained in `HIDE_PATTERNS` / `CONFIG_HIDE`. Refresh without launching grok:
> `GROK_WRAPPER_SYNC_ONLY=1 grok`.

Grok's cmux hook (`cmux hooks grok install` → `~/.grok/hooks/cmux-session.json`)
and its cmux skills (`~/.grok/skills/`) are grok-specific — zero claude references.

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
