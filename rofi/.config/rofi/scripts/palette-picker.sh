#!/usr/bin/env bash

##
# palette-picker.sh — Rofi preset palette picker
# Lists existing named palettes. Applies palette colors to all apps
# WITHOUT changing the current wallpaper.
##

PALETTE_DIR="$HOME/.config/rofi/colors"
ROFI_DIR="$HOME/.config/rofi"
THEME_SCRIPT="$HOME/.config/hypr/scripts/theme-switch.sh"

# Map palette filename -> display name with icon
declare -A DISPLAY_NAMES=(
    ["catppuccin-mocha"]="󰄛  Catppuccin Mocha"
    ["tokyo-night"]="  Tokyo Night"
    ["nord"]="󰔗  Nord"
    ["one-dark"]="  One Dark"
)

# Build list from available .rasi files (exclude generated ones)
entries=""
declare -A FILE_MAP

for f in "$PALETTE_DIR"/*.rasi; do
    name=$(basename "$f" .rasi)
    # Skip generated/meta files
    [[ "$name" == "colors" || "$name" == "wallpaper" ]] && continue

    display="${DISPLAY_NAMES[$name]:-  $name}"
    entries+="$display\n"
    FILE_MAP["$display"]="$name"
done

[[ -z "$entries" ]] && { notify-send "Palette Picker" "No palettes found"; exit 1; }

chosen=$(printf '%b' "$entries" | \
    rofi -dmenu \
         -i \
         -p "🎨  Palette" \
         -theme "$ROFI_DIR/themes/theme-switcher.rasi" \
         -no-custom \
         -format "s")

[[ -z "$chosen" ]] && exit 0

palette_name="${FILE_MAP[$chosen]}"
[[ -z "$palette_name" ]] && exit 1

"$THEME_SCRIPT" --palette "$palette_name"
