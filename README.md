# cmux-configuration

Portable, version-controlled configuration for [**cmux**](https://cmux.com) — the
macOS-native terminal for orchestrating AI coding agents (Claude Code, Codex,
OpenCode, Grok) — alongside standalone [Ghostty](https://ghostty.org).

> **Goal:** clone on any Mac, run the scripts, and reproduce the full setup —
> shells, theme, keybindings, notifications, skills, agent integrations,
> worktrees — with **zero personal data** in the repo (or its git history).

![Architecture](diagrams/01-architecture.png)

*cmux and Ghostty share one ghostty config (so the **theme** is shared), but route
**shells** differently: Ghostty honors `command` → zsh + tmux; cmux ignores it and
is steered to zsh via the fish/zsh blocks. OS/other terminals stay fish.*

## What it sets up

| Area | Result | Docs |
|------|--------|------|
| **Shells** | OS/other = fish · **cmux = zsh** (all the way) · Ghostty = zsh + tmux `work` (detach → shell) | — |
| **Theme** | Catppuccin Mocha terminal (shared) + Catppuccin sidebar/dark chrome in cmux | — |
| **Keybindings** | hybrid tmux `Ctrl+B` prefix for pane/split/window nav | [keybindings](docs/keybindings.md) |
| **Notifications** | desktop alert + sound + badges on agent events | [notifications](docs/notifications.md) |
| **Skills** | agents can *drive* cmux (workspaces, panes, settings, browser) | [skills](docs/skills.md) |
| **Agents** | Claude / Codex / OpenCode / Grok hooks + team launchers | [agents](docs/agents.md) |
| **Worktrees** | parallel agents on isolated branches, one workspace each | [worktrees](docs/worktrees.md) |

## Setup

```sh
git clone <repo> ~/code/cmux-configuration
cd ~/code/cmux-configuration

./install.sh                    # 1. config: injects managed blocks + cmux.json (offline, auto-backup)
./verify.sh                     # 2. confirm
./scripts/install-agent-hooks.sh  # 3. agent lifecycle hooks (Codex/OpenCode/Grok; Claude auto)
./scripts/install-skills.sh       # 4. agent-control skills (network; your safe-chain reviews it)
```
Then `cmux reload-config` (+ new tab) and quit/reopen Ghostty. Undo: `./uninstall.sh`.

## How it works

cmux and Ghostty read your personal `~/.config/ghostty/config`; your shell rc files
hold your own lines and secrets. So this repo does **not** symlink whole files — it
injects **marker-delimited managed blocks** (safe to re-apply / remove):

```
# >>> cmux-config:zshrc >>>
…managed lines…
# <<< cmux-config:zshrc <<<
```

`cmux.json` is cmux-only (no secrets), so it's managed wholesale. Every change
backs up the target first (`*.cmux-bak.<timestamp>`).

## Layout

```
install.sh · uninstall.sh · verify.sh     # apply / remove / check (idempotent, auto-backup)
lib/inject.sh                             # marker-block injector
blocks/                                   # source-of-truth managed blocks (zsh · fish · ghostty)
config/cmux/cmux.json                     # cmux app settings (theme · sidebar · keybinds · notifs)
config/ghostty/config.template            # full ghostty config for fresh machines
scripts/install-agent-hooks.sh · install-skills.sh · worktree.sh
diagrams/                                 # D2 architecture diagram (source + svg + png)
docs/                                     # per-area guides — see docs/README.md
```

## Privacy

Public repo, **no PII**: no names, emails, hostnames, secrets, or `/Users/<name>/`
paths — enforced by `.gitignore` and the managed-block design. Validated by a
full-repo sweep on every commit.

## License

[MIT](LICENSE).
