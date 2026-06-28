#!/bin/bash
BAT=/sys/class/power_supply/BAT1

if [ -r "$BAT/power_now" ]; then
    uw=$(< "$BAT/power_now")
else
    # fallback: current_now (µA) × voltage_now (µV) / 1e6 = µW
    i=$(< "$BAT/current_now")
    v=$(< "$BAT/voltage_now")
    uw=$(( i * v / 1000000 ))
fi

awk -v uw="$uw" 'BEGIN { printf "%.1f W", uw/1000000 }'
