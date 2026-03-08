#!/bin/bash

# Get CPU usage using ps
cpu=$(ps -A -o %cpu | awk '{sum+=$1} END {print sum}')
cores=$(sysctl -n hw.ncpu)

percent=$(awk "BEGIN {printf \"%.1f\", $cpu / $cores}")
normalized=$(awk "BEGIN {printf \"%.4f\", $percent / 100}")
display=$(awk "BEGIN {printf \"%.0f%%\", $percent}")

sketchybar --set cpu_usage label="$display"
sketchybar --push cpu_usage "$normalized"