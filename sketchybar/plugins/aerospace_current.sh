#!/usr/bin/env sh
FOCUSED="$(aerospace list-workspaces --focused 2>/dev/null | head -n1 | tr -d ' \t\r\n')"
[ -z "$FOCUSED" ] && FOCUSED="-"
sketchybar --set "$NAME" label="$FOCUSED"

