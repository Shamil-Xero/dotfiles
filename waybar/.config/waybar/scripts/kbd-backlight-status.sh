#!/bin/bash

brightness=$(brightnessctl -d '*kbd_backlight' g)

if [ "$brightness" -eq 0 ]; then
    echo '{"text":"󰥻","tooltip":"Keyboard Backlight: OFF","class":"off"}'
else
    echo '{"text":"󰌌","tooltip":"Keyboard Backlight: ON","class":"on"}'
fi