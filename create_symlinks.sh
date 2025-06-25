#!/bin/bash

# Array of source files/folders (relative or absolute paths)
sources=(
    "$HOME/dotfiles/.config/kitty"
    "$HOME/dotfiles/.config/hypr"
    "$HOME/dotfiles/.config/waybar"
    "$HOME/dotfiles/.config/wofi"
)

# Destination directory where symlinks will be created
target_dir="$HOME/.config"

# Function to create backup if file already exists
backup_if_exists() {
    local target="$1"

    if [ -e "$target" ] || [ -L "$target" ]; then
        local backup="${target}.bak"
        local i=1

        while [ -e "$backup" ]; do
            backup="${target}.bak.$i"
            ((i++))
        done

        echo "Backing up $target to $backup"
        sudo mv "$target" "$backup"
    fi
}

# Main loop
for src in "${sources[@]}"; do
    base_name=$(basename "$src")
    dest="$target_dir/$base_name"

    backup_if_exists "$dest"

    echo "Creating symlink: $dest → $src"
    sudo ln -sf "$src" "$dest"
done
    
sudo rm -rf "$HOME/.bashrc"
sudo ln -sf "$HOME/dotfiles/.bashrc" "$HOME"

sudo rm -rf "/etc/tlp.conf"
sudo ln -sf "$HOME/dotfiles/etc/tlp.conf" "/etc"

sudo rm -rf "/etc/sddm.conf"
sudo ln -sf "$HOME/dotfiles/etc/sddm.conf" "/etc"

echo "All symlinks created successfully."