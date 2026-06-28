#!/bin/bash
~/.config/i3/power-draw.sh >/dev/null 2>&1  # warm-up, optional

i3status | while read -r line; do
    case $line in
        '{'*) echo "$line" ;;   # {"version":1} header
        '[')  echo "$line" ;;   # start of the infinite array
        *)
            power=$(~/power-draw.sh)
            block="{\"name\":\"power\",\"full_text\":\"${power}\"}"
            # insert our block right after the leading '['
            echo "${line/[/[${block},}"
            ;;
    esac
done
