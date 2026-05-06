#!/bin/bash
WALLPAPER_DIR="/home/yahia/Pictures/wallpapers"
LAST_WALLPAPER_FILE="/tmp/last_wallpaper"

# 1. Validate directory
if [[ ! -d "$WALLPAPER_DIR" ]]; then
    echo "Error: Directory $WALLPAPER_DIR does not exist."
    exit 1
fi

# 2. Get all images into an array
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \))

# 3. Handle empty directory
if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
    echo "No wallpapers found."
    exit 1
fi

# 4. Handle selection logic
LAST_WALLPAPER=$(cat "$LAST_WALLPAPER_FILE" 2>/dev/null)

if [[ ${#WALLPAPERS[@]} -eq 1 ]]; then
    SELECTED="${WALLPAPERS[0]}"
else
    if [[ -z "$LAST_WALLPAPER" ]]; then
        SELECTED=$(printf "%s\n" "${WALLPAPERS[@]}" | shuf -n 1)
    else
        SELECTED=$(printf "%s\n" "${WALLPAPERS[@]}" | grep -vxF "$LAST_WALLPAPER" | shuf -n 1)
    fi
fi

# 5. Apply and Save
echo "$SELECTED" > "$LAST_WALLPAPER_FILE"

# Use the new awww binary
awww img "$SELECTED" \
  --transition-type fade \
  --transition-fps 60 \
  --transition-duration 0.5
