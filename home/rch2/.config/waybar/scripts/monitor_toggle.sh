#!/usr/bin/env bash

CONFIG_FILES=(
    "$HOME/.config/waybar/config.jsonc"
)

# list of active monitors
monitors=$(hyprctl monitors -j | jq -r '.[] | .name')

# 2. rofi menu
chosen=$(echo -e "All\n$monitors" | rofi -dmenu -p "Change active monitor for:")

if [ -z "$chosen" ]; then
    exit 0
fi

# Define the replacement string
if [ "$chosen" == "All" ]; then
    REPLACEMENT="\"output\": [\"*\"]"
else
    REPLACEMENT="\"output\": [\"$chosen\"]"
fi

# 3. accept changes trough Perl
for FILE in "${CONFIG_FILES[@]}"; do
    if [ -f "$FILE" ]; then
        perl -i -0777 -pe "s/\"output\":\s*\[.*?\]/$REPLACEMENT/s" "$FILE"
    fi
done

# restart
pkill waybar
sleep 0.2


hyde-shell waybar -ubg

notify-send "Waybar" "monitor configuration updated: $chosen" -t 2000
