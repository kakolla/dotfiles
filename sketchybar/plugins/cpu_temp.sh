#!/bin/bash

# This script is triggered by the system_stats event from stats_provider
# CPU_TEMP is provided as an environment variable
sketchybar --set "$NAME" label="$CPU_TEMP"
