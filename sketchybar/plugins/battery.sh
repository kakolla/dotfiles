#!/bin/sh

source "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

# Battery glyph (Material Design Icons, rendered in Hack Nerd Font)
if [ -n "$CHARGING" ]; then
  ICON="󰂄"        # charging bolt
elif [ "$PERCENTAGE" -ge 95 ]; then
  ICON="󰁹"
elif [ "$PERCENTAGE" -ge 85 ]; then
  ICON="󰂂"
elif [ "$PERCENTAGE" -ge 75 ]; then
  ICON="󰂁"
elif [ "$PERCENTAGE" -ge 65 ]; then
  ICON="󰂀"
elif [ "$PERCENTAGE" -ge 55 ]; then
  ICON="󰁿"
elif [ "$PERCENTAGE" -ge 45 ]; then
  ICON="󰁾"
elif [ "$PERCENTAGE" -ge 35 ]; then
  ICON="󰁽"
elif [ "$PERCENTAGE" -ge 25 ]; then
  ICON="󰁼"
elif [ "$PERCENTAGE" -ge 15 ]; then
  ICON="󰁻"
elif [ "$PERCENTAGE" -ge 8 ]; then
  ICON="󰁺"
else
  ICON="󰂃"          # critically low
fi

# Color: green when charging, red <=10%, orange <=20%, white otherwise
if [ -n "$CHARGING" ]; then
  COLOR="0xffa6e3a1"
elif [ "$PERCENTAGE" -le 10 ]; then
  COLOR="$RED"
elif [ "$PERCENTAGE" -le 20 ]; then
  COLOR="$ORANGE"
else
  COLOR="$WHITE"
fi

sketchybar --set "$NAME" \
  icon="$ICON" \
  label="$PERCENTAGE%" \
  label.drawing=on \
  label.color="$COLOR" \
  icon.color="$COLOR" \
  padding_right=0
