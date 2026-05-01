#!/usr/bin/env bash

pkill -u "$USER" rofi && exit 0

cache_dir="${HOME}/.cache/cliphist"
favorites_file="${HOME}/.cliphist_favorites"
mkdir -p "$cache_dir"

ENUM_COLOR="#CCCCCC"

run_rofi() {
    # Added 'markup: true' to element-text. Without this, rofi-wayland ignores Pango.
    rofi -dmenu -i -markup-rows -p "$1" \
        -theme-str 'window { width: 800px; }' \
        -theme-str 'listview { lines: 10; spacing: 4px; }' \
        -theme-str 'element { padding: 10px 15px; spacing: 10px; }' \
-theme-str 'element-text { vertical-align: 0.5; lines: 1; font: "JetBrainsMono Nerd Font 12"; }' \
        -theme-str 'element-icon { size: 0px; }'
}

prepare_history() {
    # Changed foreground to color for strict Pango compliance
    cliphist list | awk -F'\t' -v c="$ENUM_COLOR" '
    {
        text = $2
        gsub(/&/, "&amp;", text)
        gsub(/</, "&lt;", text)
        gsub(/>/, "&gt;", text)
        printf "<span color=\"%s\">%d.</span> %s\n", c, NR, text
    }'
}

show_history() {
    local clip_list
    clip_list=$(cliphist list)
    
    local selected
    selected=$(
        {
            echo "📌 Favorites"
            echo "⚙️ Options"
            prepare_history
        } | run_rofi "Clipboard"
    )

    [[ -z "$selected" ]] && exit 0

    case "$selected" in
        "📌 Favorites") exec "$0" --favorites ;;
        "⚙️ Options")   exec "$0" --manage ;;
    esac

    local pure_text
    pure_text=$(echo "$selected" | sed -E 's/<span[^>]*>[0-9]+\.<\/span> //; s/&lt;/</g; s/&gt;/>/g; s/&amp;/\&/g')

    local full_line
    full_line=$(echo "$clip_list" | grep -F "$pure_text" | head -n1)

    if [[ -n "$full_line" ]]; then
        echo "$full_line" | cliphist decode | wl-copy
        command -v wtype >/dev/null && wtype -M ctrl -P v -m ctrl
    fi
}

view_favorites() {
    [[ ! -f "$favorites_file" ]] && { notify-send "Empty" "No favorites saved."; return; }

    mapfile -t favorites < "$favorites_file"
    local display_favs=""
    
    for i in "${!favorites[@]}"; do
        local text
        text=$(echo "${favorites[$i]}" | base64 --decode | tr '\n' ' ')
        
        text="${text//&/&amp;}"
        text="${text//</&lt;}"
        text="${text//>/&gt;}"
        
        display_favs+="<span color=\"$ENUM_COLOR\">$((i+1)).</span> $text"$'\n'
    done

    local selected
    selected=$(echo -e -n "$display_favs" | run_rofi "Favorites")
    [[ -z "$selected" ]] && return

    local idx
    idx=$(echo "$selected" | sed -E 's/<span[^>]*>([0-9]+)\.<\/span>.*/\1/')
    
    echo "${favorites[$((idx-1))]}" | base64 --decode | wl-copy
    command -v wtype >/dev/null && wtype -M ctrl -P v -m ctrl
}

manage_options() {
    local action
    action=$(echo -e "Clear Everything\nClear Copies Only\nCancel" | run_rofi "Manage")

    case "$action" in
        "Clear Everything")
            cliphist wipe
            [ -f "$favorites_file" ] && : >"$favorites_file"
            notify-send "Clipboard" "History and favorites wiped."
            ;;
        "Clear Copies Only")
            cliphist wipe
            notify-send "Clipboard" "History wiped. Favorites kept."
            ;;
    esac
}

main() {
    case "${1}" in
        -c|--copy|"")        show_history ;;
        -f|--favorites)      view_favorites ;;
        -mf|--manage)        manage_options ;;
        *)                   show_history ;;
    esac
}

main "$@"
