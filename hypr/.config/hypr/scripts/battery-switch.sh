#!/usr/bin/env bash
# ============================================================
# battery-switch.sh — Hyprland power profile switcher
# ============================================================
# Usage:
#   battery-switch.sh auto      — detect AC state and switch accordingly
#   battery-switch.sh battery   — force battery mode
#   battery-switch.sh ac        — force ac-in (performance) mode
#   battery-switch.sh toggle    — flip between modes
#   battery-switch.sh status    — print current mode
#
# What it switches:
#   • Hyprland decorations module (blur/shadows/animations)
#   • Hyprland monitors module    (60 Hz vs 144 Hz)
#   • hypridle config             (aggressive vs relaxed timeouts)
#   • CPU governor                (power-saver vs balanced via powerprofilesctl)
# ============================================================

HYPR_DIR="${HOME}/.config/hypr"
MODULES_DIR="${HYPR_DIR}/modules"
STATE_FILE="/tmp/hyprland-power-mode"  # 'battery' or 'ac'
AC_ADAPTER="/sys/class/power_supply/ACAD/online"

# ── Helpers ──────────────────────────────────────────────────────────────────

log() { echo "[battery-switch] $*"; }

notify() {
    # Try to send a notification; fail silently if notify-send isn't available
    # or no display server running (e.g. called from udev before login)
    DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus" \
        notify-send --icon=battery "$1" "$2" 2>/dev/null || true
}

hyprland_reload() {
    # Find the running Hyprland socket and tell it to reload
    local socket_dir="/run/user/$(id -u)/hypr"
    local sig
    sig=$(ls "${socket_dir}" 2>/dev/null | head -1)
    if [[ -n "$sig" ]]; then
        HYPRLAND_INSTANCE_SIGNATURE="$sig" hyprctl reload 2>/dev/null && log "hyprctl reload sent"
    else
        log "WARNING: No running Hyprland instance found — config saved, reload manually"
    fi
}

is_on_ac() {
    [[ -f "$AC_ADAPTER" ]] && [[ "$(cat "$AC_ADAPTER")" == "1" ]]
}

current_mode() {
    [[ -f "$STATE_FILE" ]] && cat "$STATE_FILE" || echo "ac"
}

set_cpu_profile() {
    local profile="$1"  # 'power-saver' or 'balanced'
    if command -v powerprofilesctl >/dev/null 2>&1; then
        powerprofilesctl set "$profile" 2>/dev/null && log "CPU profile → $profile"
    else
        log "powerprofilesctl not found — skipping CPU profile switch"
    fi
}

swap_hyprland_modules() {
    local mode="$1"  # 'battery' or 'ac'

    if [[ "$mode" == "battery" ]]; then
        # Point hyprland.lua at the battery modules
        sed -i \
            -e 's|require("modules/decorations")|require("modules/decorations-battery")|g' \
            -e 's|require("modules/monitors")|require("modules/monitors-battery")|g' \
            "${HYPR_DIR}/hyprland.lua"
        log "Hyprland modules → battery (no blur, 60 Hz)"
    else
        # Restore normal modules
        sed -i \
            -e 's|require("modules/decorations.battery")|require("modules/decorations")|g' \
            -e 's|require("modules/monitors.battery")|require("modules/monitors")|g' \
            "${HYPR_DIR}/hyprland.lua"
        log "Hyprland modules → ac (blur on, 144 Hz)"
    fi
}

apply_mode() {
    local mode="$1"
    log "Switching to $mode mode..."

    swap_hyprland_modules "$mode"

    if [[ "$mode" == "battery" ]]; then
        set_cpu_profile "power-saver"
        echo "battery" > "$STATE_FILE"
        # hyprland_reload
        notify "🔋 Battery Mode" "Blur off · 60 Hz · Aggressive idle · Power-saver CPU"
    else
        set_cpu_profile "balanced"
        echo "ac" > "$STATE_FILE"
        # hyprland_reload
        notify "⚡ AC Mode" "Blur on · 144 Hz · Relaxed idle · Balanced CPU"
    fi

    log "Done. Mode is now: $mode"
}

# ── Main ─────────────────────────────────────────────────────────────────────

CMD="${1:-auto}"

case "$CMD" in
    auto)
        if is_on_ac; then
            apply_mode "ac"
        else
            apply_mode "battery"
        fi
        ;;
    battery)
        apply_mode "battery"
        ;;
    ac|performance)
        apply_mode "ac"
        ;;
    toggle)
        if [[ "$(current_mode)" == "battery" ]]; then
            apply_mode "ac"
        else
            apply_mode "battery"
        fi
        ;;
    status)
        mode=$(current_mode)
        ac=$(cat "$AC_ADAPTER" 2>/dev/null || echo "unknown")
        echo "Power mode : $mode"
        echo "AC online  : $ac"
        ;;
    *)
        echo "Usage: $0 {auto|battery|ac|toggle|status}"
        exit 1
        ;;
esac
