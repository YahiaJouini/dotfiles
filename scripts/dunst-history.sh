#!/usr/bin/env bash
# dunst-history.sh — display dunst notification history via rofi

HISTORY=$(dunstctl history)
COUNT=$(echo "$HISTORY" | jq '.data[0] | length')

if [[ "$COUNT" -eq 0 ]]; then
    dunstify -u low "Dunst" "History is empty."
    exit 0
fi

# Build "AppName  |  Summary — Body" lines, strip pango markup for cleanliness
ENTRIES=$(echo "$HISTORY" | jq -r '
    .data[0][] |
    "\(.appname.data)  |  \(.summary.data)\(
        if (.body.data | length) > 0
        then " — \(.body.data)"
        else ""
        end
    )"
' | sed 's/<[^>]*>//g')  # strip leftover markup tags

# Feed into rofi; -format i gives us the 0-based index of the selection
SELECTED_IDX=$(echo "$ENTRIES" | rofi -dmenu \
    -p "󰂚 History" \
    -i \
    -format i \
    -no-custom)

[[ -z "$SELECTED_IDX" ]] && exit 0

# Extract the notification ID at that index and re-pop it
NOTIF_ID=$(echo "$HISTORY" | jq ".data[0][$SELECTED_IDX].id.data")
dunstctl history-pop "$NOTIF_ID"
