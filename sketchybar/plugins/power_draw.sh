#!/bin/bash
# Total system power draw (watts) via macmon.
# `macmon pipe` streams JSON; take the first sample and close the pipe.

w=$(macmon pipe -i 200 2>/dev/null | head -n 1 \
  | grep -o '"sys_power":[0-9.]*' | head -1 | cut -d: -f2)

if [ -n "$w" ]; then
  sketchybar --set "$NAME" label="$(printf '%.1f' "$w")W"
else
  sketchybar --set "$NAME" label="--"
fi
