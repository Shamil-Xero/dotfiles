#!/usr/bin/env bash

# Wofi

# DEVICE="10.135.239.18:5555"
# DISPLAY_SIZE="2712x1220"

# choice=$(
#     scrcpy --tcpip="$DEVICE" --list-apps 2>/dev/null |
#     grep '^ [*-] ' |
#     sed 's/^ [*-] //' |
#     wofi --show dmenu --prompt "Select app"
# )

# [ -z "$choice" ] && exit 0

# PACKAGE="${choice##* }"

# exec scrcpy \
#     --tcpip="$DEVICE" \
#     --new-display="$DISPLAY_SIZE" \
#     --start-app="$PACKAGE" \
#     --stay-awake \
#     --keep-active \
#     # --no-vd-destroy-content \
#     -x

# RofiZ

DEVICE="10.246.110.161:5555"
DISPLAY_SIZE="2712x1220"

# Get app list (name + package)
apps=$(scrcpy --tcpip="$DEVICE" --list-apps 2>/dev/null | grep '^ [*-] ')

# Format: show only app name in rofi, keep package hidden
formatted=$(echo "$apps" | sed 's/^ [*-] //' )

# Show in rofi
choice=$(echo "$formatted" | rofi -dmenu -i -p "Select app")

# Exit if nothing selected
[ -z "$choice" ] && exit 0

# Extract package (last word)
PACKAGE="${choice##* }"

# Launch selected app
exec scrcpy \
    --tcpip="$DEVICE" \
    --new-display="$DISPLAY_SIZE" \
    --start-app="$PACKAGE" \
    --stay-awake \
    --no-audio \
    --keep-active