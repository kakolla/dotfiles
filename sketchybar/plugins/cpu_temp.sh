#!/bin/bash
# CPU temperature via macmon (Apple Silicon has no sudo-free built-in reader).
# `macmon pipe` streams JSON; take the first sample and close the pipe.

temp=$(macmon pipe -i 200 2>/dev/null | head -n 1 \
  | grep -o '"cpu_temp_avg":[0-9.]*' | head -1 | cut -d: -f2)

if [ -n "$temp" ]; then
  sketchybar --set "$NAME" label="$(printf '%.0f' "$temp")°C"
else
  sketchybar --set "$NAME" label="--"
fi
