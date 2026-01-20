#!/bin/bash

FILE="$HOME/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"

grim -g "$(slurp)" "$FILE"

# copy to clipboard
wl-copy < "$FILE"
