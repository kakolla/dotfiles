# ~/.config/sketchybar/items/front_app.sh

sketchybar --add item front_app left \
  --set front_app \
    script="$CONFIG_DIR/plugins/front_app.sh" \
    icon.drawing=off \
    label.padding_left=10 \
    label.padding_right=10 \
  --subscribe front_app front_app_switched
