#!/bin/bash

# If wofi is running, kill it
if pgrep -x wofi > /dev/null; then
    pkill -x wofi
else
    wofi --show drun &
fi
