#!/bin/bash

# File to store transparency state
STATE_FILE="$HOME/.config/hypr/.transparency_state"

# Read current state (default: enabled)
if [ -f "$STATE_FILE" ]; then
    STATE=$(cat "$STATE_FILE")
else
    STATE="enabled"
fi

# Toggle state
if [ "$STATE" = "enabled" ]; then
    # Disable transparency
    hyprctl keyword decoration:active_opacity 1.0
    hyprctl keyword decoration:inactive_opacity 1.0
    hyprctl keyword decoration:blur:enabled false
    echo "disabled" > "$STATE_FILE"
    notify-send "Transparency" "Disabled" -t 2000
else
    # Enable transparency
    hyprctl keyword decoration:active_opacity 0.90
    hyprctl keyword decoration:inactive_opacity 0.85
    hyprctl keyword decoration:blur:enabled true
    echo "enabled" > "$STATE_FILE"
    notify-send "Transparency" "Enabled" -t 2000
fi
