#!/usr/bin/env sh
# put in ~/.config/display_mode.sh
CLAMSHELL=$(ioreg -r -k AppleClamshellState -d 4 | grep AppleClamshellState | awk '{print $NF}')


# clamshell mode - allocate 32 space for sketchybar
# regualr mode - 0 (notch already does it)
if [ "$CLAMSHELL" = "Yes" ]; then
  sed -i '' 's/outer\.top =.*[0-9]/outer.top =        32/' ~/.aerospace.toml
else
  sed -i '' 's/outer\.top =.*[0-9]/outer.top =         0/' ~/.aerospace.toml
fi

aerospace reload-config