#!/usr/bin/env sh
APP_NAME="${INFO:-}"
if [ -z "$APP_NAME" ]; then
  APP_NAME="$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null || true)"
fi
[ -z "$APP_NAME" ] && APP_NAME=""

sketchybar --set "$NAME" label="$APP_NAME"
