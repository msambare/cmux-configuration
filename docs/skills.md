# Skills — let agents drive cmux

cmux ships **skills**: structured instructions that teach an AI coding agent to
control cmux through its CLI/socket (workspaces, panes, settings, browser,
diagnostics). Install: [`scripts/install-skills.sh`](../scripts/install-skills.sh).

> **Each agent gets skills in its OWN dir — they are not shared between agents.**

## Per-agent install (isolation matters)

| Agent | Skills dir | How |
|-------|-----------|-----|
| Claude Code | `~/.claude/skills` | `npx skills add manaflow-ai/cmux -g` |
| Codex | `~/.codex/skills` | (same) |
| OpenCode | `~/.config/opencode/skills` | (same) |
| **Grok** | **`~/.grok/skills`** | **git copy into grok's own dir** |

### Grok is isolated from claude/claude-code

Grok runs with `HOME=~/.grok-isolated-home`, which **has no `.claude`** — grok
cannot read claude's skills/rules/plugins, by design. So grok's cmux skills are
installed **directly into its own `~/.grok/skills/`** (the script git-clones the
cmux `skills/` dir and copies the `cmux*` skills there). Grok never reads claude's
skill dir. (Earlier drafts of this doc wrongly implied grok picked skills up via
claude/codex symlinks — it does not.)

## Included cmux skills

`cmux` (core) · `cmux-workspace` · `cmux-settings` · `cmux-customization`
(incl. **worktree-agents**) · `cmux-diagnostics` · `cmux-browser` ·
`cmux-markdown` · `cmux-keyboard-shortcuts`.

## Notes

- The `npx` path runs through your **safe-chain** wrapper — run the script
  interactively so package installs are reviewed.
- Grok also has a **native worktrees** feature (`~/.grok/worktrees`) independent
  of cmux. See [worktrees.md](worktrees.md).

## Verify

```sh
ls ~/.claude/skills ~/.codex/skills ~/.config/opencode/skills 2>/dev/null | grep -i cmux
ls ~/.grok/skills | grep -i cmux     # grok's own, isolated
```
