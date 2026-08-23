#!/usr/bin/env bash
SNIPPET_DIR="$(dirname "$(readlink -f "$0")")/snippets"

# If no snippet name is passed as an argument, open Rofi to select one
if [ -z "$1" ]; then
    # List all files in the snippet directory and feed them into rofi
    SELECTION=$(ls "$SNIPPET_DIR" | rofi -dmenu -p "Select Snippet:")
    
    # If the user exits rofi without picking anything, stop the script safely
    if [ -z "$SELECTION" ]; then
        exit 0
    fi
    SNIPPET_FILE="$SNIPPET_DIR/$SELECTION"
else
    # If an argument was passed, use it directly (your original behavior)
    SNIPPET_FILE="$SNIPPET_DIR/$1"
fi

# Execute the typing sequence if the file exists
if [ -f "$SNIPPET_FILE" ]; then
    CONTENT=$(cat "$SNIPPET_FILE")
    
    # Wait for Rofi to close and physical modifier keys to clear
    sleep 0.2
    # # Pipe via stdin to avoid shell misinterpreting special chars like '#'
    # printf '%s' "$CONTENT" | wtype -
    # Also copy to clipboard so it can be pasted manually if needed
    printf '%s' "$CONTENT" | wl-copy
else
    echo "Snippet file not found."
fi

