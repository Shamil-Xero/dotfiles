# Shamil's Arch Linux Dotfiles 🚀

A curated collection of dotfiles, configurations, and scripts for a modern, sleek, and highly functional Arch Linux desktop environment powered by **Hyprland** and **Kanata**.

---

## 🌟 Features Overview

| Component | Technology | Description |
| :--- | :--- | :--- |
| **Window Manager** | [Hyprland](https://hyprland.org/) | A dynamic tiling Wayland compositor that doesn't sacrifice on looks. |
| **Status Bar** | [Waybar](https://github.com/Alexays/Waybar) | Highly customizable Wayland bar for system monitoring and workspace navigation. |
| **Keyboard Remapper** | [Kanata](https://github.com/jtroo/kanata) | Advanced keyboard remapping tool (caps-to-control/escape, layers, tap-holds). |
| **Terminal Emulator** | [Kitty](https://sw.kovidgoyal.net/kitty/) | Fast, feature-rich, GPU-accelerated terminal. |
| **Application Launcher** | [Wofi](https://hg.sr.ht/~scoopta/wofi) / [Rofi](https://github.com/davatorium/rofi) | Clean menu systems for launching apps and run prompts. |
| **Notifications** | [Swaync](https://github.com/ErikReider/SwayNotificationCenter) | Modern notification center with widgets and control center options. |
| **Power Management** | [TLP](https://linrunner.de/tlp/) & [tlpui](https://github.com/dresden-mitte/tlpui) | Advanced power saving configurations with a GTK user interface. |
| **Boot Loader Themes** | [GRUB Themes](https://www.gnu.org/software/grub/) | Beautiful customized themes (Cyberpunk-V, CyberGRUB-2077, ROG, Vimix, etc.). |

---

## 📁 Repository Structure

```text
├── .bash_profile         # Bash login configuration
├── .bashrc               # Bash interactive shell configuration
├── .config/              # Core configuration directory
│   ├── hypr/             # Hyprland, hypridle, hyprlock, and hyprpaper configs
│   ├── kanata/           # Kanata key remapping scripts
│   ├── kitty/            # Kitty terminal setup
│   ├── rofi/             # Rofi menus and styles
│   ├── swaync/           # Sway Notification Center configuration
│   ├── tlpui/            # TLP UI settings
│   ├── waybar/           # Waybar layout and stylesheets
│   └── wofi/             # Wofi menus
├── archdeploy.sh         # System installation & package deployment script
├── backgrounds/          # System wallpapers and lock screen backgrounds
├── fstab                 # Reference filesystem mount table
└── grub/                 # Bootloader configuration and visual themes
    └── themes/           # Custom GRUB themes (e.g. CyberGRUB-2077, ROG, Vimix)
```

---

## ⚙️ Installation & Deployment

> [!WARNING]
> These configuration files are tailored to my specific hardware setup (including NVIDIA drivers). Make sure to inspect the scripts and configuration files before running them on your system.

### 1. Prerequisite Packages
The deployment script is designed for **Arch Linux**. It will automatically update your system, enable NetworkManager and Bluetooth, set up `yay`/`paru` AUR helpers, install Hyprland, and configure power savings.

### 2. Run the Deployment Script
Run the automated installation script to install the dependencies:

```bash
chmod +x archdeploy.sh
./archdeploy.sh
```

### 3. Deploying Dotfiles with GNU Stow
These dotfiles are organized to be deployed using [GNU Stow](https://www.gnu.org/software/stow/). Ensure `stow` is installed and run it from the root of this repository:

```bash
# Symlink configurations to your ~/.config directory
stow .
```

### 4. Customizing GRUB Themes
Navigate to `grub/themes` to explore and install the bootloader themes:

```bash
cd grub/themes
sudo ./install.sh
```
Choose from themes like:
* `Cyberpunk-V`
* `CyberGRUB-2077`
* `ROG`
* `Vimix`
* `Xenlism-Arch`

---

## 🎹 Keyboard Layout (Kanata)
The custom Kanata configuration (`.config/kanata/kanata.kbd`) enables advanced layout behaviors:
* Tap-Hold behaviors on key modifiers.
* Layers configuration for coding/navigation productivity.
* Daemon auto-starts to map keys globally at the driver level.

---

## 🎨 Visual Preview & Customization
* **Hyprland:** Configured with custom bindings, animations, window rules, and workspace gestures. See the configs in [hyprland.lua](file:///home/shamil/dotfiles/.config/hypr/hyprland.lua).
* **Wallpapers:** Check the [backgrounds](file:///home/shamil/dotfiles/backgrounds) folder for high-resolution graphics matching the themes.
* **Waybar:** Layout styles and configurations are defined under [waybar/config.jsonc](file:///home/shamil/dotfiles/.config/waybar/config.jsonc).
