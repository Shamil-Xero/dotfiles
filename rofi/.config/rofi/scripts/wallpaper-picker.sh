#!/usr/bin/env bash

##
# wallpaper-picker.sh — Rofi wallpaper picker
# Scans ~/dotfiles/backgrounds/, shows wallpaper thumbnails in a grid,
# and on selection sets the wallpaper + generates a new color theme.
##

WALLPAPER_DIR="$HOME/dotfiles/backgrounds"
ROFI_DIR="$HOME/.config/rofi"
THEME_SCRIPT="$HOME/.config/hypr/scripts/theme-switch.sh"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
    notify-send "Wallpaper Picker" "Wallpaper directory not found: $WALLPAPER_DIR" --urgency=critical
    exit 1
fi

# Build list of wallpapers
mapfile -t files < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
    | sort)

if [[ "${#files[@]}" -eq 0 ]]; then
    notify-send "Wallpaper Picker" "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Format entries: "basename\0icon\x1fFULL_PATH\n"
# Rofi uses the icon field to display the actual image as a thumbnail
entries=""
for f in "${files[@]}"; do
    name=$(basename "$f")
    # Strip extension for cleaner display label
    label="${name%.*}"
    entries+="${label}\0icon\x1f${f}\n"
done

# Launch rofi picker with thumbnail grid theme
chosen=$(printf '%b' "$entries" | \
    rofi -dmenu \
         -i \
         -p "󰋩  Wallpaper" \
         -theme "$ROFI_DIR/themes/wallpaper-picker.rasi" \
         -no-custom \
         -show-icons \
         -format "s")

[[ -z "$chosen" ]] && exit 0

# Find full path of chosen wallpaper by matching the stripped label
for f in "${files[@]}"; do
    name=$(basename "$f")
    label="${name%.*}"
    if [[ "$label" == "$chosen" ]]; then
        "$THEME_SCRIPT" --wallpaper "$f"
        exit 0
    fi
done

notify-send "Wallpaper Picker" "Could not locate: $chosen" --urgency=critical
