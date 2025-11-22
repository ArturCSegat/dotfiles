#!/bin/bash
max=$(brightnessctl m)
current=$(brightnessctl g)
percent=$(( 100 * current / max ))
echo "Bright: $percent%"
