#!/bin/bash

WALLPAPER_DIR="$HOME/dotfiles/backgrounds/"

# Get wallpapers
mapfile -t wallpapers < <(
    find "$WALLPAPER_DIR" -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \)
)

# Exit if no wallpapers found
if [ "${#wallpapers[@]}" -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Pick a random wallpaper
wallpaper="${wallpapers[RANDOM % ${#wallpapers[@]}]}"

# Available awww transitions
transitions=(
    "simple"
    "fade"
    "left"
    "right"
    "top"
    "bottom"
    "wipe"
    "wave"
    "grow"
    "center"
    "outer"
    "random"
)

# Pick a random transition
transition="${transitions[RANDOM % ${#transitions[@]}]}"

# Apply wallpaper
awww img "$wallpaper" \
    --transition-type "$transition" \
    --transition-duration 1.5

echo "Wallpaper: $wallpaper"
echo "Transition: $transition"