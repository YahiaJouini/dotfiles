#!/usr/bin/env bash

# Get sinks and current default
SINKS=$(pactl list sinks short | awk '{print $2}')
CURRENT_SINK=$(pactl get-default-sink)

# Logic to find the next sink
NEXT_SINK=$(echo "$SINKS" | grep -A 1 "$CURRENT_SINK" | tail -n 1)

if [[ "$CURRENT_SINK" == "$NEXT_SINK" ]] || [[ -z "$NEXT_SINK" ]]; then
    NEXT_SINK=$(echo "$SINKS" | head -n 1)
fi

# Apply switch
pactl set-default-sink "$NEXT_SINK"

# Move all active inputs to the new sink
pactl list sink-inputs short | awk '{print $1}' | while read -r stream; do
    pactl move-sink-input "$stream" "$NEXT_SINK"
done

# Notification logic
if command -v notify-send >/dev/null; then
    desc=$(pactl list sinks | grep -A 20 "$NEXT_SINK" | grep "Description:" | cut -d: -f2- | xargs)
    notify-send -h string:x-canonical-private-synchronous:sys-audio -u low "Audio Output" "Switched to: $desc"
fi
