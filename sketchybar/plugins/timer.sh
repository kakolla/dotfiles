#!/usr/bin/env sh

# Get running timer (state 3) fire date from macOS Clock app
FIRE_DATE=$(defaults read com.apple.mobiletimerd MTTimers 2>/dev/null | \
  grep -B 20 "MTTimerState = 3" | \
  grep "MTTimerTimeDate" | \
  tail -1 | \
  sed 's/.*"\(.*\)".*/\1/')

if [ -n "$FIRE_DATE" ]; then
  # Calculate remaining seconds
  FIRE_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S %z" "$FIRE_DATE" "+%s" 2>/dev/null)
  NOW_EPOCH=$(date "+%s")
  REMAINING=$((FIRE_EPOCH - NOW_EPOCH))

  if [ "$REMAINING" -gt 0 ]; then
    MINS=$((REMAINING / 60))
    SECS=$((REMAINING % 60))
    LABEL=$(printf "%d:%02d" "$MINS" "$SECS")
    # Timer active: poll every second for countdown
    sketchybar --set "$NAME" label="$LABEL" icon="󰔛" drawing=on update_freq=1
  else
    # Timer just ended: stop polling, wait for event
    sketchybar --set "$NAME" drawing=off update_freq=0
  fi
else
  # No timer: stop polling, wait for event
  sketchybar --set "$NAME" drawing=off update_freq=0
fi
