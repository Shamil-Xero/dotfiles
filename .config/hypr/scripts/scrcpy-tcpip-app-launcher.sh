#!/usr/bin/env bash

DEVICE="10.192.246.99:5555"
DISPLAY_SIZE="2712x1220"

choice=$(
    scrcpy --tcpip="$DEVICE" --list-apps 2>/dev/null |
    grep '^ [*-] ' |
    sed 's/^ [*-] //' |
    wofi --show dmenu --prompt "Select app"
)

[ -z "$choice" ] && exit 0

PACKAGE="${choice##* }"

exec scrcpy \
    --tcpip="$DEVICE" \
    --new-display="$DISPLAY_SIZE" \
    --start-app="$PACKAGE" \
    --stay-awake \
    --keep-active \
    # --no-vd-destroy-content \
    -x