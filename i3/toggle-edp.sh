#!/bin/bash

INTERNAL="eDP-1"

# Find external monitor (not eDP-1)
EXTERNAL=$(xrandr | grep " connected" | grep -v "^eDP-1" | awk '{print $1}')

# Only proceed if external is connected
if [ -n "$EXTERNAL" ]; then
    # Check if INTERNAL is currently on
    if xrandr --query | grep "^$INTERNAL connected" | grep -q '+'; then
        # eDP-1 is on -> turn it off
        xrandr --output "$INTERNAL" --off \
               --output "$EXTERNAL" --auto
    else
        # eDP-1 is off -> turn it on, extend to the left of external
        xrandr --output "$EXTERNAL" --auto \
               --output "$INTERNAL" --auto --left-of "$EXTERNAL"
    fi
else
        # eDP-1 is off -> turn it on, extend to the left of external
        xrandr --output "$EXTERNAL" --auto \
               --output "$INTERNAL" --auto --left-of "$EXTERNAL"
fi

