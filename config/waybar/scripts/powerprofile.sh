#!/bin/bash

STATE_FILE="$HOME/.cache/powerprofile_state"

# Read our stored state, or fall back to daemon/default
get_state() {
  if [[ -f "$STATE_FILE" ]]; then
    cat "$STATE_FILE"
    return
  fi

  if command -v powerprofilesctl &>/dev/null; then
    current=$(powerprofilesctl get 2>/dev/null)
    if [[ -n "$current" ]]; then
      echo "$current"
      echo "$current" > "$STATE_FILE"
      return
    fi
  fi

  echo "balanced" > "$STATE_FILE"
  echo "balanced"
}

# Save state + *try* to tell powerprofilesctl (errors ignored)
set_state() {
  local target="$1"
  echo "$target" > "$STATE_FILE"

  if command -v powerprofilesctl &>/dev/null; then
    powerprofilesctl set "$target" &>/dev/null || true
  fi
}

# Cycle through 3 modes: power-saver → balanced → performance → ...
toggle_and_get_new_state() {
  local current
  current=$(get_state)

  case "$current" in
    "power-saver")
      new="balanced"
      ;;
    "balanced")
      new="performance"
      ;;
    "performance")
      new="power-saver"
      ;;
    *)
      new="balanced"
      ;;
  esac

  set_state "$new"
  echo "$new"
}

# Show icon for given state (or current if none passed)
display_profile() {
  local state="${1:-$(get_state)}"

  case "$state" in
    "power-saver")
      echo "󰾆"   # low power
      ;;
    "balanced")
      echo "󰾅"   # balanced
      ;;
    "performance")
      echo "󰓅"   # performance
      ;;
    *)
      echo "󰾅"
      ;;
  esac
}

case "$1" in
  "toggle")
    new_state=$(toggle_and_get_new_state)

    case "$new_state" in
      "power-saver")
        notify-send "Power Profile" "Low power mode"
        ;;
      "balanced")
        notify-send "Power Profile" "Balanced mode"
        ;;
      "performance")
        notify-send "Power Profile" "Performance mode"
        ;;
      *)
        notify-send "Power Profile" "Profile: $new_state"
        ;;
    esac

    # Update icon in Waybar using the new state
    display_profile "$new_state"
    ;;
  "display"|*)
    display_profile
    ;;
esac

exit 0
