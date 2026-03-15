#!/bin/sh

source "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

# Select icon based on percentage (adjusted for visual accuracy)
if [ "$PERCENTAGE" -ge 88 ]; then
  ICON="􀛨"   # battery.100
elif [ "$PERCENTAGE" -ge 63 ]; then
  ICON="􀺸"   # battery.75
elif [ "$PERCENTAGE" -ge 38 ]; then
  ICON="􀺶"   # battery.50
elif [ "$PERCENTAGE" -ge 13 ]; then
  ICON="􀛩"   # battery.25
else
  ICON="􀛪"   # battery.0
fi

# Icon stays the same whether charging or not - color indicates charging

# Color: red at <=10%, orange at <=20%, green when charging, white otherwise
if [[ "$CHARGING" != "" ]]; then
  COLOR="0xffa6e3a1"  # green when charging
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
