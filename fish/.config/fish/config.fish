# ~/.config/fish/config.fish

if status is-interactive
    set fish_greeting
end

if status is-login; and test "$XDG_VTNR" = "1"; and test -z "$DISPLAY"
    exec uwsm start start-hyprland
end

# Aliases
alias i="paru -S --noconfirm"
alias u="paru -R"
alias s="paru -Ss"
alias q="paru -Q | grep"

alias update="paru -Syu"

alias hermes-all="hermes gateway start; and hermes"
abbr -a -- hermes-all 'hermes gateway start; and hermes'

# zoxide
zoxide init fish | source
alias cd="z"
# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/shamil/.lmstudio/bin
# End of LM Studio CLI section

# Obsidian Vault Path
set -gx OBSIDIAN_VAULT_PATH "/mnt/d/RAM"

# Hermes Agent — ensure ~/.local/bin is on PATH
set -gx fish_add_path "$HOME/.local/bin"

fish_add_path /home/shamil/.spicetify
