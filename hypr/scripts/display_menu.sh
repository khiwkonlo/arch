#!/bin/bash

# Get connected monitors
MONITORS=$(hyprctl monitors | grep "Monitor" | awk '{print $2}')
PRIMARY=$(echo "$MONITORS" | head -n 1)
SECONDARY=$(echo "$MONITORS" | tail -n 1)

# Check if we have 2 monitors
if [ $(echo "$MONITORS" | wc -l) -lt 2 ]; then
    notify-send "Display" "Only one monitor detected"
    exit 0
fi

# Menu options
OPTIONS="Duplicate (Mirror)\nExtend (Side by Side)\nSecondary Only\nPrimary Only"

# Show menu
CHOICE=$(echo -e "$OPTIONS" | wofi --dmenu --prompt "Display Mode:")

case "$CHOICE" in
    "Duplicate (Mirror)")
        # Mirror display
        hyprctl keyword monitor "$PRIMARY,preferred,0x0,1"
        hyprctl keyword monitor "$SECONDARY,preferred,0x0,1,mirror,$PRIMARY"
        notify-send "Display" "Mirroring enabled"
        ;;
    "Extend (Side by Side)")
        # Extended display
        hyprctl keyword monitor "$PRIMARY,preferred,0x0,1"
        hyprctl keyword monitor "$SECONDARY,preferred,1920x0,1"
        notify-send "Display" "Extended display enabled"
        ;;
    "Secondary Only")
        # Disable primary, use secondary
        hyprctl keyword monitor "$PRIMARY,disable"
        hyprctl keyword monitor "$SECONDARY,preferred,0x0,1"
        notify-send "Display" "Secondary monitor only"
        ;;
    "Primary Only")
        # Disable secondary, use primary
        hyprctl keyword monitor "$PRIMARY,preferred,0x0,1"
        hyprctl keyword monitor "$SECONDARY,disable"
        notify-send "Display" "Primary monitor only"
        ;;
esac