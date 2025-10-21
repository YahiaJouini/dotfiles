#!/usr/bin/env bash

pkill -u "$USER" rofi && exit 0

# Define paths and files
cache_dir="${HOME}/.cache/cliphist"
favorites_file="${cache_dir}/favorites"
[ -f "$HOME/.cliphist_favorites" ] && favorites_file="$HOME/.cliphist_favorites"

# Create cache directory if it doesn't exist
mkdir -p "$cache_dir"

# Execute rofi with common parameters
run_rofi() {
    local placeholder="$1"
    shift

    rofi -dmenu \
        -theme-str "entry { placeholder: \"${placeholder}\";}" \
        -i \
        "$@"
}

# Create favorites directory if it doesn't exist
ensure_favorites_dir() {
    local dir
    dir=$(dirname "$favorites_file")
    [ -d "$dir" ] || mkdir -p "$dir"
}

# Process favorites file into an array of decoded lines for rofi
prepare_favorites_for_display() {
    if [ ! -f "$favorites_file" ] || [ ! -s "$favorites_file" ]; then
        return 1
    fi

    mapfile -t favorites <"$favorites_file"

    decoded_lines=()
    for favorite in "${favorites[@]}"; do
        local decoded_favorite
        decoded_favorite=$(echo "$favorite" | base64 --decode)
        local single_line_favorite
        single_line_favorite=$(echo "$decoded_favorite" | tr '\n' ' ')
        decoded_lines+=("$single_line_favorite")
    done

    return 0
}

# Display clipboard history and copy selected item
show_history() {
    # Store cliphist list output
    local clip_list
    clip_list=$(cliphist list)
    
    # Show only the text content (without IDs) in rofi
    local selected_text
    selected_text=$(
        {
            echo "📌 Favorites"
            echo "⚙️ Options"
            echo "$clip_list" | awk -F'\t' '{for(i=2;i<=NF;i++) printf "%s%s", $i, (i<NF?"\t":""); print ""}'
        } | run_rofi " 📜 History..." -multi-select
    )

    [ -n "${selected_text}" ] || exit 0

    # Handle special menu items
    if echo "$selected_text" | grep -q "^📌 Favorites$"; then
        "${0}" --favorites
        return
    elif echo "$selected_text" | grep -q "^⚙️ Options$"; then
        "${0}"
        return
    fi

    # Process selected items
    local final_output=""
    while IFS= read -r text_line; do
        [ -z "$text_line" ] && continue
        [[ "$text_line" == "📌 Favorites" ]] && continue
        [[ "$text_line" == "⚙️ Options" ]] && continue
        
        # Find the matching full line (with ID) from original list
        local full_line
        full_line=$(echo "$clip_list" | grep -F "$text_line" | head -n1)
        
        if [ -n "$full_line" ]; then
            # Decode the content
            local decoded
            decoded=$(echo "$full_line" | cliphist decode)
            
            if [ -n "$final_output" ]; then
                final_output+=$'\n'
            fi
            final_output+="$decoded"
        fi
    done <<<"$selected_text"

    # Copy to clipboard
    if [ -n "$final_output" ]; then
        echo -n "$final_output" | wl-copy
        command -v wtype >/dev/null 2>&1 && wtype -M ctrl -P v -m ctrl
    fi
}

# View favorites
view_favorites() {
    prepare_favorites_for_display || {
        notify-send "No favorites."
        return
    }

    local selected_favorite
    selected_favorite=$(printf "%s\n" "${decoded_lines[@]}" | run_rofi "📌 View Favorites")

    if [ -n "$selected_favorite" ]; then
        local index
        index=$(printf "%s\n" "${decoded_lines[@]}" | grep -nxF "$selected_favorite" | cut -d: -f1)

        if [ -n "$index" ]; then
            local selected_encoded_favorite="${favorites[$((index - 1))]}"
            echo "$selected_encoded_favorite" | base64 --decode | wl-copy
            command -v wtype >/dev/null 2>&1 && wtype -M ctrl -P v -m ctrl
            notify-send "Copied to clipboard."
        else
            notify-send "Error: Selected favorite not found."
        fi
    fi
}

