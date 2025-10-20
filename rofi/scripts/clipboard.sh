#!/usr/bin/env bash
# A robust clipboard manager for Hyprland (supports text and images)

HISTORY_FILE="$HOME/.cache/clipmenu_history"
IMG_DIR="$HOME/.cache/clipmenu_images"
MAX_ITEMS=50

# Create history file and image cache directory
mkdir -p "$(dirname "$HISTORY_FILE")"
touch "$HISTORY_FILE"
mkdir -p "$IMG_DIR"

# --- 1. SAVE CURRENT CLIPBOARD ---

# Check available clipboard types (MIME types)
MIMES=$(wl-paste -l 2>/dev/null)
ENTRY_TO_ADD=""

# Priority 1: Handle Images
if echo "$MIMES" | grep -q -E '^image/(png|jpeg|gif|bmp|webp)$'; then
    # Create a unique filename based on timestamp
    IMG_FILE="$IMG_DIR/$(date +%s%N).png"
    
    # Save as PNG. wl-paste will handle conversion if needed.
    if wl-paste -t image/png > "$IMG_FILE" 2>/dev/null && [ -s "$IMG_FILE" ]; then
        # Store the path to the image, prefixed with "IMAGE::"
        ENTRY_TO_ADD="IMAGE::${IMG_FILE}"
    fi

# Priority 2: Handle Text
elif echo "$MIMES" | grep -q -E '^(text/plain)'; then
    # Get plain text and strip carriage returns (fixes <?> bug)
    CURRENT=$(wl-paste -t text/plain 2>/dev/null | tr -d '\r')
    
    if [ -n "$CURRENT" ]; then
        ENCODED=$(echo -n "$CURRENT" | base64 -w 0)
        ENTRY_TO_ADD="TEXT::${ENCODED}"
        
        # If this exact text is already in history, remove old one
        grep -Fxv "$ENTRY_TO_ADD" "$HISTORY_FILE" > "${HISTORY_FILE}.tmp" 2>/dev/null || true
        mv "${HISTORY_FILE}.tmp" "$HISTORY_FILE" 2>/dev/null || true
    fi
fi

# 3. Add new entry (if any) to history
if [ -n "$ENTRY_TO_ADD" ]; then
    # Add to end of file
    echo "$ENTRY_TO_ADD" >> "$HISTORY_FILE"
    
    # Keep only last MAX_ITEMS
    tail -n "$MAX_ITEMS" "$HISTORY_FILE" > "${HISTORY_FILE}.tmp"
    
    # Prune orphaned images (images no longer in the history)
    find "$IMG_DIR" -type f -name "*.png" -print0 2>/dev/null | while IFS= read -r -d '' img; do
        if ! grep -Fq "IMAGE::${img}" "${HISTORY_FILE}.tmp"; then
            rm "$img" 2>/dev/null
        fi
    done
    
    mv "${HISTORY_FILE}.tmp" "$HISTORY_FILE"
fi

# --- 2. DISPLAY ROFI MENU ---

# Generate menu items from history, reading our new format
MENU_ITEMS=$(tac "$HISTORY_FILE" | while read -r line; do
    if [[ "$line" == TEXT::* ]]; then
        # It's text: decode and show a preview
        DATA="${line#TEXT::}"
        decoded=$(echo "$DATA" | base64 -d 2>/dev/null)
        # Show preview, replace newlines/tabs
        echo "$decoded" | tr '\n\t' '↵→' | head -c 100
    
    elif [[ "$line" == IMAGE::* ]]; then
        # It's an image: show a preview with an icon
        IMG_PATH="${line#IMAGE::}"
        if [ -f "$IMG_PATH" ]; then
            # Rofi syntax: "Display Text\0icon\x1f/path/to/icon"
            FILENAME=$(basename "$IMG_PATH")
            echo -e "🖼️ [Image]"
        fi
    fi
done)

# Add clear option at the top
MENU_ITEMS=$(echo -e "🗑️ Clear History\n$MENU_ITEMS")

# Show menu
SELECTED_INDEX=$(echo "$MENU_ITEMS" | rofi -dmenu -i -p "Clipboard" -format 'i' -theme-str 'window {width: 700px;}')

# --- 3. HANDLE SELECTION ---

if [ -n "$SELECTED_INDEX" ]; then
    # Check if user selected "Clear History" (index 0)
    if [ "$SELECTED_INDEX" -eq 0 ]; then
        > "$HISTORY_FILE"
        rm -rf "$IMG_DIR"/* 2>/dev/null # Clear image cache
        wl-copy --clear 2>/dev/null
        notify-send "Clipboard" "History cleared" 2>/dev/null
        exit 0
    fi
    
    # Get the line from history (accounting for tac reversal and clear option)
    SELECTED_LINE=$(tac "$HISTORY_FILE" | sed -n "${SELECTED_INDEX}p")
    
    # Small delay to let rofi close
    sleep 0.1
    
    if [[ "$SELECTED_LINE" == TEXT::* ]]; then
        # It's text. Decode and type it.
        DATA="${SELECTED_LINE#TEXT::}"
        CHOICE=$(echo "$DATA" | base64 -d 2>/dev/null)
        
        if [ -n "$CHOICE" ]; then
            echo -n "$CHOICE" | wtype -s 50 -
        fi
        
    elif [[ "$SELECTED_LINE" == IMAGE::* ]]; then
        # It's an image. Copy file to clipboard.
        IMG_PATH="${SELECTED_LINE#IMAGE::}"
        
        if [ -f "$IMG_PATH" ]; then
            wl-copy < "$IMG_PATH"
            notify-send "Clipboard" "Image copied. (Press Ctrl+V to paste)" 2>/dev/null
        else
            notify-send "Clipboard Error" "Image file not found." 2>/dev/null
        fi
    fi
fi