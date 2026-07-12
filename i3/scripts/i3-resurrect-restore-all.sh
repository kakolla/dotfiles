#!/usr/bin/env bash
set -euo pipefail

DIR="${I3_RESURRECT_DIR:-$HOME/.i3/i3-resurrect/}"
SCRIPTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

wait_outputs() {
    local prev="" cur i=0
    while (( i < 30 )); do
        cur=$(i3-msg -t get_outputs 2>/dev/null \
              | jq -r '[.[] | select(.active) | .name] | sort | join(",")')
        [ -n "$cur" ] && [ "$cur" = "$prev" ] && return 0
        prev="$cur"; sleep 0.5; ((i++))
    done
}

expected_firefox() {
    local total=0 n
    shopt -s nullglob
    for l in "$DIR"/workspace_*_layout.json; do
        n=$(jq '[.. | objects | select(has("swallows"))
                 | select((.swallows[0].class // "") | test("firefox";"i"))]
                | length' "$l")
        total=$(( total + n ))
    done
    echo "$total"
}

firefox_count() { xdotool search --class Navigator 2>/dev/null | wc -l; }

wait_firefox() {
    local want="$1" prev=-1 cur stable=0 i=0
    while (( i < 60 )); do
        cur=$(firefox_count)
        (( cur >= want )) && return 0
        if (( cur == prev )); then
            (( ++stable >= 6 )) && return 0
        else
            stable=0
        fi
        prev="$cur"; sleep 0.5; ((i++))
    done
}

wait_outputs

mapfile -t WORKSPACES < <(i3-msg -t get_workspaces | jq -r '.[].name')

for ws in "${WORKSPACES[@]}"; do i3-resurrect restore -w "$ws" --layout-only; done
sleep 1
for ws in "${WORKSPACES[@]}"; do i3-resurrect restore -w "$ws" --programs-only; done

wait_firefox "$(expected_firefox)"

"$SCRIPTS/i3-resurrect-fixup.sh"
