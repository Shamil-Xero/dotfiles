#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias cd='z'
PS1='[\u@\h \W]\$ '

# alias i='yay -S --noconfirm --answerdiff=None --answerclean=None'
alias i='paru -S --noconfirm'
alias s='paru -Ss'
alias q='paru -Q | grep'
alias pi='sudo pacman -S --noconfirm'
alias ps='sudo pacman -Ss'
alias pq='sudo pacman -Q | grep'
alias cd='z'

export ADB_HOME=$HOME/Applications/adb
export PATH="$PATH:$ADB_HOME"
export OBSIDIAN_VAULT_PATH=/mnt/d/RAM
eval "$(zoxide init bash)"

# Hermes Agent — ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"

# Added by LM Studio CLI tool (lms)
export PATH="$PATH:/home/shamil/.lmstudio/bin"

