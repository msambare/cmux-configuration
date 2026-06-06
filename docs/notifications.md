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

## Optional: fan-out to phone / elsewhere

Set `notifications.command` (runs on every notification with
`$CMUX_NOTIFICATION_TITLE/SUBTITLE/BODY`) or `notifications.hooks` (JSON-in →
policy-JSON-out, can suppress/modify per-notification). Left empty by default.
