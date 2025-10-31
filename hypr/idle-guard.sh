#!/usr/bin/env bash
set -euo pipefail

# Idle guard for Hyprland (swayidle hooks)
# Usage: idle-guard.sh lock
#        idle-guard.sh dpms-off
#        idle-guard.sh resume
#
# Behavior: if any MPRIS player is Playing OR the active window is fullscreen (likely video),
#           skip locking / skipping DPMS off.

LOG="$HOME/.cache/hypr/idle-guard.log"
mkdir -p "$(dirname "$LOG")"

# Check if any playerctl player is playing
is_playing() {
  if ! command -v playerctl >/dev/null 2>&1; then
    return 1
  fi

  # playerctl -a status prints statuses of all players; grep for 'Playing'
  if playerctl -a status 2>/dev/null | grep -qE '^Playing$'; then
    return 0
  fi

  # Some playerctl installations show "<player>: Playing" -- check for 'Playing' anywhere
  if playerctl -a status 2>/dev/null | grep -q 'Playing'; then
    return 0
  fi

  return 1
}

# Check if active window is fullscreen or is a known video player in focus
is_fullscreen_video() {
  if ! command -v hyprctl >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
    return 1
  fi

  # Try hyprctl activewindow -j (JSON) and check fullscreen flag
  if hyprctl activewindow -j 2>/dev/null | jq -r '.fullscreen // false' 2>/dev/null | grep -q 'true'; then
    return 0
  fi

  # Fallback: check activewindow class/title for common video players / watch sites
  cls=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class // empty' 2>/dev/null || echo)
  title=$(hyprctl activewindow -j 2>/dev/null | jq -r '.title // empty' 2>/dev/null || echo)

  # broad but practical matches
  if [[ "$cls" =~ (mpv|vlc|mpv.net|smplayer|chromium|firefox|vivaldi) ]]; then
    # if browser is focused, prefer fullscreen detection above; but match common classes anyway
    # this avoids false-negatives if MPRIS isn't available
    # don't declare fullscreen here - rely on fullscreen flag earlier
    :
  fi

  # Check title for YouTube/Netflix/etc (common enough heuristic)
  if [[ "$title" =~ (YouTube|Netflix|Prime Video|Disney\+|Vimeo|Crunchyroll) ]]; then
    return 0
  fi

  return 1
}

# Action dispatcher
case "${1:-}" in
lock)
  if is_playing || is_fullscreen_video; then
    echo "$(date +%F\ %T) - lock SKIPPED (media playing or fullscreen)" >>"$LOG"
    exit 0
  fi
  echo "$(date +%F\ %T) - locking screen" >>"$LOG"
  swaylock -f -c 000000
  ;;
dpms-off)
  if is_playing || is_fullscreen_video; then
    echo "$(date +%F\ %T) - dpms OFF SKIPPED (media playing or fullscreen)" >>"$LOG"
    exit 0
  fi
  echo "$(date +%F\ %T) - turning dpms off" >>"$LOG"
  hyprctl dispatch dpms off
  ;;
resume)
  # always try to turn it on on resume
  echo "$(date +%F\ %T) - resume: dpms on" >>"$LOG"
  hyprctl dispatch dpms on
  ;;
*)
  echo "Usage: $0 {lock|dpms-off|resume}"
  exit 2
  ;;
esac

exit 0
