#!/bin/bash
# Driver for per-diff chips on the left. This item itself never draws; on each
# run it renders one chip item per pending (unlanded) Phabricator diff, named
# "diff.D<number>", each with its own status color and its own click target.
#
# `phabricator.agent my-diffs` excludes landed/abandoned diffs by default, so
# nothing already committed appears. The call is slow (~2s, network), so we
# render the cached value instantly, then fetch fresh and re-render. The cache
# in ~/.cache persists across restarts, so chips appear immediately on login.

export PATH="/opt/facebook/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

CACHE="$HOME/.cache/sketchybar/diff_status.csv"
mkdir -p "$(dirname "$CACHE")"

# (ci, readiness) -> "display color". Always show the CI verdict (warning folded
# into Passed); if the diff is unpublished/draft, keep the status but gray it out.
diff_props() {
  local disp color
  case "$1" in
    red)     disp="Fail";    color="0xfff38ba8" ;;
    pending) disp="Testing"; color="0xfff9e2af" ;;
    stale)   disp="Stale";   color="0xff9399b2" ;;
    *)       disp="Passed";  color="0xffa6e3a1" ;;   # green / warning
  esac
  [ "$2" = "draft" ] && color="0xff9399b2"   # unpublished -> gray, keep status
  echo "$disp $color"
}

render() {
  local csv="$1" existing desired_names="" anchor="$NAME"
  local desired dnum ci readiness disp color last3 name

  # Chips that currently exist on the bar.
  existing=$(sketchybar --query bar 2>/dev/null | grep -o '"diff\.D[0-9]*"' | tr -d '"')

  # Desired diffs, one "Dnumber,ci,readiness" per line.
  desired=$(printf '%s\n' "$csv" | awk -F, 'NR>1 && $1!="" {print $1","$2","$3}')

  while IFS=, read -r dnum ci readiness; do
    [ -z "$dnum" ] && continue
    name="diff.$dnum"
    read -r disp color <<<"$(diff_props "$ci" "$readiness")"
    last3=${dnum#D}; last3=${last3: -3}

    if ! printf '%s\n' "$existing" | grep -qx "$name"; then
      sketchybar --add item "$name" left
      sketchybar --move "$name" after "$anchor" 2>/dev/null
    fi
    sketchybar --set "$name" \
      drawing=on icon.drawing=off \
      label="D${last3}: ${disp}" label.color="$color" \
      label.padding_left=8 label.padding_right=8 \
      background.drawing=on background.color=0x22ffffff \
      background.corner_radius=6 background.height=18 \
      click_script="open \"https://www.internalfb.com/diff/${dnum}\""

    anchor="$name"
    desired_names="$desired_names $name"
  done <<EOF
$desired
EOF

  # Remove chips whose diff is no longer pending (e.g. it landed).
  local n
  for n in $existing; do
    case " $desired_names " in
      *" $n "*) : ;;
      *) sketchybar --remove "$n" 2>/dev/null ;;
    esac
  done
}

# The driver itself is invisible.
sketchybar --set "$NAME" drawing=off

# 1. Instant render from cache (so login/restart is never blank).
[ -f "$CACHE" ] && render "$(cat "$CACHE")"

# 2. Fetch fresh; on success, update the cache and re-render.
data=$(meta phabricator.agent my-diffs --columns=number,ci,readiness --output=csv 2>/dev/null)
if printf '%s\n' "$data" | grep -q '^number,ci'; then
  printf '%s\n' "$data" > "$CACHE"
  render "$data"
fi
