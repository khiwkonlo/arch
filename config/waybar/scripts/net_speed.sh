#!/usr/bin/env bash

# Detect default interface if not given
IFACE=${1:-$(ip route | awk '/default/ {print $5; exit}')}

RX_FILE="/tmp/.waybar_net_rx_$IFACE"
TX_FILE="/tmp/.waybar_net_tx_$IFACE"

RX_NOW=$(cat /sys/class/net/"$IFACE"/statistics/rx_bytes 2>/dev/null || echo 0)
TX_NOW=$(cat /sys/class/net/"$IFACE"/statistics/tx_bytes 2>/dev/null || echo 0)

RX_OLD=$RX_NOW
TX_OLD=$TX_NOW

[[ -f "$RX_FILE" ]] && RX_OLD=$(cat "$RX_FILE")
[[ -f "$TX_FILE" ]] && TX_OLD=$(cat "$TX_FILE")

echo "$RX_NOW" > "$RX_FILE"
echo "$TX_NOW" > "$TX_FILE"

RX_DIFF=$((RX_NOW - RX_OLD))
TX_DIFF=$((TX_NOW - TX_OLD))

format_speed() {
  local BYTES=$1
  local KB=$((BYTES / 1024))
  local MB=$((KB / 1024))
  if (( MB > 0 )); then
    echo "${MB}MB/s"
  else
    echo "${KB}KB/s"
  fi
}

DOWN=$(format_speed "$RX_DIFF")
UP=$(format_speed "$TX_DIFF")

# JSON for Waybar (return-type: "json")
echo "{\"text\": \"󰈀 ${DOWN}↓ ${UP}↑\", \"class\": \"netspeed\"}"
