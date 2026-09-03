#!/usr/bin/env bash

##
# theme-switch.sh — Master theme switching script
# Usage:
#   theme-switch.sh --wallpaper <path>         Set wallpaper + generate + reload all
#   theme-switch.sh --palette <name>           Apply a named preset palette (no wallpaper change)
#   theme-switch.sh --reload                   Reload all apps from current theme files
##

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_DIR="$HOME/.config/hypr/themes"
PALETTE_DIR="$HOME/.config/rofi/colors"
THEME_CACHE="$THEME_DIR/.current"
PALETTE_CACHE="$THEME_DIR/.current_palette"
WALLPAPER_DIR="$HOME/dotfiles/backgrounds"

TRANSITIONS=("simple" "fade" "left" "right" "top" "bottom" "wipe" "wave" "grow" "center" "outer" "random")

log() { echo "[theme-switch] $*"; }

# ── Apply wallpaper via awww with random transition ───────────────────────────
apply_wallpaper() {
    local wallpaper="$1"
    local transition="${TRANSITIONS[RANDOM % ${#TRANSITIONS[@]}]}"
    log "Setting wallpaper: $(basename "$wallpaper") [transition: $transition]"
    awww img "$wallpaper" \
        --transition-type "$transition" \
        --transition-duration 1.5 \
        --transition-fps 60
}

# ── Reload Hyprland borders from generated colors.lua ────────────────────────
reload_hyprland() {
    if [[ -f "$THEME_DIR/colors.lua" ]]; then
        # Reload hyprland config to pick up new lua values
        hyprctl reload 2>/dev/null || true
        log "✓ Hyprland reloaded"
    fi
}

# ── Reload Waybar ─────────────────────────────────────────────────────────────
reload_waybar() {
    pkill -SIGUSR2 waybar 2>/dev/null || true
    log "✓ Waybar reloaded"
}

# ── Reload SwayNC ─────────────────────────────────────────────────────────────
reload_swaync() {
    swaync-client --reload-config 2>/dev/null || true
    log "✓ SwayNC reloaded"
}

# ── Apply a named palette (preset, no wallpaper change) ──────────────────────
apply_palette() {
    local name="$1"
    local palette_file="$PALETTE_DIR/${name}.rasi"

    if [[ ! -f "$palette_file" ]]; then
        log "ERROR: Palette not found: $palette_file" >&2
        exit 1
    fi

    log "Applying palette: $name"

    # Point rofi colors.rasi at this preset
    cat > "$PALETTE_DIR/colors.rasi" << EOF
/**
 * Active Color Theme Switcher
 * Change import to switch global color palette across all Rofi menus
 * Current: $name
 **/

@import "${name}.rasi"
EOF

    # Generate waybar/swaync/hyprland colors from the preset's hex values
    # by calling a palette-to-css converter
    "$SCRIPT_DIR/palette-to-css.sh" "$palette_file" "$name"

    echo "$name" > "$PALETTE_CACHE"

    reload_waybar
    reload_swaync
    reload_hyprland

    notify-send "🎨 Theme" "Palette: $name" --icon=preferences-desktop-theme 2>/dev/null || true
    log "✓ Palette '$name' applied"
}

# ── Full wallpaper-based theme switch ─────────────────────────────────────────
apply_wallpaper_theme() {
    local wallpaper="$1"

    if [[ ! -f "$wallpaper" ]]; then
        log "ERROR: File not found: $wallpaper" >&2
        exit 1
    fi

    # 1. Set wallpaper
    apply_wallpaper "$wallpaper"

    # 2. Update hyprpaper.conf so it persists on restart
    local escaped_path="${wallpaper//\//\\/}"
    if [[ -f "$HOME/.config/hypr/hyprpaper.conf" ]]; then
        sed -i "s|path = .*|path = $wallpaper|g" "$HOME/.config/hypr/hyprpaper.conf"
    fi

    # 3. Generate colors
    "$SCRIPT_DIR/color-gen.sh" "$wallpaper" dark

    # 4. Update rofi colors.rasi to use generated wallpaper.rasi
    cat > "$HOME/.config/rofi/colors/colors.rasi" << EOF
/**
 * Active Color Theme Switcher
 * Current: wallpaper-generated from $(basename "$wallpaper")
 **/

@import "wallpaper.rasi"
EOF

    # 5. Reload all apps
    reload_waybar
    reload_swaync
    reload_hyprland

    notify-send "🖼 Wallpaper" "$(basename "$wallpaper")" --icon=preferences-desktop-wallpaper 2>/dev/null || true
    log "✓ Wallpaper theme applied"
}

# ── Entry point ───────────────────────────────────────────────────────────────
case "${1:-}" in
    --wallpaper)
        [[ -z "${2:-}" ]] && { echo "Usage: theme-switch.sh --wallpaper <path>"; exit 1; }
        apply_wallpaper_theme "$2"
        ;;
    --palette)
        [[ -z "${2:-}" ]] && { echo "Usage: theme-switch.sh --palette <name>"; exit 1; }
        apply_palette "$2"
        ;;
    --reload)
        reload_waybar
        reload_swaync
        reload_hyprland
        log "✓ All apps reloaded"
        ;;
    *)
        echo "Usage:"
        echo "  theme-switch.sh --wallpaper <path>    Set wallpaper + extract colors + reload"
        echo "  theme-switch.sh --palette <name>      Apply preset palette (no wallpaper change)"
        echo "  theme-switch.sh --reload               Reload all apps from current theme"
        exit 1
        ;;
esac
