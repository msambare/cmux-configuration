# Keybindings — hybrid tmux ⌃B prefix

cmux's own shortcuts are normally Cmd-based. This config overlays a **tmux-style
`Ctrl+B` prefix** for pane / split / window navigation, while leaving Cmd for
app-level actions. Defined in [`config/cmux/cmux.json`](../config/cmux/cmux.json)
under `shortcuts.bindings`; all entries are validated against cmux's official
shortcut grammar.

> cmux only — these apply to the cmux app. Inside Ghostty you have a *real* tmux,
> which uses its own native `Ctrl+B`. No conflict (cmux runs no tmux).

## tmux ⌃B prefix (press `Ctrl+B`, release, then the key)

| Chord | Action | tmux analog | (replaced cmux default) |
|-------|--------|-------------|--------------------------|
| `⌃B %` (shift+5) | split right | `%` split vertical | cmd+d |
| `⌃B "` (shift+') | split down | `"` split horizontal | cmd+shift+d |
| `⌃B ←/→/↑/↓` | focus pane | prefix+arrows | cmd+opt+arrows |
| `⌃B z` | zoom pane | `z` | cmd+shift+enter |
| `⌃B space` | equalize splits | `space` next-layout | ctrl+cmd+= |
| `⌃B c` | new tab (surface) | `c` new window | cmd+t |
| `⌃B n` / `⌃B p` | next / prev tab | `n` / `p` | cmd+shift+]/[ |
| `⌃B 1`…`9` | select tab N | window number | ctrl+1 |
| `⌃B x` | close tab | `x` kill pane | cmd+w |
| `⌃B ,` | rename tab | `,` rename window | cmd+r |
| `⌃B [` | copy mode | `[` | cmd+shift+m |

## Stays Cmd (app-level, cmux defaults — untouched)

| Key | Action |
|-----|--------|
| `⌘⇧P` | command palette |
| `⌘,` | settings |
| `⌘B` | toggle sidebar |
| `⌘N` | new workspace |
| `⌘P` | workspace switcher |
| `⌘F` / `⌘⇧F` | find / find in dir |
| `⌘⇧L` / `⌘L` | browser / address bar |
| `⌘Q` | quit |

## Tuning

Every binding is one line in `cmux.json`. To revert one to its Cmd default,
change the value (e.g. `"closeTab": "cmd+w"`) or set it to `"none"` to unbind.
After editing: `cmux reload-config` (or `Cmd+Shift+,`).
