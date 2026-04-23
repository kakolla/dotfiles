#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Open Terminal Here (New Window)
# @raycast.mode silent

DIR=$(osascript -e 'tell application "Finder" to if (count of windows) > 0 then get POSIX path of (target of front window as alias)')

if [ -z "$DIR" ]; then
  DIR="$HOME"
fi

# open -n -a Terminal "$DIR"
open -n -a Ghostty.app "$DIR"
