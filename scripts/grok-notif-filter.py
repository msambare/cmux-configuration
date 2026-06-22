#!/usr/bin/python3
# cmux notification hook — silence Grok's per-tool "running / permission / needs-input" buzz.
#
# WHY: cmux installs a blocking PreToolUse Feed hook for Grok (it has no `grokIntegration`
# off-switch, and cmux regenerates the hook file on every grok launch, so editing the hook
# is futile). Grok runs `permission_mode = always-approve`, so each tool call still fires a
# "Tool permission requested" / "Grok needs input" notification — a macOS banner + sound every
# ~15s while Grok is simply working. Claude (PermissionRequest-only) and Codex (non-blocking
# telemetry) don't do this; Grok wasn't given that treatment.
#
# WHAT: this runs as a `notifications.hooks` entry in cmux.json. cmux pipes every notification's
# policy JSON to stdin; we return modified JSON on stdout. For Grok's in-progress / permission /
# waiting / needs-input notifications we strip the banner, sound, pane flash, workspace reorder,
# and unread mark — so they stop buzzing — while leaving genuine Grok completion notifications
# (and every other agent) completely untouched.
#
# FAIL-OPEN: on any error we echo stdin back verbatim, so a bug here can never drop or corrupt a
# notification — worst case is the current (noisy) behavior, never a lost alert.
import sys, json, re

raw = sys.stdin.read()
try:
    pol = json.loads(raw)
    n = pol.get("notification", {}) or {}
    title = str(n.get("title", "")).lower()
    hay = " ".join(str(n.get(k, "")) for k in ("title", "subtitle", "body")).lower()
    # Scope to Grok by the agent name in the TITLE (avoids matching another agent whose task
    # text happens to mention grok).
    is_grok = "grok" in title
    is_noise = re.search(
        r"running:|tool permission requested|needs input|\bwaiting\b|permission request",
        hay,
    ) is not None
    eff = pol.get("effects")
    if is_grok and is_noise and isinstance(eff, dict):
        for k in ("desktop", "sound", "paneFlash", "reorderWorkspace", "markUnread", "record"):
            if k in eff:
                eff[k] = False
    sys.stdout.write(json.dumps(pol))
except Exception:
    sys.stdout.write(raw)
