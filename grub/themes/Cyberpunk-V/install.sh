#!/bin/bash

# ─── Root Check ────────────────────────────────────────────────────────────

if [[ "$EUID" -ne 0 ]]; then
  echo "🔒 This script must be run as root."
  echo "💡 Try: sudo $0"
  exit 1
fi

# ─── Get Script and Theme Paths ────────────────────────────────────────────

SCRIPT_PATH="$(readlink -f "$0")"
THEME_DIR="$(dirname "$SCRIPT_PATH")"
THEME_FILE="$THEME_DIR/theme.txt"

# ─── Check if theme.txt Exists ─────────────────────────────────────────────

if [[ ! -f "$THEME_FILE" ]]; then
    echo "❌ Error: theme.txt not found in $THEME_DIR"
    exit 1
fi

echo "🎨 Setting GRUB theme to: $THEME_FILE"

# ─── Clean Existing GRUB Theme Entries ─────────────────────────────────────

sudo sed -i '/^GRUB_THEME=/d' /etc/default/grub
sudo sed -i '/^GRUB_GFXMODE=/d' /etc/default/grub
sudo sed -i '/^GRUB_TIMEOUT=/d' /etc/default/grub
sudo sed -i '/^GRUB_TIMEOUT_STYLE=/d' /etc/default/grub

# ─── Append New Theme Settings ─────────────────────────────────────────────

{
  echo "GRUB_THEME=\"$THEME_FILE\""
  echo "GRUB_GFXMODE=\"auto\""
  echo "GRUB_TIMEOUT=\"10\""
  echo "GRUB_TIMEOUT_STYLE=\"menu\""
} | sudo tee -a /etc/default/grub > /dev/null

# ─── Regenerate GRUB Config ────────────────────────────────────────────────

echo "🔧 Updating GRUB config..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "✅ GRUB theme activated from: $THEME_FILE"