# Add item to favorites
add_to_favorites() {
    ensure_favorites_dir

    # Store cliphist list output
    local clip_list
    clip_list=$(cliphist list)
    
    # Show only text content in rofi
    local item_text
    item_text=$(echo "$clip_list" | awk -F'\t' '{for(i=2;i<=NF;i++) printf "%s%s", $i, (i<NF?"\t":""); print ""}' | run_rofi "➕ Add to Favorites...")

    if [ -n "$item_text" ]; then
        # Find the full line with ID
        local full_line
        full_line=$(echo "$clip_list" | grep -F "$item_text" | head -n1)
        
        local full_item
        full_item=$(echo "$full_line" | cliphist decode)

        local encoded_item
        encoded_item=$(echo "$full_item" | base64 -w 0)

        if [ -f "$favorites_file" ] && grep -Fxq "$encoded_item" "$favorites_file"; then
            notify-send "Item is already in favorites."
        else
            echo "$encoded_item" >>"$favorites_file"
            notify-send "Added to favorites."
        fi
    fi
}

# Delete from favorites
delete_from_favorites() {
    prepare_favorites_for_display || {
        notify-send "No favorites to remove."
        return
    }

    local selected_favorite
    selected_favorite=$(printf "%s\n" "${decoded_lines[@]}" | run_rofi "➖ Remove from Favorites...")

    if [ -n "$selected_favorite" ]; then
        local index
        index=$(printf "%s\n" "${decoded_lines[@]}" | grep -nxF "$selected_favorite" | cut -d: -f1)

        if [ -n "$index" ]; then
            local selected_encoded_favorite="${favorites[$((index - 1))]}"

            if [ "$(wc -l <"$favorites_file")" -eq 1 ]; then
                : >"$favorites_file"
            else
                grep -vF -x "$selected_encoded_favorite" "$favorites_file" >"${favorites_file}.tmp" &&
                    mv "${favorites_file}.tmp" "$favorites_file"
            fi
            notify-send "Item removed from favorites."
        else
            notify-send "Error: Selected favorite not found."
        fi
    fi
}

# Clear all favorites
clear_favorites() {
    if [ -f "$favorites_file" ] && [ -s "$favorites_file" ]; then
        local confirm
        confirm=$(echo -e "Yes\nNo" | run_rofi "☢️ Clear All Favorites?")

        if [ "$confirm" = "Yes" ]; then
            : >"$favorites_file"
            notify-send "All favorites have been deleted."
        fi
    else
        notify-send "No favorites to delete."
    fi
}

# Manage favorites
manage_favorites() {
    local manage_action
    manage_action=$(echo -e "Add to Favorites\nDelete from Favorites\nClear All Favorites" |
        run_rofi "📓 Manage Favorites")

    case "${manage_action}" in
    "Add to Favorites")
        add_to_favorites
        ;;
    "Delete from Favorites")
        delete_from_favorites
        ;;
    "Clear All Favorites")
        clear_favorites
        ;;
    *)
        [ -n "${manage_action}" ] || return 0
        echo "Invalid action"
        exit 1
        ;;
    esac
}

# Clear clipboard history with options
clear_history() {
    local confirm
    confirm=$(echo -e "Clear Everything\nClear Copies Only\nCancel" | run_rofi "☢️ Clear Clipboard History?")

    case "$confirm" in
    "Clear Everything")
        cliphist wipe
        [ -f "$favorites_file" ] && : >"$favorites_file"
        notify-send "Clipboard history and favorites cleared."
        ;;
    "Clear Copies Only")
        cliphist wipe
        notify-send "Clipboard history cleared. Favorites preserved."
        ;;
    "Cancel")
        notify-send "Clear operation cancelled."
        ;;
    esac
}

# Main function
main() {
    local main_action
    if [ $# -eq 0 ]; then
        main_action=$(echo -e "History\nView Favorites\nManage Favorites\nClear History" |
            run_rofi "🔎 Choose action")
    else
        main_action="$1"
    fi

    case "${main_action}" in
    -c | --copy | "History")
        show_history "$@"
        ;;
    -f | --favorites | "View Favorites")
        view_favorites "$@"
        ;;
    -mf | -manage-fav | "Manage Favorites")
        manage_favorites
        ;;
    -w | --wipe | "Clear History")
        clear_history
        ;;
    *)
        [ -z "$main_action" ] && exit 0
        ;;
    esac
}

main "$@"