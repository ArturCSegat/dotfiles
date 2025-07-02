#!/bin/bash
vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -n1)
mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
if [ "$mute" = "yes" ]; then
    echo "Muted"
else
    echo "Volume $vol"
fi
