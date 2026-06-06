# cmux-configuration

Portable, version-controlled configuration for [**cmux**](https://cmux.com) — the
macOS-native terminal for orchestrating AI coding agents (Claude Code, Codex,
OpenCode, Grok) — alongside standalone [Ghostty](https://ghostty.org).

> **Goal:** clone on any Mac, run `./install.sh`, and reproduce the full setup —
> shells, theme, tmux, keybindings, notifications, skills, agent integrations,
> worktrees — with **zero personal data** baked in (not even in git history).

**Status:** 🚧 building. Foundation proven; portable spine in place. See
[`docs/ROADMAP.md`](docs/ROADMAP.md).

## What it sets up

- **Shells** — OS/other terminals stay **fish**; **cmux runs zsh** all the way (`$SHELL` + sub-shells); Ghostty.app opens into **tmux `work`** (detach → shell).
- **Theme** — Catppuccin Mocha terminal (shared by cmux + Ghostty) + Catppuccin-harmonized cmux sidebar.
- **Keybindings** — hybrid tmux-prefix (`Ctrl+B`) navigation in cmux *(coming)*.
- **Notifications, skills, agent integrations, worktrees** *(coming — see roadmap)*.

## How it works

cmux and Ghostty both read your personal `~/.config/ghostty/config`, and your
shell rc files (`~/.zshrc`, `~/.config/fish/config.fish`) hold your own lines and
secrets. So this repo does **not** symlink whole files. Instead it injects
**marker-delimited managed blocks** that are safe to re-apply and remove:

```
# >>> cmux-config:zshrc >>>
...managed lines...
# <<< cmux-config:zshrc <<<
```

`cmux.json` is cmux-only (no secrets), so it's managed wholesale.

## Layout

```
install.sh / uninstall.sh / verify.sh   # apply / remove / check (idempotent, auto-backup)
lib/inject.sh                            # marker-block injector
blocks/                                  # source-of-truth managed blocks
  ghostty.cmux.conf · config.fish.cmux.fish · zshrc.cmux.sh
config/cmux/cmux.json                    # cmux app settings (theme/sidebar; +keybinds later)
docs/                                    # ROADMAP, current-state, guides
scripts/poc-rollback.sh                  # revert the in-place proof-of-concept
```

## Quick start

```sh
git clone <repo> ~/code/cmux-configuration
cd ~/code/cmux-configuration
./install.sh        # backs up each target first
./verify.sh
# apply: cmux reload-config (+ new tab) ; quit & reopen Ghostty
```

Undo anytime: `./uninstall.sh`.

## Privacy

Public repo, **no PII**: no names, emails, hostnames, secrets, or `/Users/<name>/`
paths — enforced by `.gitignore` and managed-block design. See
[`docs/00-current-state.md`](docs/00-current-state.md).

## License

[MIT](LICENSE).
