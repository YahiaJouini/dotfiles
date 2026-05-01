#!/bin/bash
DIR=$1
SIZE=${2:-50}

TREE=$(swaymsg -t get_tree)
FID=$(echo "$TREE" | jq '.. | objects | select(.focused == true) | .id' | head -1)

[ -z "$FID" ] || [ "$FID" = "null" ] && { swaymsg "resize grow width ${SIZE}px"; exit; }

LAYOUT=$(echo "$TREE" | jq -r --argjson f "$FID" \
  '.. | objects | select(has("nodes") and (.nodes | any(.[]; .id == $f))) | .layout' | head -1)

IS_LAST=$(echo "$TREE" | jq --argjson f "$FID" \
  '.. | objects | select(has("nodes") and (.nodes | any(.[]; .id == $f))) | (.nodes[-1].id == $f)' | head -1)

[ -z "$LAYOUT" ] && {
  case "$DIR" in
    right) swaymsg "resize grow width ${SIZE}px" ;;
    left)  swaymsg "resize shrink width ${SIZE}px" ;;
    up)    swaymsg "resize shrink height ${SIZE}px" ;;
    down)  swaymsg "resize grow height ${SIZE}px" ;;
  esac
  exit
}

case "$LAYOUT" in
  splith|tabbed)
    case "$DIR" in
      right) [ "$IS_LAST" = "true" ] && CMD="shrink left ${SIZE}px" || CMD="grow right ${SIZE}px" ;;
      left)  [ "$IS_LAST" = "true" ] && CMD="grow left ${SIZE}px"   || CMD="shrink right ${SIZE}px" ;;
      up)    CMD="shrink height ${SIZE}px" ;;
      down)  CMD="grow height ${SIZE}px" ;;
    esac ;;
  splitv|stacked)
    case "$DIR" in
      down)  [ "$IS_LAST" = "true" ] && CMD="shrink up ${SIZE}px"   || CMD="grow down ${SIZE}px" ;;
      up)    [ "$IS_LAST" = "true" ] && CMD="grow up ${SIZE}px"     || CMD="shrink down ${SIZE}px" ;;
      right) CMD="grow width ${SIZE}px" ;;
      left)  CMD="shrink width ${SIZE}px" ;;
    esac ;;
  *)
    case "$DIR" in
      right) CMD="grow width ${SIZE}px" ;;
      left)  CMD="shrink width ${SIZE}px" ;;
      up)    CMD="shrink height ${SIZE}px" ;;
      down)  CMD="grow height ${SIZE}px" ;;
    esac ;;
esac

swaymsg "resize $CMD"
