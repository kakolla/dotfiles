#!/bin/sh

LAT="34.0522"
LON="-118.2437"
URL="https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&current=temperature_2m&timezone=auto&temperature_unit=celsius"

DATA=$(curl -s "$URL")
TEMP=$(echo "$DATA" | jq -r '.current.temperature_2m')

LABEL="$(printf "%.0f°C" "$TEMP")"

sketchybar --set "$NAME" icon.drawing=off label="$LABEL"
