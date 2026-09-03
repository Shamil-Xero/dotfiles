#!/usr/bin/env bash

##
# theme-picker.sh — Combined theme hub
# Shows a top-level menu to choose between:
#   1. Wallpaper Picker   (set wallpaper + extract colors)
#   2. Palette Picker     (preset palettes, no wallpaper change)
#   3. Random Wallpaper   (random wallpaper from backgrounds dir)
#   4. Reload Theme       (re-apply current theme to all apps)
##

ROFI_DIR="$HOME/.config/rofi"
THEME_SCRIPT="$HOME/.config/hypr/scripts/theme-switch.sh"
WALLPAPER_DIR="$HOME/dotfiles/backgrounds"
THEME_CACHE="$HOME/.config/hypr/themes/.current"
PALETTE_CACHE="$HOME/.config/hypr/themes/.current_palette"

# Get current theme info for subtitle
if [[ -f "$THEME_CACHE" ]]; then
    CURRENT="󰋩 $(basename "$(cat "$THEME_CACHE")")"
elif [[ -f "$PALETTE_CACHE" ]]; then
    CURRENT="🎨 $(cat "$PALETTE_CACHE")"
else
    CURRENT="No theme set"
fi

OPTIONS="󰋩  Wallpaper Picker\n🎨  Palette Picker\n󰔔  Random Wallpaper\n  Reload Current Theme"

chosen=$(printf '%b' "$OPTIONS" | \
    rofi -dmenu \
         -i \
         -p "  Theme Hub" \
         -mesg "Current: $CURRENT" \
         -theme "$ROFI_DIR/themes/theme-switcher.rasi" \
         -no-custom)

[[ -z "$chosen" ]] && exit 0

case "$chosen" in
    *"Wallpaper Picker"*)
        bash "$ROFI_DIR/scripts/wallpaper-picker.sh"
        ;;
    *"Palette Picker"*)
        bash "$ROFI_DIR/scripts/palette-picker.sh"
        ;;
    *"Random Wallpaper"*)
        mapfile -t walls < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \
            \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \))
        if [[ "${#walls[@]}" -gt 0 ]]; then
            wall="${walls[RANDOM % ${#walls[@]}]}"
            "$THEME_SCRIPT" --wallpaper "$wall"
        fi
        ;;
    *"Reload"*)
        "$THEME_SCRIPT" --reload
        ;;
esac
