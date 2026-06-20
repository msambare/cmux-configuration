# Keybindings — hybrid tmux ⌘B prefix

cmux's own shortcuts are normally Cmd-based. This config overlays a **tmux-style
`Cmd+B` prefix** (`cmd+b`) for pane / split / window navigation, while leaving the
rest of Cmd for app-level actions. Defined in
[`config/cmux/cmux.json`](../config/cmux/cmux.json) under `shortcuts.bindings`; all
entries are validated against cmux's official shortcut grammar.

**Why `Cmd+B` and not `Ctrl+B` or `Option+B`:**

- **Ctrl+B** would be intercepted by cmux *before* it reaches the terminal — so a
  **remote tmux** you SSH into (whose own prefix is `Ctrl+B`) would never see its
  prefix. Cmd is never sent to the terminal PTY, so remote `Ctrl+B` / `Ctrl+A` pass
  straight through, untouched.
- **Option+B** can't lead a chord on macOS: `Option`+letter composes a text
  character (`∫`), so the keystroke is eaten as input and never reaches cmux's chord
  layer. cmux's chord/hint system is built for Cmd / Ctrl only.
- **Cmd** is cmux's native chord modifier, fires reliably, and (on a home-row-mod
  keyboard like the Dygma Defy: A=Ctrl, S=Opt, **D=Cmd**, F=Shift) sits right next
  to Ctrl — so the prefix stays ergonomically close to the tmux original.

> cmux only — these apply to the cmux app. Inside Ghostty (or any SSH session) you
> have a *real* tmux using native `Ctrl+B`. cmux's `Cmd+B` and tmux's `Ctrl+B` are
> different modifiers on different layers → **zero conflict**, local or remote.

## tmux ⌘B prefix (press `Cmd+B`, release, then the key)

| Chord | Action | tmux analog | (replaced cmux default) |
|-------|--------|-------------|--------------------------|
| `⌘B %` (shift+5) | split right | `%` split vertical | cmd+d |
| `⌘B "` (shift+') | split down | `"` split horizontal | cmd+shift+d |
| `⌘B ←/→/↑/↓` | focus pane | prefix+arrows | cmd+opt+arrows |
| `⌘B z` | zoom pane | `z` | cmd+shift+enter |
| `⌘B space` | equalize splits | `space` next-layout | ctrl+cmd+= |
| `⌘B c` | new tab (surface) | `c` new window | cmd+t |
| `⌘B n` / `⌘B p` | next / prev tab | `n` / `p` | cmd+shift+]/[ |
| `⌘B 1`…`9` | select tab N | window number | ctrl+1 |
| `⌘B x` | close tab | `x` kill pane | cmd+w |
| `⌘B ,` | rename tab | `,` rename window | cmd+r |
| `⌘B [` | copy mode | `[` | cmd+shift+m |

## Stays Cmd (app-level, cmux defaults)

| Key | Action |
|-----|--------|
| `⌘⇧P` | command palette |
| `⌘,` | settings |
| `⌘⇧B` | toggle sidebar — **moved** from `⌘B` (now the prefix) |
| `⌘N` | new workspace |
| `⌘P` | workspace switcher |
| `⌘F` / `⌘⇧F` | find / find in dir |
| `⌘⇧L` / `⌘L` | browser / address bar |
| `⌘Q` | quit |

## Shift+Enter = newline in Claude Code (over ssh + tmux)

The managed ghostty block also rebinds **Shift+Enter** so it inserts a newline in
Claude Code instead of submitting:

```
keybind = shift+enter=text:\n
```

Why it's needed: by default cmux/Ghostty encodes Shift+Enter as the legacy CSI-27
sequence (`ESC[27;2;13~`), which Claude Code does **not** treat as newline — so it
submits. The kitty CSI-u form (`ESC[13;2u`) also failed to survive an `ssh → remote
tmux` hop in testing. A bare line feed (`\n`, 0x0a) is what Claude inserts a newline
on (it only submits on `\r`), it's the exact byte iTerm sends, and a single literal
byte passes through ssh + tmux untouched — so this works locally *and* in a remote
tmux session. (`Ctrl+J` and `\`+Enter are built-in Claude fallbacks that always work.)

This lives in the shared ghostty config, so it applies to standalone Ghostty.app too.

## Tuning

Every binding is one line in `cmux.json`. To revert one to its Cmd default,
change the value (e.g. `"closeTab": "cmd+w"`) or set it to `"none"` to unbind.
After editing: `cmux reload-config` (or `Cmd+Shift+,`).
