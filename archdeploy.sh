#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════╗
# ║  archdeploy.sh — Arch Linux Dotfiles Restore/Deploy Script     ║
# ║  Interactive wizard → Automatic execution → Summary → Reboot   ║
# ╚══════════════════════════════════════════════════════════════════╝
set -euo pipefail

# ── Configuration ──────────────────────────────────────────────────
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$HOME/.dotfiles_deploy.log"
DRY_RUN=false
USERNAME=$(whoami)

# Available package categories
PACKAGE_CATEGORIES=(core desktop networking audio multimedia development nvidia apps)

# Available stow packages
STOW_PACKAGES=(shell hypr kitty waybar fish kanata rofi wofi swaync tlpui colorprofile)

# Stow package descriptions
declare -A STOW_DESCRIPTIONS=(
    [shell]=".bashrc, .bash_profile, .gitconfig"
    [hypr]="Hyprland, hypridle, hyprlock, hyprpaper"
    [kitty]="Kitty terminal emulator"
    [waybar]="Waybar status bar"
    [fish]="Fish shell config"
    [kanata]="Kanata keyboard remapper"
    [rofi]="Rofi application launcher"
    [wofi]="Wofi application launcher"
    [swaync]="Sway Notification Center"
    [tlpui]="TLP UI settings"
    [colorprofile]="Display color profile (ICC)"
)

# Package category descriptions
declare -A CATEGORY_DESCRIPTIONS=(
    [core]="Essential system packages"
    [desktop]="Hyprland desktop environment"
    [networking]="Network & Bluetooth"
    [audio]="PipeWire audio stack"
    [multimedia]="Media & entertainment apps"
    [development]="Dev tools & Docker"
    [nvidia]="NVIDIA GPU drivers"
    [apps]="User applications"
)

# ── Colors ─────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# ── Helpers ────────────────────────────────────────────────────────
log() { echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $*" | tee -a "$LOG_FILE"; }
step() { echo -e "${CYAN}${BOLD}$*${NC}" | tee -a "$LOG_FILE"; }
success() { echo -e "         ${GREEN}✓${NC} $*" | tee -a "$LOG_FILE"; }
warn() { echo -e "         ${YELLOW}⚠${NC} $*" | tee -a "$LOG_FILE"; }
info() { echo -e "         ${DIM}→${NC} $*" | tee -a "$LOG_FILE"; }
fail() { echo -e "         ${RED}✗${NC} $*" | tee -a "$LOG_FILE"; }

run_or_dry() {
    if $DRY_RUN; then
        info "${DIM}[dry-run]${NC} $*"
        return 0
    else
        eval "$@"
    fi
}

# ── Spinner ─────────────────────────────────────────────────────────
_SPINNER_PID=""

_spinner_loop() {
    local msg="$1"
    local tmpout="${2:-}"
    local -a frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    local i=0
    local start=$SECONDS
    tput civis 2>/dev/null || true
    printf "\n"  # reserve a detail line below the spinner
    while true; do
        local elapsed=$(( SECONDS - start ))
        local elapsed_str
        if (( elapsed < 60 )); then
            elapsed_str="${elapsed}s"
        else
            elapsed_str="$(( elapsed / 60 ))m $(( elapsed % 60 ))s"
        fi

        # pull last non-empty line from live output, strip ANSI codes
        local detail=""
        if [[ -n "$tmpout" && -s "$tmpout" ]]; then
            detail=$(grep -v '^[[:space:]]*$' "$tmpout" 2>/dev/null | tail -1 \
                     | sed 's/\x1b\[[0-9;]*[A-Za-z]//g' | tr -d '\r' | cut -c1-72)
        fi

        # move up to spinner line and redraw
        printf "\033[1A\r  \033[0;36m${frames[$i]}\033[0m  %-54s \033[2m[%s]\033[0m\n" \
               "$msg" "$elapsed_str"
        # redraw detail line
        printf "  \033[2m  ↳ %-74s\033[0m" "${detail:- }"

        i=$(( (i + 1) % 10 ))
        sleep 0.12
    done
}

start_spinner() {
    _spinner_loop "$1" "${2:-}" &
    _SPINNER_PID=$!
    disown "$_SPINNER_PID" 2>/dev/null || true
}

stop_spinner() {
    if [[ -n "$_SPINNER_PID" ]]; then
        kill "$_SPINNER_PID" 2>/dev/null || true
        _SPINNER_PID=""
    fi
    tput cnorm 2>/dev/null || true
    # clear detail line, move up one, clear spinner line
    printf "\r\033[2K\033[1A\r\033[2K"
}

_cleanup_spinner() { stop_spinner; }
trap _cleanup_spinner EXIT INT TERM

# Run a command with a spinner. All output is captured to the log.
# On failure, the last 3 lines of output are printed inline for context.
run_spinner() {
    local msg="$1"; shift
    if $DRY_RUN; then
        info "${DIM}[dry-run]${NC} $*"
        return 0
    fi
    local _tmpout
    _tmpout=$(mktemp /tmp/.archdeploy_XXXXXX)
    start_spinner "$msg"
    local _rc=0
    ( eval "$@" ) > "$_tmpout" 2>&1 || _rc=$?
    stop_spinner
    cat "$_tmpout" >> "$LOG_FILE"
    if [[ $_rc -ne 0 ]]; then
        tail -3 "$_tmpout" | while IFS= read -r line; do
            info "${DIM}${line}${NC}"
        done
    fi
    rm -f "$_tmpout"
    return $_rc
}

count_packages() {
    local file="$DOTFILES_DIR/packages/$1.txt"
    if [[ -f "$file" ]]; then
        grep -cv '^#\|^$' "$file" 2>/dev/null || echo 0
    else
        echo 0
    fi
}

# ── Parse arguments ────────────────────────────────────────────────
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=true ;;
        --help|-h)
            echo "Usage: archdeploy.sh [--dry-run] [--help]"
            echo ""
            echo "Deploys Arch Linux dotfiles and packages on a fresh installation."
            echo "All user interactions happen upfront in a wizard, then the deployment"
            echo "runs automatically until completion."
            echo ""
            echo "Options:"
            echo "  --dry-run   Preview what would happen without making changes"
            echo "  --help      Show this help message"
            exit 0
            ;;
    esac
