# Skills — let agents drive cmux

cmux ships **skills**: structured instructions that teach an AI coding agent how
to control cmux through its CLI/socket. With these installed, Claude Code, Codex,
OpenCode, and Grok can open workspaces, split panes, change settings, automate
the embedded browser, and self-diagnose — i.e. the agents operate cmux for you.

Install: [`scripts/install-skills.sh`](../scripts/install-skills.sh) →
`npx skills add manaflow-ai/cmux -g -y`.

> Runs through your **safe-chain** wrapper — run it interactively so package
> installs are reviewed. Not run automatically by `install.sh` (which stays
> offline). Skills are additive files in each agent's `skills/` dir; remove by
> deleting the `cmux-*` dirs.

## Included skills

| Skill | Teaches the agent to… |
|-------|------------------------|
| `cmux` (core) | windows, workspaces, panes, surfaces, focus, move, reorder, routing |
| `cmux-workspace` | scoped automation of the current workspace/surface, send input |
| `cmux-settings` | read/write/validate `~/.config/cmux/cmux.json` safely |
| `cmux-customization` | actions, plus-button, tab-bar, layouts, Dock, Feed hooks, shortcuts |
| `cmux-diagnostics` | health-check CLI/socket/hooks/session-restore/agent binaries |
| `cmux-browser` | automate cmux webview surfaces (snapshot refs, DOM, screenshots) |
| `cmux-markdown` | open markdown in cmux's formatted live-reload panel |

## Per-agent locations

The `skills` CLI installs to each detected agent's skills dir (e.g.
`~/.codex/skills`, `~/.claude/skills`, `~/.config/opencode/skills`). **Grok**
runs with `HOME=~/.grok-isolated-home`, whose dotfiles symlink to your real home,
so a global install reaches it too.

## Verify

```sh
ls ~/.codex/skills ~/.claude/skills 2>/dev/null | grep -i cmux
```
