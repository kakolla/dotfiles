#!/bin/bash

# Get number of CPU cores for normalization
cores=$(sysctl -n hw.ncpu)

# Get the top CPU-consuming process (excluding kernel_task and idle)
top_proc=$(ps -Acro pid,pcpu,comm 2>/dev/null | grep -v "kernel_task" 2>/dev/null | head -2 | tail -1)

# Extract process name and CPU percentage
cpu_raw=$(echo "$top_proc" | awk '{print $2}')
name=$(echo "$top_proc" | awk '{print $3}' | cut -c1-10)

# Normalize CPU to total capacity (like iStat Menus)
cpu=$(awk "BEGIN {printf \"%.1f\", $cpu_raw / $cores}")

# Only show if CPU usage is notable (> 1%)
if awk "BEGIN {exit !($cpu > 5)}"; then
  sketchybar --set top_process label="${name} ${cpu}%" background.drawing=on
else
  sketchybar --set top_process label="" background.drawing=off
fi
