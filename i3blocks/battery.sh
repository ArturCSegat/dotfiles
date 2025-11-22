#!/bin/bash
capacity=$(cat /sys/class/power_supply/BAT1/capacity)
status=$(cat /sys/class/power_supply/BAT1/status)
cap0=$(cat /sys/class/power_supply/BAT0/capacity)
status0=$(cat /sys/class/power_supply/BAT0/status)

echo "Bat0 $cap0% $status0 Bat1 $capacity% $status"
