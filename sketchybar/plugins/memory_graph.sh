#!/bin/bash
# Pushes memory-used fraction (0..1) into a sketchybar graph and shows the %.
# Same "Memory Used" approximation as memory_usage.sh (active + wired + compressed).

TOTAL=$(sysctl -n hw.memsize)
PAGE=$(vm_stat | sed -n 's/.*page size of \([0-9]*\) bytes.*/\1/p')
STATS=$(vm_stat)

pages() { echo "$STATS" | awk -v k="$1" 'index($0,k)==1 {gsub(/\./,"",$NF); print $NF}'; }

active=$(pages "Pages active")
wired=$(pages "Pages wired down")
comp=$(pages "Pages occupied by compressor")

used=$(( (active + wired + comp) * PAGE ))
frac=$(awk "BEGIN{printf \"%.4f\", $used/$TOTAL}")
pct=$(awk "BEGIN{printf \"%.0f\", $used/$TOTAL*100}")

sketchybar --set "$NAME" label="${pct}%"
sketchybar --push "$NAME" "$frac"
