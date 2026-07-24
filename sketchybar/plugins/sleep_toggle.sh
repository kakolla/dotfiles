#!/bin/bash
# Toggle "stay awake" via `pmset -a disablesleep`. State is read without sudo
# (pmset -g shows SleepDisabled). Toggling runs pmset as root through the native
# macOS admin-auth dialog (osascript "with administrator privileges") — so it
# needs NO sudoers entry (which Meta's MDM keeps wiping) and prompts for your
# password on click. macOS caches that auth for ~5 min, so rapid re-toggles may
# not re-prompt.

export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin"

read_state() {
  pmset -g 2>/dev/null | awk '/SleepDisabled/{print $2; f=1} END{if(!f) print 0}'
}

cur=$(read_state)

if [ "$SENDER" = "mouse.clicked" ]; then
  if [ "$cur" = "1" ]; then new=0; else new=1; fi
  osascript -e "do shell script \"/usr/bin/pmset -a disablesleep $new\" with administrator privileges" >/dev/null 2>&1
  cur=$(read_state)
fi

if [ "$cur" = "1" ]; then
  # sleep disabled -> Mac stays awake ("work mode")
  sketchybar --set "$NAME" icon="" label="awake" \
    icon.color=0xfff9e2af label.color=0xfff9e2af \
    background.drawing=on background.color=0x33f9e2af
else
  # normal -> Mac may sleep
  sketchybar --set "$NAME" icon="" label="sleep" \
    icon.color=0xff9399b2 label.color=0xff9399b2 \
    background.drawing=on background.color=0x22ffffff
fi
