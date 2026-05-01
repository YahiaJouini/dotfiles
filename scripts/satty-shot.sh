#!/usr/bin/env bash

# Paths and DBus bypass
export PATH="$HOME/.cargo/bin:$PATH"
export GTK_USE_PORTAL=0

area=$(slurp)

if [ -z "$area" ]; then
    exit 0
fi

sleep 0.1

# 3. Pipe raw uncompressed image data (PPM) directly into Satty
timestamp=$(date "+%Y%m%d-%H%M%S")
grim -g "$area" -t ppm - | satty --filename - --output-filename "$HOME/Pictures/Screenshots/satty-${timestamp}.png"
