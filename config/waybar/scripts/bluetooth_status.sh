#!/usr/bin/env bash

powered=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')

if [[ "$powered" == "yes" ]]; then
    echo '{"text": "", "tooltip": "Bluetooth On"}'
else
    echo '{"text": " off", "tooltip": "Bluetooth Off"}'
fi

