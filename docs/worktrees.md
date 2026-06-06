# Worktrees — parallel agents on isolated branches

git worktrees let each agent work on its own branch in its own directory, opened
as its own cmux workspace — so Claude on `feature-a`, Codex on `fix-b`, etc. run
in parallel without stepping on each other.

cmux has no built-in worktree config; this repo provides
[`scripts/worktree.sh`](../scripts/worktree.sh) plus optional cmux UI wiring.

## Create / open

```sh
scripts/worktree.sh <branch> [base-ref]
# new branch off HEAD:        scripts/worktree.sh feature-x
# new branch off another ref: scripts/worktree.sh hotfix origin/main
# attach an existing branch:   scripts/worktree.sh existing-branch
```

- Worktrees live in a sibling `«repo».worktrees/«branch»/` dir (tidy; easy to
  group in cmux's sidebar via `workspaceGroups.byCwd`).
- Run inside cmux → it auto-opens the worktree as a new workspace. Outside cmux →
  it prints the path (`cmux "<path>"` to open).
- Idempotent: re-running for an existing worktree just reports it.

Handy alias (add to your shell): `alias wt='~/code/cmux-configuration/scripts/worktree.sh'`.

## Remove

```sh
git -C <repo> worktree remove «repo».worktrees/«branch»
git branch -d «branch»
```

## Parallel agents in the worktree workspace

Once the worktree workspace is open in cmux, split it and launch an agent per pane
(`Ctrl+B %` / `Ctrl+B "` with these keybindings, then run `claude` / `codex` /
`opencode` / `grok`).

For **one-click** worktree-with-agents (plus-button / Command Palette), use cmux's
`cmux-customization` skill — it ships a `worktree-agents` example that opens a
dedicated worktree with paired Codex/Claude/SSH terminals. Install skills first
([`docs/skills.md`](skills.md)), then ask your agent to wire it via that skill, or
adapt its example into `customCommands` in `cmux.json`.

## Why grouped worktrees

Keeping all worktrees under `«repo».worktrees/` means a single
`workspaceGroups.byCwd` glob can color/group them together in the cmux sidebar,
so parallel-branch workspaces stay visually organized.
