#!/usr/bin/env bash
set -euo pipefail

DIR="${I3_RESURRECT_DIR:-$HOME/.i3/i3-resurrect/}"

esc() { sed 's/[]["\^$.|?*+(){}]/./g'; }

shopt -s nullglob
for layout in "$DIR"/workspace_*_layout.json; do
    ws=$(jq -r '.name' "$layout")
    [ -z "$ws" ] || [ "$ws" = "null" ] && continue

    if [[ "$ws" =~ ^[0-9]+$ ]]; then
        target="number $ws"
    else
        target="\"$ws\""
    fi

    jq -r '.. | objects
             | select(has("swallows"))
             | select((.swallows[0].class // "") | test("firefox";"i"))
             | .name // empty' "$layout" |
    while IFS= read -r title; do
        [ -z "$title" ] && continue
        pat=$(printf '%s' "$title" | esc)
        i3-msg "[title=\"$pat\"] move to workspace $target" >/dev/null || true
    done
done
