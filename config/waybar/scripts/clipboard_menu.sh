#!/bin/bash

# Simple rofi-based clipboard manager with clear button

# Get history (replace NUL bytes so Bash doesn't complain)
HIST=$(cliphist list | tr '\0' ' ' | sed 's/\t/ | /g')

# Add "Clear All" on top and show menu
CHOICE=$(printf "🗑 Clear All\n%s\n" "$HIST" | rofi -dmenu -i -p "Clipboard")

case "$CHOICE" in
  "🗑 Clear All")
    cliphist wipe
    notify-send "Clipboard" "History cleared"
    exit 0
    ;;
  "")
    # User pressed Esc / nothing selected
    exit 0
    ;;
  *)
    # First column is the cliphist ID
    ID=$(printf "%s" "$CHOICE" | awk '{print $1}')
    [ -n "$ID" ] && cliphist decode "$ID" | wl-copy
    ;;
esac

