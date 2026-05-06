#!/usr/bin/env bash

STATE_FILE="/tmp/hyprsunset_state"

# Initialize state if file doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    echo "day" > "$STATE_FILE"
fi

if [ "$(cat "$STATE_FILE")" == "day" ]; then
    # Use hyprctl to send command to the running daemon
    hyprctl hyprsunset temperature 3500
    echo "night" > "$STATE_FILE"
else
    # Reset to default
    hyprctl hyprsunset identity
    echo "day" > "$STATE_FILE"
fi
