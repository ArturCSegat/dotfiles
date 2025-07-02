#!/bin/bash
capacity=$(cat /sys/class/power_supply/BAT1/capacity)
status=$(cat /sys/class/power_supply/BAT1/status)
echo "Bateria $capacity% $status"