done

# ══════════════════════════════════════════════════════════════════
# PHASE A: INTERACTIVE WIZARD
# ══════════════════════════════════════════════════════════════════
clear
echo ""
echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}${BOLD}║           Arch Linux Deployment Wizard                      ║${NC}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
if $DRY_RUN; then
    echo -e "  ${YELLOW}${BOLD}▸ DRY RUN MODE — no changes will be made${NC}"
    echo ""
fi
echo -e "  ${DIM}All selections will be made upfront. Once you confirm,${NC}"
echo -e "  ${DIM}the deployment will run automatically until completion.${NC}"
echo ""

# ── Helper: Toggle menu ───────────────────────────────────────────
# Usage: toggle_menu "title" items_array descriptions_array selected_array
# Modifies the selected_array in-place
toggle_menu() {
    local title="$1"
    local -n _items=$2
    local -n _descs=$3
    local -n _selected=$4
    
    while true; do
        echo ""
        echo -e "  ${BOLD}${title}${NC}"
        echo -e "  ${DIM}$(printf '─%.0s' {1..55})${NC}"
        
        for i in "${!_items[@]}"; do
            local item="${_items[$i]}"
            local desc="${_descs[$item]:-}"
            local count=""
            
            # If it's a package category, show count
            if [[ -f "$DOTFILES_DIR/packages/${item}.txt" ]]; then
                count=" ($(count_packages "$item") pkgs)"
            fi
            
            if [[ "${_selected[$i]}" == "1" ]]; then
                echo -e "    ${GREEN}[x]${NC} ${BOLD}$((i+1)).${NC} ${item}${count}${DIM} — ${desc}${NC}"
            else
                echo -e "    ${DIM}[ ]${NC} ${BOLD}$((i+1)).${NC} ${item}${count}${DIM} — ${desc}${NC}"
            fi
        done
        
        echo ""
        echo -e "  ${DIM}Enter numbers to toggle (e.g. 1 3 5), 'a' for all, 'n' for none${NC}"
        echo -e "  ${DIM}Press Enter when done${NC}"
        read -rp "  > " input
        
        [[ -z "$input" ]] && break
        
        if [[ "$input" == "a" ]]; then
            for i in "${!_items[@]}"; do _selected[$i]="1"; done
            continue
        elif [[ "$input" == "n" ]]; then
            for i in "${!_items[@]}"; do _selected[$i]="0"; done
            continue
        fi
        
        for num in $input; do
            if [[ "$num" =~ ^[0-9]+$ ]] && (( num >= 1 && num <= ${#_items[@]} )); then
                local idx=$((num - 1))
                if [[ "${_selected[$idx]}" == "1" ]]; then
                    _selected[$idx]="0"
                else
                    _selected[$idx]="1"
                fi
            fi
        done
    done
}

# ── Step 1: Select package groups ─────────────────────────────────
echo -e "${MAGENTA}${BOLD}  ┌─ Step 1/5: Package Groups ──────────────────────────────┐${NC}"

# Initialize all selected by default
declare -a pkg_selected=()
for i in "${!PACKAGE_CATEGORIES[@]}"; do
    pkg_selected[$i]="1"
done

toggle_menu "Select package groups to install:" PACKAGE_CATEGORIES CATEGORY_DESCRIPTIONS pkg_selected

# ── Step 2: Select configs to symlink ─────────────────────────────
echo ""
echo -e "${MAGENTA}${BOLD}  ┌─ Step 2/5: Config Symlinks ─────────────────────────────┐${NC}"

declare -a stow_selected=()
for i in "${!STOW_PACKAGES[@]}"; do
    stow_selected[$i]="1"
done

toggle_menu "Select configs to symlink:" STOW_PACKAGES STOW_DESCRIPTIONS stow_selected

# ── Step 3: Services ──────────────────────────────────────────────
echo ""
echo -e "${MAGENTA}${BOLD}  ┌─ Step 3/5: Systemd Services ────────────────────────────┐${NC}"

SERVICES_FILE="$DOTFILES_DIR/packages/services.txt"
declare -a system_services=()
declare -a user_services=()
current_section=""

if [[ -f "$SERVICES_FILE" ]]; then
    while IFS= read -r line; do
        [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
        if [[ "$line" == "[system]" ]]; then
            current_section="system"
        elif [[ "$line" == "[user]" ]]; then
            current_section="user"
        elif [[ "$current_section" == "system" ]]; then
            system_services+=("$line")
        elif [[ "$current_section" == "user" ]]; then
            user_services+=("$line")
        fi
    done < "$SERVICES_FILE"
fi

echo ""
echo -e "  ${BOLD}The following services will be enabled:${NC}"
echo ""
echo -e "  ${BOLD}System services:${NC}"
for svc in "${system_services[@]}"; do
    echo -e "    ${GREEN}•${NC} $svc"
done
echo ""
echo -e "  ${BOLD}User services:${NC}"
for svc in "${user_services[@]}"; do
    echo -e "    ${GREEN}•${NC} $svc"
done
echo ""

enable_services=true
read -rp "  Enable these services? [Y/n]: " svc_confirm
if [[ "$svc_confirm" =~ ^[Nn]$ ]]; then
    enable_services=false
fi

# ── Step 4: fstab Configuration ───────────────────────────────────
echo ""
echo -e "${MAGENTA}${BOLD}  ┌─ Step 4/5: Filesystem Configuration ──────────────────┐${NC}"

declare -a fstab_entries=()
configure_fstab=false

echo ""
echo -e "  ${BOLD}Current block devices:${NC}"
echo ""
lsblk -f 2>/dev/null | sed 's/^/    /'
echo ""

read -rp "  Configure fstab mount entries? [y/N]: " fstab_confirm
if [[ "$fstab_confirm" =~ ^[Yy]$ ]]; then
    configure_fstab=true
    echo ""
    echo -e "  ${DIM}Enter mount entries. Type 'done' when finished.${NC}"
    echo -e "  ${DIM}Format: UUID  MOUNTPOINT  FSTYPE  OPTIONS${NC}"
    echo -e "  ${DIM}Example: 8A1ADCA51ADC8F95  /mnt/d  ntfs3  defaults,noatime,rw,uid=1000,gid=1000${NC}"
    echo ""
    
    while true; do
        read -rp "  fstab> " fstab_input
        [[ "$fstab_input" == "done" || -z "$fstab_input" ]] && break
        fstab_entries+=("$fstab_input")
        success "Added: $fstab_input"
    done
fi

# ── Step 5: Optional Extras ───────────────────────────────────────
echo ""
echo -e "${MAGENTA}${BOLD}  ┌─ Step 5/5: Optional Extras ─────────────────────────────┐${NC}"

# Backgrounds
echo ""
read -rp "  Symlink ~/backgrounds → dotfiles/backgrounds? [Y/n]: " bg_confirm
symlink_backgrounds=true
if [[ "$bg_confirm" =~ ^[Nn]$ ]]; then
    symlink_backgrounds=false
fi

# NVIDIA envycontrol
configure_nvidia=false
# Check if nvidia was selected in packages
for i in "${!PACKAGE_CATEGORIES[@]}"; do
    if [[ "${PACKAGE_CATEGORIES[$i]}" == "nvidia" && "${pkg_selected[$i]}" == "1" ]]; then
        read -rp "  Run envycontrol --switch hybrid after install? [y/N]: " nvidia_confirm
        if [[ "$nvidia_confirm" =~ ^[Yy]$ ]]; then
            configure_nvidia=true
        fi
        break
    fi
done

# Flatpak restore
restore_flatpak=false
flatpak_file="$DOTFILES_DIR/packages/flatpak.txt"
if [[ -f "$flatpak_file" ]]; then
    flatpak_count=$(grep -cv '^#\|^$' "$flatpak_file" 2>/dev/null || true)
    if [[ $flatpak_count -gt 0 ]]; then
        read -rp "  Restore $flatpak_count Flatpak app(s)? [y/N]: " flatpak_confirm
        if [[ "$flatpak_confirm" =~ ^[Yy]$ ]]; then
            restore_flatpak=true
        fi
    fi
fi

# Auto-login
echo ""
read -rp "  Configure TTY1 Auto-login for $USERNAME? [y/N]: " autologin_confirm
configure_autologin=false
if [[ "$autologin_confirm" =~ ^[Yy]$ ]]; then
    configure_autologin=true
fi

# UFW Rules
echo ""
read -rp "  Apply UFW rules (KDE Connect, Jellyfin, Apollo)? [Y/n]: " ufw_confirm
apply_ufw=true
if [[ "$ufw_confirm" =~ ^[Nn]$ ]]; then
    apply_ufw=false
fi

# ══════════════════════════════════════════════════════════════════
# CONFIRMATION SUMMARY
# ══════════════════════════════════════════════════════════════════
echo ""
echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}${BOLD}║                  Deployment Summary                         ║${NC}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Packages
total_packages=0
echo -e "  ${BOLD}Package Groups:${NC}"
for i in "${!PACKAGE_CATEGORIES[@]}"; do
    cat="${PACKAGE_CATEGORIES[$i]}"
    if [[ "${pkg_selected[$i]}" == "1" ]]; then
        count=$(count_packages "$cat")
        total_packages=$((total_packages + count))
        echo -e "    ${GREEN}✓${NC} ${cat} (${count} packages)"
    else
        echo -e "    ${DIM}✗ ${cat}${NC}"
    fi
done
echo -e "    ${BOLD}Total: ${total_packages} packages${NC}"

# Configs
echo ""
echo -e "  ${BOLD}Config Symlinks:${NC}"
stow_count=0
for i in "${!STOW_PACKAGES[@]}"; do
    pkg="${STOW_PACKAGES[$i]}"
    if [[ "${stow_selected[$i]}" == "1" ]]; then
        ((stow_count++)) || true
        echo -e "    ${GREEN}✓${NC} ${pkg}"
    else
        echo -e "    ${DIM}✗ ${pkg}${NC}"
    fi
done

# Services
echo ""
echo -e "  ${BOLD}Services:${NC}"
if $enable_services; then
    echo -e "    ${GREEN}✓${NC} ${#system_services[@]} system + ${#user_services[@]} user services"
else
    echo -e "    ${DIM}✗ Skipped${NC}"
fi

# Extras
echo ""
echo -e "  ${BOLD}Extras:${NC}"
if $configure_fstab; then
    echo -e "    ${GREEN}✓${NC} fstab — ${#fstab_entries[@]} entries"
else
    echo -e "    ${DIM}✗ fstab${NC}"
fi
if $symlink_backgrounds; then
    echo -e "    ${GREEN}✓${NC} Backgrounds symlink"
else
    echo -e "    ${DIM}✗ Backgrounds${NC}"
fi
if $configure_nvidia; then
    echo -e "    ${GREEN}✓${NC} NVIDIA envycontrol hybrid"
else
    echo -e "    ${DIM}✗ NVIDIA envycontrol${NC}"
fi
if $restore_flatpak; then
    echo -e "    ${GREEN}✓${NC} Flatpak restore ($flatpak_count apps)"
fi
if $configure_autologin; then
    echo -e "    ${GREEN}✓${NC} TTY1 Auto-login"
else
    echo -e "    ${DIM}✗ TTY1 Auto-login${NC}"
fi
if $apply_ufw; then
    echo -e "    ${GREEN}✓${NC} UFW Rules"
else
    echo -e "    ${DIM}✗ UFW Rules${NC}"
fi

echo ""
echo -e "  ${DIM}Log will be saved to: ${LOG_FILE}${NC}"
echo ""

read -rp "$(echo -e "  ${BOLD}Proceed with deployment? [Y/n]:${NC} ")" final_confirm
if [[ "$final_confirm" =~ ^[Nn]$ ]]; then
    echo -e "\n  ${YELLOW}Deployment cancelled.${NC}\n"
    exit 0
fi

# ══════════════════════════════════════════════════════════════════
# PHASE B: AUTOMATIC EXECUTION
# ══════════════════════════════════════════════════════════════════
echo ""
echo -e "${CYAN}${BOLD}══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}${BOLD}  Deploying...                                               ${NC}"
echo -e "${CYAN}${BOLD}══════════════════════════════════════════════════════════════${NC}"
echo ""

# Cache sudo credentials upfront so they don't interrupt spinners mid-run
if ! $DRY_RUN; then
    echo -e "  ${DIM}Enter sudo password to cache credentials for the deployment:${NC}"
    sudo -v
    echo ""
fi

# Track totals for summary
installed_pkg_count=0
linked_config_count=0
enabled_svc_count=0
errors=0

# ── [1/7] System Update ──────────────────────────────────────────
step "  [1/7] ▸ Updating system..."
if run_spinner "Updating system packages (pacman -Syu)..." "sudo pacman -Syu --noconfirm"; then
    success "System updated"
else
    fail "System update failed (continuing anyway)"
    ((errors++)) || true
fi

# ── [2/7] Install Paru ───────────────────────────────────────────
step "  [2/7] ▸ Installing paru (AUR helper)..."
if command -v paru &>/dev/null; then
    success "paru is already installed"
else
    if run_spinner "Building paru from AUR (this may take a few minutes)..." "
        sudo pacman -S --needed --noconfirm base-devel git &&
        PARU_BUILD_DIR=\$(mktemp -d) &&
        git clone https://aur.archlinux.org/paru.git \"\$PARU_BUILD_DIR/paru\" &&
        cd \"\$PARU_BUILD_DIR/paru\" &&
        makepkg -si --noconfirm &&
        rm -rf \"\$PARU_BUILD_DIR\"
    "; then
        success "paru installed successfully"
    else
        fail "paru installation failed"
        ((errors++)) || true
        echo -e "  ${RED}Cannot continue without an AUR helper. Exiting.${NC}"
        exit 1
    fi
fi

# ── [3/7] Install Packages ───────────────────────────────────────
step "  [3/7] ▸ Installing packages..."

for i in "${!PACKAGE_CATEGORIES[@]}"; do
    cat="${PACKAGE_CATEGORIES[$i]}"
    if [[ "${pkg_selected[$i]}" == "1" ]]; then
        pkg_file="$DOTFILES_DIR/packages/${cat}.txt"
        if [[ -f "$pkg_file" ]]; then
            # Read packages, skip comments and empty lines
            packages=$(grep -v '^#\|^$' "$pkg_file" | tr '\n' ' ')
            count=$(echo "$packages" | wc -w)
            
            if run_spinner "Installing ${cat} (${count} packages)..." "paru -S --needed --noconfirm $packages"; then
                success "${cat} — ${count} packages installed"
                installed_pkg_count=$(( installed_pkg_count + count )) || true
            else
                fail "${cat} — some packages may have failed"
                ((errors++)) || true
            fi
        else
            warn "${cat}.txt not found, skipping"
        fi
    fi
done

# ── [4/7] Symlink Configs ────────────────────────────────────────
step "  [4/7] ▸ Symlinking configurations..."

for i in "${!STOW_PACKAGES[@]}"; do
    pkg="${STOW_PACKAGES[$i]}"
    if [[ "${stow_selected[$i]}" == "1" ]]; then
        pkg_dir="$DOTFILES_DIR/$pkg"
        if [[ -d "$pkg_dir" ]]; then
            if run_spinner "Symlinking ${pkg}..." "stow -d '$DOTFILES_DIR' -t '$HOME' --adopt '$pkg'"; then
                success "${pkg} — symlinked"
                ((linked_config_count++)) || true
            else
                fail "${pkg} — stow failed (conflicts?)"
                ((errors++)) || true
            fi
        else
            warn "${pkg} — directory not found"
        fi
    fi
done

# ── [5/7] Enable Services ────────────────────────────────────────
step "  [5/7] ▸ Enabling systemd services..."

if $enable_services; then
    # System services
    for svc in "${system_services[@]}"; do
        if run_spinner "Enabling ${svc}..." "sudo systemctl enable '$svc'"; then
            success "${svc}"
            ((enabled_svc_count++)) || true
        else
            fail "${svc} — failed to enable"
            ((errors++)) || true
        fi
    done
    
    # User services
    for svc in "${user_services[@]}"; do
        if run_spinner "Enabling ${svc} (user)..." "systemctl --user enable '$svc'"; then
            success "${svc} (user)"
            ((enabled_svc_count++)) || true
        else
            fail "${svc} (user) — failed to enable"
            ((errors++)) || true
        fi
    done
else
    info "Skipped — services not selected"
fi

# ── [6/7] Apply Extras ───────────────────────────────────────────
step "  [6/7] ▸ Applying extras..."

# Essential User Groups
if run_spinner "Adding $USERNAME to input and video groups..." "sudo usermod -aG input,video $USERNAME"; then
    success "User added to input and video groups"
else
    fail "Failed to add user groups"
    ((errors++)) || true
fi

# CPU Governor Conflict (Auto-cpufreq)
auto_cpufreq_selected=false
for i in "${!PACKAGE_CATEGORIES[@]}"; do
    if [[ "${pkg_selected[$i]}" == "1" ]]; then
        if grep -q "^auto-cpufreq$" "$DOTFILES_DIR/packages/${PACKAGE_CATEGORIES[$i]}.txt" 2>/dev/null; then
            auto_cpufreq_selected=true
            break
        fi
    fi
done

if $auto_cpufreq_selected; then
    run_spinner "Stopping power-profiles-daemon..." "sudo systemctl stop power-profiles-daemon.service 2>/dev/null || true" || true
    run_spinner "Disabling power-profiles-daemon..." "sudo systemctl disable power-profiles-daemon.service 2>/dev/null || true" || true
    if run_spinner "Masking power-profiles-daemon (CPU governor conflict)..." "sudo systemctl mask power-profiles-daemon.service"; then
        success "power-profiles-daemon masked"
    else
        fail "Failed to mask power-profiles-daemon"
        ((errors++)) || true
    fi
fi

# fstab
if $configure_fstab && [[ ${#fstab_entries[@]} -gt 0 ]]; then
    info "Applying fstab entries..."
    for entry in "${fstab_entries[@]}"; do
        # Parse: UUID MOUNTPOINT FSTYPE OPTIONS
        read -r uuid mountpoint fstype options <<< "$entry"
        fstab_line="UUID=${uuid}  ${mountpoint}  ${fstype}  ${options}  0  0"
        
        # Create mount point
        run_or_dry "sudo mkdir -p '${mountpoint}'"
        
        # Append to fstab if not already present
        if ! grep -q "$uuid" /etc/fstab 2>/dev/null || $DRY_RUN; then
            run_or_dry "echo '${fstab_line}' | sudo tee -a /etc/fstab > /dev/null"
            success "fstab: ${mountpoint} (UUID=${uuid:0:8}...)"
        else
            warn "fstab: UUID ${uuid:0:8}... already exists, skipping"
        fi
    done
fi

# Backgrounds
if $symlink_backgrounds; then
    bg_src="$DOTFILES_DIR/backgrounds"
    bg_dest="$HOME/backgrounds"
    if [[ -d "$bg_src" ]]; then
        if [[ -L "$bg_dest" ]]; then
            success "backgrounds — already symlinked"
        else
            run_or_dry "ln -sfn '$bg_src' '$bg_dest'"
            success "backgrounds — symlinked to ~/backgrounds"
        fi
    else
        warn "backgrounds directory not found in dotfiles"
    fi
fi

# NVIDIA envycontrol
if $configure_nvidia; then
    if command -v envycontrol &>/dev/null || $DRY_RUN; then
        if run_spinner "Switching NVIDIA to hybrid mode (envycontrol)..." "sudo envycontrol --switch hybrid"; then
            success "NVIDIA set to hybrid mode"
        else
            fail "envycontrol failed"
            ((errors++)) || true
        fi
    else
        warn "envycontrol not found (install nvidia packages first)"
    fi
fi

# Flatpak restore
if $restore_flatpak; then
    if command -v flatpak &>/dev/null || $DRY_RUN; then
        while IFS= read -r app_id; do
            [[ "$app_id" =~ ^#.*$ || -z "$app_id" ]] && continue
            run_spinner "Installing Flatpak: ${app_id}..." "flatpak install -y flathub '$app_id'" || true
        done < "$flatpak_file"
        success "Flatpak apps restored"
    else
        warn "flatpak not installed, skipping"
    fi
fi

# Auto-login
if $configure_autologin; then
    if run_spinner "Configuring TTY1 auto-login for $USERNAME..." "
        sudo mkdir -p /etc/systemd/system/getty@tty1.service.d &&
        echo '[Service]' | sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf >/dev/null &&
        echo 'ExecStart=' | sudo tee -a /etc/systemd/system/getty@tty1.service.d/autologin.conf >/dev/null &&
        echo 'ExecStart=-/usr/bin/agetty --autologin $USERNAME --noclear %I \$TERM' | sudo tee -a /etc/systemd/system/getty@tty1.service.d/autologin.conf >/dev/null
    "; then
        success "TTY1 Auto-login configured"
    else
        fail "Failed to configure TTY1 Auto-login"
        ((errors++)) || true
    fi
fi

# UFW Rules
if $apply_ufw; then
    if command -v ufw &>/dev/null || $DRY_RUN; then
        if run_spinner "Applying UFW firewall rules..." "
            sudo ufw allow 1714:1764/udp &&
            sudo ufw allow 1714:1764/tcp &&
            sudo ufw allow 8096/tcp &&
            sudo ufw allow 47984:48010/tcp &&
            sudo ufw allow 47984:48010/udp &&
            sudo ufw reload
        "; then
            success "UFW rules applied"
        else
            fail "Failed to apply UFW rules"
            ((errors++)) || true
        fi
    else
        warn "UFW is not installed, skipping rules"
    fi
fi

# ── [7/7] Deployment Complete ─────────────────────────────────────
step "  [7/7] ▸ Deployment complete!"

# ══════════════════════════════════════════════════════════════════
# SUMMARY
# ══════════════════════════════════════════════════════════════════
echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}${BOLD}║                  Deployment Summary                         ║${NC}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BOLD}Packages installed:${NC}  ${installed_pkg_count}"
echo -e "  ${BOLD}Configs symlinked:${NC}   ${linked_config_count}"
echo -e "  ${BOLD}Services enabled:${NC}    ${enabled_svc_count}"
if $configure_fstab; then
    echo -e "  ${BOLD}fstab entries:${NC}       ${#fstab_entries[@]}"
fi
if [[ $errors -gt 0 ]]; then
    echo -e "  ${RED}${BOLD}Errors:${NC}              ${errors}"
fi
echo ""
echo -e "  ${DIM}Log saved to: ${LOG_FILE}${NC}"
echo ""

# Reboot prompt
read -rp "$(echo -e "  ${BOLD}Reboot now? [y/N]:${NC} ")" reboot_confirm
if [[ "$reboot_confirm" =~ ^[Yy]$ ]]; then
    echo -e "\n  ${CYAN}Rebooting in 3 seconds...${NC}"
    sleep 3
    run_or_dry "sudo reboot"
else
    echo -e "\n  ${GREEN}Done! Remember to reboot when ready.${NC}\n"
fi
