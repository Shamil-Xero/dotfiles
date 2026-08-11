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
| **AI Agent** | Hermes | Intelligent local AI agent configured with custom skills, memories, and tracking. |

---

## 📁 Repository Structure

```text
dotfiles/
├── shell/                    # Stow package: .bashrc, .bash_profile, .gitconfig
├── hypr/                     # Stow package: Hyprland, hypridle, hyprlock, hyprpaper
│   └── .config/hypr/
├── kitty/                    # Stow package: Kitty terminal
│   └── .config/kitty/
├── waybar/                   # Stow package: Waybar status bar
│   └── .config/waybar/
├── fish/                     # Stow package: Fish shell
│   └── .config/fish/
├── kanata/                   # Stow package: Kanata keyboard remapper
│   └── .config/kanata/
├── rofi/                     # Stow package: Rofi launcher
│   └── .config/rofi/
├── wofi/                     # Stow package: Wofi launcher
│   └── .config/wofi/
├── swaync/                   # Stow package: Notification center
│   └── .config/swaync/
├── tlpui/                    # Stow package: TLP UI settings
│   └── .config/tlpui/
├── colorprofile/             # Stow package: Display ICC profile
│   └── .config/
│
├── packages/                 # Package lists for backup/restore
│   ├── core.txt              #   Essential system packages
│   ├── desktop.txt           #   Hyprland desktop environment
│   ├── networking.txt        #   Network & Bluetooth
│   ├── audio.txt             #   PipeWire audio stack
│   ├── multimedia.txt        #   Media & entertainment
│   ├── development.txt       #   Dev tools & Docker
│   ├── nvidia.txt            #   NVIDIA GPU drivers
│   ├── apps.txt              #   User applications
│   ├── flatpak.txt           #   Flatpak apps (auto-generated)
│   └── services.txt          #   Systemd services to enable
│
├── backgrounds/              # Wallpapers and lock screen images
├── grub/                     # GRUB bootloader themes (archival)
├── hermes/                   # Hermes AI Agent config and data
├── docker/                   # Docker reference configs
├── fstab                     # Reference filesystem mount table
│
├── archdeploy.sh             # 🚀 Deploy/restore on a fresh Arch install
├── archbackup.sh             # 💾 Backup current system state
└── README.md
```

Each top-level directory (shell, hypr, kitty, etc.) is a **GNU Stow package** — it mirrors the target directory structure so you can selectively symlink only the configs you need.

---

## ⚙️ Installation & Deployment

> [!WARNING]
> These configuration files are tailored to my specific hardware setup (including NVIDIA drivers). Make sure to inspect the scripts and configuration files before running them on your system.

### Quick Start (Fresh Arch Install)

```bash
# 1. Clone the repo
git clone https://github.com/Shamil-Xero/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Run the deployment wizard
chmod +x archdeploy.sh
./archdeploy.sh
```

The deployment script runs an **interactive wizard** where you select:
1. **Package groups** to install (core, desktop, networking, audio, etc.)
2. **Configs** to symlink (hypr, kitty, waybar, etc.)
3. **Systemd services** to enable
4. **fstab entries** for disk mounts (shows `lsblk -f` for reference)
5. **Optional extras** (backgrounds, NVIDIA, Flatpak)

After confirmation, everything installs automatically with live status output.

### Backing Up Your System

```bash
# Captures packages, services, configs, and fstab into the repo
./archbackup.sh

# Preview what would change without modifying files
./archbackup.sh --dry-run
```

### Stow Usage (Manual)

Each config can be individually managed with GNU Stow:

```bash
# Symlink a specific config
stow -d ~/dotfiles -t ~ hypr

# Remove a specific config
stow -d ~/dotfiles -t ~ -D kitty

# Symlink all configs
for pkg in shell hypr kitty waybar fish kanata rofi wofi swaync tlpui colorprofile; do
    stow -d ~/dotfiles -t ~ "$pkg"
done
```

---

## 🎹 Keyboard Layout (Kanata)
The custom Kanata configuration (`kanata/.config/kanata/kanata.kbd`) enables advanced layout behaviors:
* Tap-Hold behaviors on key modifiers.
* Layers configuration for coding/navigation productivity.
* Daemon auto-starts to map keys globally at the driver level.

---

## 🤖 Hermes AI Agent
This repository tracks the configuration and persistent memory for my local **Hermes Agent**. To avoid cluttering the repository with heavy cache files, a strict `.gitignore` whitelist is used that only tracks the essentials:
* `SOUL.md` & `config.yaml` - Core system prompt, personality, and settings.
* `skills/` & `hooks/` - Custom scripts and integrations.
* `memories/` & `sessions/` - Important context and chat history.
* `auth.json` & `.env` - Service credentials.
* `kanban.db` - Internal task tracker.

---

## 🎨 Visual Preview & Customization
* **Hyprland:** Configured with custom bindings, animations, window rules, and workspace gestures. See the configs in `hypr/.config/hypr/`.
* **Wallpapers:** Check the `backgrounds/` folder for high-resolution graphics matching the themes.
* **Waybar:** Layout styles and configurations are defined under `waybar/.config/waybar/`.
