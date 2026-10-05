#!/usr/bin/env bash
# battery-udev-install.sh — install the udev rule for automatic battery switching
# Run once with: bash ~/.config/hypr/scripts/battery-udev-install.sh

RULE_FILE="/etc/udev/rules.d/99-hyprland-battery-switch.rules"

sudo tee "$RULE_FILE" << 'RULE'
# Hyprland battery-switch: fires when AC adapter ACAD online state changes
# Runs as uid 1000 (shamil) in the user session via systemd-run
ACTION=="change", SUBSYSTEM=="power_supply", KERNEL=="ACAD", \
    RUN+="/usr/bin/systemd-run --uid=1000 --no-block /bin/bash /home/shamil/.config/hypr/scripts/battery-switch.sh auto"
RULE

sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=power_supply

echo "✓ udev rule installed at $RULE_FILE"
echo "✓ Rules reloaded — plug/unplug AC to test"
