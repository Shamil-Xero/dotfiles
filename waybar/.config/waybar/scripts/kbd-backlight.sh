#!/bin/bash

current=$(brightnessctl -d '*kbd_backlight' g)

case "$current" in
    0) brightnessctl -d '*kbd_backlight' s 1 >/dev/null ;;
    1) brightnessctl -d '*kbd_backlight' s 2 >/dev/null ;;
    2) brightnessctl -d '*kbd_backlight' s 0 >/dev/null ;;
esac