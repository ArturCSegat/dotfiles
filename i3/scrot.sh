#!/bin/sh
f=$(mktemp --suffix=.png) && maim -s "$f" && xclip -selection clipboard -t image/png -i "$f" && rm "$f"
