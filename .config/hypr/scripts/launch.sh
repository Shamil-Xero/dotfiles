#!/bin/bash

pkill waybar
# pkill hyprpaper
hyprctl reload
waybar &
# hyprpaper &