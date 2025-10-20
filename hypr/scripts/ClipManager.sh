while true; do
    # Get last 20 clipboard entries
    menu_entries=()
    while IFS= read -r line; do
        menu_entries+=("$line")
    done < <(cliphist list | awk '{$1=""; sub(/^ /,""); print}' | tail -n 20)

    # Add clear option
    menu_entries=("[Clear Clipboard]" "${menu_entries[@]}")

    # Show rofi menu
    result=$(printf '%s\n' "${menu_entries[@]}" | rofi -dmenu \
        -kb-custom-1 "Control-Delete" \
        -kb-custom-2 "Alt-Delete" \
        -config ~/.config/rofi/config-clipboard.rasi)

    case "$?" in
        1) exit ;;
        0)
            case "$result" in
                "") continue ;;
                "[Clear Clipboard]") cliphist wipe; continue ;;
                *)
                    # Copy directly to clipboard without using the ID
                    printf '%s' "$result" | wl-copy
                    exit
                    ;;
            esac
            ;;
        10) cliphist delete <<<"$result" ;;
        11) cliphist wipe ;;
    esac
done
