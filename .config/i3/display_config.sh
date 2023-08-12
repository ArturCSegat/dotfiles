#!/bin/bash

# Set display configuration with xrandr
xrandr --auto
xrandr --output eDP-1 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output eDP-1-1 --off --output DP-2 --off --output HDMI-2 --primary --mode 1920x1080 --pos 1927x0 --rotate normal

# Move workspaces to eDP-1 display
i3-msg "workspace 1, move workspace to output eDP-1"
i3-msg "workspace 2, move workspace to output eDP-1"
i3-msg "workspace 3, move workspace to output eDP-1"
i3-msg "workspace 4, move workspace to output eDP-1"
i3-msg "workspace 5, move workspace to output eDP-1"
i3-msg "workspace 6, move workspace to output eDP-1"
i3-msg "workspace 7, move workspace to output eDP-1"

i3-msg "workspace 1, move workspace to output HDMI-2"
i3-msg "workspace 2, move workspace to output HDMI-2"
i3-msg "workspace 3, move workspace to output HDMI-2"
i3-msg "workspace 4, move workspace to output HDMI-2"
i3-msg "workspace 5, move workspace to output HDMI-2"
i3-msg "workspace 6, move workspace to output HDMI-2"
i3-msg "workspace 7, move workspace to output HDMI-2"

i3-msg "workspace 1"

