#!/bin/bash
# Usage: focus-next-window.sh <class_name>
# Example: bash focus-next-window.sh kitty

if [ -z "$1" ]; then
    echo "Usage: $0 <window_class>"
    exit 1
fi

app_class="$1"
current=$(hyprctl activewindow -j | jq -r .address)

# Get all windows of the given class (across all workspaces)
readarray -t app_windows < <(hyprctl clients -j | jq -r --arg class "$app_class" '.[] | select(.class == $class) | "\(.workspace.id) \(.address)"')

# If no such windows found, exit
if [ ${#app_windows[@]} -eq 0 ]; then
    exit 0
fi

# Find index of current window in list
current_index=-1
for i in "${!app_windows[@]}"; do
    addr=$(echo "${app_windows[i]}" | awk '{print $2}')
    if [[ "$addr" == "$current" ]]; then
        current_index=$i
        break
    fi
done

# Decide the next window to focus
if [[ "$current_index" -ge 0 ]]; then
    next_index=$(( (current_index + 1) % ${#app_windows[@]} ))
else
    next_index=0
fi

next_workspace=$(echo "${app_windows[$next_index]}" | awk '{print $1}')
next_address=$(echo "${app_windows[$next_index]}" | awk '{print $2}')

# Switch to its workspace and focus
hyprctl dispatch workspace "$next_workspace"
sleep 0.1
hyprctl dispatch focuswindow address:$next_address
