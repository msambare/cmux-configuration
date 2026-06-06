# Roadmap & Frozen Decisions

Live status of the cmux-configuration build. Updated as phases land.

## Frozen decisions (2026-06-06)

| Area | Decision |
|------|----------|
| **Shells** | OS/login + other terminals = **fish**. **cmux = zsh** (all the way: `$SHELL` + sub-shells). Ghostty.app = zsh outer, **tmux `work`** on open, detach → shell. |
| **Theme** | **Catppuccin Mocha** terminal theme — *shared* by cmux + Ghostty (they read the same ghostty config; per-app terminal themes would need a bundle edit, rejected). cmux differentiated via dark chrome + Catppuccin-harmonized sidebar. |
| **Keybindings** | **Hybrid** — tmux `Ctrl+B` prefix chords for pane/split/window nav in cmux; Cmd for app-level (palette, settings, sidebar). |
| **Agents** | Wire **Claude Code, Codex, OpenCode, Grok** (skills + notification hooks + team launchers). |
| **Grok** | Grok **CLI + isolated HOME** (`~/.grok/bin`, `~/.grok-isolated-home`). |
| **Scope** | **Comprehensive**, phased with review gates. |
| **Delivery** | Managed marker-blocks injected into personal files (`.zshrc`, `config.fish`, ghostty `config`) — never symlink/commit those whole. `cmux.json` managed wholesale (cmux-only). |
| **Privacy** | Public repo, MIT, **zero PII** — not even in git history. |

## Phases

- [x] **P0 — Discover** cmux config + docs; baseline ([docs/00-current-state.md](00-current-state.md)).
- [x] **P1 — Foundation POC** (shells/theme/tmux/sidebar) proven in-place; reversible via [scripts/poc-rollback.sh](../scripts/poc-rollback.sh).
- [x] **P2 — Portable spine**: `install.sh` / `uninstall.sh` / `verify.sh` + `lib/inject.sh` + `blocks/` + managed `cmux.json`. *(sandbox + live validated; machine migrated to managed; effective config proven byte-identical to the working POC)*
- [ ] **P3 — Features**: keybindings (hybrid tmux), notifications (+agent hooks), skills install, agent integrations (claude/codex/opencode/grok), worktrees (custom commands).
- [ ] **P4 — Docs**: per-area guides + D2 architecture diagram.
- [ ] **P5 — Ship**: PII-verified commit → review → GitHub public.

## Migrate this machine (POC → managed)

The live machine still runs the **POC** blocks (markers `# === cmux POC test ... ===`). To switch to the repo's managed blocks cleanly:

```sh
zsh scripts/poc-rollback.sh   # restore pristine personal files
./install.sh                  # inject managed blocks (same behavior, clean markers)
./verify.sh
```
Then `cmux reload-config` + restart Ghostty/cmux. Do this only after reviewing the repo.
