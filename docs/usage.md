# Using your configured cmux

How to drive the features this repo enables. Config details + rationale live in the
per-area docs (linked); this is the **how-to**. Apply changes with
`cmux reload-config` (or `⌘⇧,`) + a new tab; restart Ghostty for its side.

---

## 1. Shells — what you'll see

- **New cmux tab** → **zsh** (prompt is your normal one). `$SHELL` is zsh; anything
  you spawn (sub-shells, `vim :terminal`, tools) stays zsh.
- **Ghostty (Dock)** → drops you straight into **tmux `work`** (zsh inside). The
  tmux status bar is your cue you're in tmux.
  - Detach: **`Ctrl+B d`** → lands in a plain shell, Ghostty stays open.
  - Re-attach: `tmux a -t work`. New named session: `tmux new -s <name>`.
- **Terminal.app / iTerm / elsewhere** → **fish** (your OS default), untouched.

Check which shell you're in: `echo $ZSH_VERSION` (set = zsh) · `ps -p $$ -o comm=`.
(`$SHELL` is your *login* shell = fish; it doesn't track the running shell.)

## 2. Theme

Catppuccin Mocha everywhere; cmux sidebar tinted to match. To change: edit
`config/cmux/cmux.json` (`sidebarAppearance.tintColor`) and/or the ghostty `theme`
line, then `./install.sh` → `cmux reload-config`. Sidebar shade ladder + sound list
are in [notifications.md](notifications.md)/[keybindings.md](keybindings.md).

## 3. Keybindings — tmux muscle memory inside cmux

Press **`Ctrl+B`**, release, then the key:

| Do this | Keys |
|---|---|
| Split right / down | `⌃B %` / `⌃B "` |
| Move between panes | `⌃B ←` `→` `↑` `↓` |
| Zoom pane (toggle) | `⌃B z` |
| New tab / next / prev | `⌃B c` / `⌃B n` / `⌃B p` |
| Jump to tab N | `⌃B 1`…`9` |
| Close tab · rename | `⌃B x` · `⌃B ,` |
| Copy mode · equalize | `⌃B [` · `⌃B space` |

App-level stays Cmd: `⌘⇧P` palette · `⌘,` settings · `⌘B` sidebar · `⌘N` new
workspace · `⌘P` workspace switcher · `⌘F` find. Full table + how to rebind:
[keybindings.md](keybindings.md).

## 4. Notifications

You get a desktop alert + **Glass** chime + dock badge + sidebar pane-ring when a
background workspace wants attention (agent finished / needs input). Alerts are
**suppressed** for whatever workspace is currently focused — so you're only pinged
about work you're *not* looking at; notifying workspaces float toward the top of the
sidebar.

Fire your own (from any script/agent in cmux):
```sh
cmux notify --title "Build" --subtitle "api" --body "tests green"
```
Quieter/louder: change `notifications.sound` in `cmux.json` (or `none`). Details +
hook/command fan-out: [notifications.md](notifications.md).

## 5. Skills — make agents operate cmux for you

All four agents carry the cmux skills, so you can ask in plain language and they
drive cmux via its CLI. Examples to type at an agent:

- *"Open a workspace at ~/code/api, split right; run `npm run dev` on the left and
  `npm test --watch` on the right."*
- *"Set a sidebar status 'deploying' with a hammer icon, then clear it when done."*
  (agent runs `cmux set-status …` / `cmux clear-status …`)
- *"Open plan.md in the markdown viewer."* (`cmux markdown open`)
- *"Run cmux diagnostics and tell me what's broken."* (cmux-diagnostics skill)
- *"Snapshot the browser surface and click the login button."* (cmux-browser skill)

What each skill grants: [skills.md](skills.md). The agent picks the right cmux CLI
calls itself.

## 6. Agent teams — many agents in parallel

Launch a team; each agent gets its own split, auto-arranged:

| Command | Runs |
|---|---|
| `cmux claude-teams` | Claude Code with experimental agent teams |
| `cmux codex-teams` / `cmux omx` | Codex / oh-my-codex (30+ roles) |
| `cmux omo` | OpenCode / oh-my-opencode (Claude+GPT+Gemini+Grok as agents) |
| `cmux omc` | oh-my-claudecode |

Pass-through args work, e.g. `cmux omx --high`, `cmux omo --continue`. Each agent's
stop/needs-input fires a notification (hooks). Matrix + prereqs:
[agents.md](agents.md).

## 7. Worktrees — a branch + workspace per agent

```sh
scripts/worktree.sh feature-x            # new branch off HEAD
scripts/worktree.sh hotfix origin/main   # new branch off a base
scripts/worktree.sh existing-branch      # attach an existing branch
```
Each call makes `«repo».worktrees/«branch»/` and (inside cmux) opens it as a
workspace. Then launch an agent in each → parallel work, isolated branches, no
collisions. Remove: `git -C <repo> worktree remove «repo».worktrees/«branch»`.
Tip: alias `wt='~/code/cmux-configuration/scripts/worktree.sh'`. One-click
plus-button variant: [worktrees.md](worktrees.md).

## 8. Grok — isolated

Just run `grok`. The wrapper runs it in an isolated HOME with every other agent's
config hidden; it uses only its own skills/hooks. Refresh isolation without
launching: `GROK_WRAPPER_SYNC_ONLY=1 grok`. Details: [agents.md](agents.md).

---

## A full parallel-agents session (ties it together)

```sh
# 1. three isolated branches, each its own cmux workspace
wt feature-auth ; wt fix-flaky-test ; wt refactor-db
# 2. in each workspace, start an agent (or a team)
#    e.g. claude in feature-auth, codex (omx) in fix-flaky-test, grok in refactor-db
# 3. work elsewhere — when any agent finishes/needs you, a notification + sidebar
#    badge pulls that workspace to the top (you're not pinged for the focused one)
# 4. ⌃B n / ⌃B 1-9 to hop between them; ⌃B % to split a pane for logs/tests
```

## Activate / reload cheatsheet

| Changed | Apply |
|---|---|
| `cmux.json` (keys, notifs, theme) | `cmux reload-config` or `⌘⇧,` + new tab |
| ghostty config | quit (`⌘Q`) + reopen Ghostty |
| shell blocks (`.zshrc`/`config.fish`) | open a **new** tab/window |
| agent hooks / skills | take effect on the agent's next run |
