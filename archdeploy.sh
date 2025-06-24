#!/bin/bash
set -e  # Exit on error

# Log file (optional)
LOG="/var/log/arch_deploy.log"
exec > >(tee -a "$LOG") 2>&1

# Prompt for sudo once
# if ! sudo -v; then
#   echo "Sudo privileges are required to run this script."
#   exit 1
# fi

# Keep sudo alive
# ( while true; do sudo -n true; sleep 60; done ) &
# SUDO_PID=$!

USERNAME=$(whoami)

echo "Starting Arch Linux deployment..."

echo "Updating system..."
sudo pacman -Syu --noconfirm

echo "Installing essential packages..."
sudo pacman -S --noconfirm base-devel git firefox curl wofi kitty ntfs-3g stow flatpak nvidia-utils nvidia-settings


# echo "Installing ublock Origin for firefox..."
# wget https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/addon-607454-latest.xpi -O ublock.xpi
# firefox --install-addon ./ublock.xpi

echo "Enabling NetworkManager..."
sudo pacman -S --noconfirm networkmanager
sudo systemctl enable NetworkManager.service

echo "Enabling Bluetooth Services..."
sudo pacman -S --noconfirm bluez bluez-utils blueman
sudo systemctl enable --now bluetooth.service

echo "Installing Hyprland and tools..."
sudo pacman -S --noconfirm \
  xdg-desktop-portal xdg-desktop-portal-hyprland wl-clipboard xdg-utils wayland \
  wayland-protocols qt5-wayland qt6-wayland glfw-wayland gtk3 gtk4 dunst slurp uwsm \
  polkit-kde-agent hyprland hyprshot hyprlock hypridle waybar pavucontrol \
  network-manager-applet brightnessctl playerctl

echo "Installing yay and paru(AUR helper)..."
cd ~
sudo rm -rf yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ~
sudo rm -rf yay

cd ~
sudo rm -rf paru
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ~
sudo rm -rf paru

echo "Installing auto-cpufreq..."
yay -S --noconfirm auto-cpufreq
sudo auto-cpufreq --install

# echo "Installing tlp(PowerManagement)..."
#sudo pacman -S --noconfirm tlp tlp-rdw

# echo "Installing additional softwares using yay..."
#sudo -u "$USERNAME" yay -S --noconfirm  brave-bin visual-studio-code tlpui

echo "Configuring auto-cpufreq..."
sudo auto-cpufreq --bluetooth_boot_on

# Stop background sudo refresher
# kill "$SUDO_PID"

echo "Arch Linux deployment complete!"
