#!/bin/bash

mapfile -t sinks < <(
    wpctl list |
    awk '$3 == "audio/sink" {print $1}'
)

# Remove trailing '*' from IDs
sinks=("${sinks[@]//\*/}")

# Nothing to cycle
(( ${#sinks[@]} < 2 )) && exit 0

# Get current default sink
current=$(
    wpctl list |
    awk '$3 == "audio/sink" && $4 == "*" {gsub(/\*/, "", $1); print $1}'
)

# Find current sink and select the next one
for i in "${!sinks[@]}"; do
    if [[ "${sinks[$i]}" == "$current" ]]; then
        next=$(( (i + 1) % ${#sinks[@]} ))
        wpctl set-default "${sinks[$next]}"
        exit 0
    fi
done

# Current sink wasn't found, select the first one
wpctl set-default "${sinks[0]}"