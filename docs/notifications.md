# Notifications

cmux raises a desktop alert + sound + sidebar badge when a workspace wants
attention (agent finished, needs input, long task done). Settings live in
[`config/cmux/cmux.json`](../config/cmux/cmux.json) → `notifications`.

## Managed settings

| Key | Value | Effect |
|-----|-------|--------|
| `dockBadge` | true | unread count on the Dock icon |
| `showInMenuBar` | true | menu-bar extra |
| `unreadPaneRing` | true | ring around panes with unread |
| `paneFlash` | true | flash a pane on request |
| `sound` | `Glass` | chime on notification (distinct from system default) |
| `app.reorderOnNotification` | true | float a notifying workspace toward the top |

Desktop alerts are auto-suppressed when the cmux window / that workspace is
already focused (so you only get pinged for background work).

Change the sound to any of: `default, Basso, Blow, Bottle, Frog, Funk, Glass,
Hero, Morse, Ping, Pop, Purr, Sosumi, Submarine, Tink, none`. Then
`cmux reload-config`.

## How notifications get triggered

- **Agents** (the main source) — wired via `cmux hooks <agent> install`; see
  [`docs/agents.md`](agents.md). Claude Code is auto-injected by cmux's claude
  wrapper; Codex / OpenCode / Grok get a generated hook that fires on
  stop / needs-input. Nested sub-agent noise is suppressed by
  `automation.suppressSubagentNotifications` (cmux default).
- **CLI / scripts** — `cmux notify --title "Build" --subtitle "done" --body "all green"`.
- **Terminal escapes** — OSC 777 (`printf '\e]777;notify;Title;Body\a'`) or OSC 99
  (rich: title+subtitle+body).
- **Socket** — `notification.create` method.

## Grok per-tool buzz silencer (enabled)

cmux installs a **blocking PreToolUse Feed hook** for Grok, so with Grok in
`always-approve` mode every tool call fires a "Tool permission requested / needs
input" banner+sound — buzzing every ~15s while Grok just works. There's no
`grokIntegration` off-switch and cmux **regenerates the grok hook file on each
launch**, so editing the hook doesn't stick. (Claude uses a PermissionRequest-only
feed bridge and Codex non-blocking telemetry, so neither buzzes.)

Fix: a `notifications.hooks` filter ([`scripts/grok-notif-filter.py`](../scripts/grok-notif-filter.py),
installed to `~/.config/cmux/`) strips `desktop`/`sound`/`paneFlash`/`reorderWorkspace`
for Grok notifications whose title is Grok **and** carry an in-progress marker
(`Running:`, `Tool permission requested`, `needs input`, `Waiting`). Genuine Grok
completions and every other agent pass through untouched. Fail-open: any error echoes
the notification unchanged, so an alert is never lost. Defined in `cmux.json` →
`notifications.hooks` (id `grok-progress-silencer`).

## Optional: fan-out to phone / elsewhere

Set `notifications.command` (runs on every notification with
`$CMUX_NOTIFICATION_TITLE/SUBTITLE/BODY`) or add more `notifications.hooks` entries
(JSON-in → policy-JSON-out, can suppress/modify per-notification).
