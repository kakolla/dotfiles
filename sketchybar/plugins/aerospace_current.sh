#!/usr/bin/env sh
# Resolve the aerospace CLI (PATH first, then known locations).
AEROSPACE="$(command -v aerospace 2>/dev/null)"
[ -z "$AEROSPACE" ] && for c in /opt/homebrew/bin/aerospace /usr/local/bin/aerospace "$HOME/.local/bin/aerospace"; do
  [ -x "$c" ] && AEROSPACE="$c" && break
done

FOCUSED="$("$AEROSPACE" list-workspaces --focused 2>/dev/null | head -n1 | tr -d ' \t\r\n')"
[ -z "$FOCUSED" ] && FOCUSED="-"
sketchybar --set "$NAME" label="$FOCUSED"

