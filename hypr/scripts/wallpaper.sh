#!/bin/bash
WALLPAPER_DIR="/home/yahia/Pictures/wallpapers"
LAST_WALLPAPER_FILE="/tmp/last_wallpaper"

# Get current wallpaper if it exists
LAST_WALLPAPER=""
if [ -f "$LAST_WALLPAPER_FILE" ]; then
    LAST_WALLPAPER=$(cat "$LAST_WALLPAPER_FILE")
fi

# Pick random wallpaper, excluding the last one
while true; do
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1)
    
    # If we have more than one wallpaper and this isn't the same as last time, break
    if [ "$WALLPAPER" != "$LAST_WALLPAPER" ]; then
        break
    fi
done

# Save the current wallpaper for next time
echo "$WALLPAPER" > "$LAST_WALLPAPER_FILE"

# Apply with smooth, quick fade
swww img "$WALLPAPER" \
  --transition-type fade \
  --transition-fps 60 \
  --transition-duration 0.5