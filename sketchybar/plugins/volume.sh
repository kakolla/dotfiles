#!/usr/bin/env sh
VOL="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null || echo "")"
[ -z "$VOL" ] && VOL="?"

# Check if current audio output is Bluetooth
BT_AUDIO=$(system_profiler SPAudioDataType 2>/dev/null | grep -B5 "Default Output Device: Yes" | grep "Transport: Bluetooth")

if [ -n "$BT_AUDIO" ]; then
  ICON="󰋋"  # headphones icon (nerd font)
  ICON_COLOR="0xffcba6f7"  # purple
else
  ICON=""
  ICON_COLOR="0xffffffff"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$ICON_COLOR" icon.font="JetBrainsMono Nerd Font:Medium:15.0" label="${VOL}%"
