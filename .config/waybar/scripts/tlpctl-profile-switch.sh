#!/usr/bin/env bash

# 1. Grab the currently active TLP profile
CURRENT_PROFILE=$(tlpctl get)

# 2. If an argument "toggle" is passed, cycle the profile first
if [ "$1" = "toggle" ]; then
    case "$CURRENT_PROFILE" in
        "power-saver")
            tlpctl balanced
            CURRENT_PROFILE="balanced"
            ;;
        "balanced")
            tlpctl performance
            CURRENT_PROFILE="performance"
            ;;
        *) # Fallback case covers "performance" or any unexpected output
            tlpctl power-saver
            CURRENT_PROFILE="power-saver"
            ;;
    esac
    # Optional: If using the signal refresh method, keep this line active:
    # pkill -RTMIN+5 waybar
fi

# 3. Output the current/new state cleanly as a JSON object for Waybar
case "$CURRENT_PROFILE" in
    "power-saver")
        echo '{"text": " BAL", "class": "balanced", "tooltip": "Balanced"}'
        ;;
    "balanced")
        echo '{"text": " PERF", "class": "performance", "tooltip": "Performance"}'
        ;;
    *) # Default fallback to performance formatting
        echo '{"text": " SAV", "class": "power-saver", "tooltip": "Power-Saver"}'
        ;;
esac
