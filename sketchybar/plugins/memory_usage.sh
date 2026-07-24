#!/bin/bash
# Memory usage, approximating Activity Monitor's "Memory Used"
# (App Memory + Wired + Compressed) as a share of physical RAM.

TOTAL=$(sysctl -n hw.memsize)
PAGE_SIZE=$(vm_stat | sed -n 's/.*page size of \([0-9]*\) bytes.*/\1/p')
STATS=$(vm_stat)

pages() { echo "$STATS" | awk -v k="$1" 'index($0,k)==1 {gsub(/\./,"",$NF); print $NF}'; }

active=$(pages "Pages active")
wired=$(pages "Pages wired down")
compressed=$(pages "Pages occupied by compressor")

used=$(( (active + wired + compressed) * PAGE_SIZE ))
used_gb=$(awk "BEGIN{printf \"%.1f\", $used/1073741824}")
percent=$(awk "BEGIN{printf \"%.0f\", $used/$TOTAL*100}")

sketchybar --set "$NAME" label="${used_gb}G ${percent}%"
