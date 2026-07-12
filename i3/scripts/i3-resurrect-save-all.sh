#!/bin/bash
# Save layout + programs for every active i3 workspace
for ws in $(i3-msg -t get_workspaces | jq -r '.[].name'); do
    i3-resurrect save -w "$ws"
done
