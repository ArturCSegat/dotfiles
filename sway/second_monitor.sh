#!/bin/bash

swaymsg workspace number 1; swaymsg move workspace to output  eDP-1
swaymsg workspace number 2; swaymsg move workspace to output  eDP-1
swaymsg workspace number 3; swaymsg move workspace to output  eDP-1
swaymsg workspace number 4; swaymsg move workspace to output  eDP-1
swaymsg workspace number 5; swaymsg move workspace to output  eDP-1
swaymsg workspace number 6; swaymsg move workspace to output  eDP-1
swaymsg workspace number 7; swaymsg move workspace to output  eDP-1

# # Move specific workspaces to HDMI-A-2
swaymsg workspace number 1; swaymsg move workspace to output HDMI-A-2
swaymsg workspace number 2; swaymsg move workspace to output HDMI-A-2
swaymsg workspace number 3; swaymsg move workspace to output HDMI-A-2
swaymsg workspace number 4; swaymsg move workspace to output HDMI-A-2
swaymsg workspace number 5; swaymsg move workspace to output HDMI-A-2
swaymsg workspace number 6; swaymsg move workspace to output HDMI-A-2
swaymsg workspace number 7; swaymsg move workspace to output HDMI-A-2

# Focus workspace 1 at the end
swaymsg workspace number 1

