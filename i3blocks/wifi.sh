#!/bin/bash

# Check for active Wi-Fi connection
ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)

# Check for active Ethernet connection
ethernet=$(nmcli -t -f TYPE,STATE dev | grep '^ethernet:connected' | cut -d: -f1)

if [ -n "$ssid" ]; then
    echo "Wi-Fi: $ssid"
elif [ -n "$ethernet" ]; then
    echo "Ethernet: Connected"
else
    echo "Disconnected"
fi

