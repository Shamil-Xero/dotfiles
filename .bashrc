#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias cd='z'
PS1='[\u@\h \W]\$ '

# Automatically start or attach to a tmux session
#if command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
#    tmux attach-session -t default || tmux new-session -s default
#fi

eval "$(zoxide init bash)"

export PATH="$HOME/.local/bin:$PATH"
