#!/usr/bin/env bash

# Print options directly to rofi, capturing the stdout
CHOICE=$(printf "Shutdown\nReboot\nLogout" | rofi -dmenu -p 'System' -i)

# Native switch case for execution (O(1) routing, no subshells)
case "$CHOICE" in
    Shutdown) systemctl poweroff ;;
    Reboot)   systemctl reboot ;;
    Logout)   hyprctl dispatch exit ;;
esac
