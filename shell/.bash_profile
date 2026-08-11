#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	uwsm start start-hyprland
fi

# Hermes Agent — ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"

# Added by LM Studio CLI tool (lms)
export PATH="$PATH:/home/shamil/.lmstudio/bin"
