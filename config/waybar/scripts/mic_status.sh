#!/usr/bin/env bash

INFO=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null)

VOL=$(echo "$INFO" | awk '{print int($2*100)}')
STATE=$(echo "$INFO" | awk '{print $3}')

if [[ "$STATE" == "[MUTED]" ]]; then
  ICON=""
else
  ICON=""
fi

# JSON for Waybar
echo "{\"text\": \"${ICON} ${VOL}%\", \"class\": \"mic\"}"
