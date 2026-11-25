hl.window_rule({
    name = "suppress-floating-maximize",
    match = { float = true },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "no-focus-empty-xwayland",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
    },
    no_focus = true,
})

hl.window_rule({
    name = "modal-behavior",
    match = { modal = true },
    float = true,
    center = true,
    stay_focused = true,
})

hl.window_rule({
    name = "pinentry-focus",
    match = { class = "^(pinentry-.*)$" },
    stay_focused = true,
})

hl.window_rule({
    name = "pavucontrol-popup",
    match = { class = "^(org\\.pulseaudio\\.pavucontrol)$" },
    float = true,
    size = { 800, 400 },
    center = true,
    stay_focused = true,
})

hl.window_rule({
    name = "satty-annotation",
    match = { class = "^(com\\.gabm\\.satty)$" },
    float = true,
    center = true,
    size = { 1200, 800 },
    suppress_event = "fullscreen",
})

hl.window_rule({
    name = "satty-file-dialog",
    match = {
        class = "^(com\\.gabm\\.satty)$",
        title = "^(Save|Open|Choose)(.*)$",
    },
    float = true,
    center = true,
    size = { 900, 600 },
    stay_focused = true,
})

hl.window_rule({
    name = "network-manager-editor",
    match = { class = "^(nm-connection-editor)$" },
    float = true,
    size = { 800, 600 },
    center = true,
    stay_focused = true,
})

hl.window_rule({
    name = "system-audio-mixer",
    match = { class = "^(sys-audio-mixer)$" },
    float = true,
    size = { 800, 450 },
    center = true,
    stay_focused = true,
})

hl.window_rule({
    name = "nautilus-file-picker",
    match = { class = "^(xdg-desktop-portal-gtk)$" },
    float = true,
    size = { 900, 600 },
    center = true,
    stay_focused = true,
})

hl.window_rule({
    name = "mpv-window",
    match = { class = "^(mpv)$" },
    float = true,
    size = { 1280, 720 },
    center = true,
    stay_focused = true,
})

hl.window_rule({
    name = "browser-dialog-focus",
    match = {
        class = "^(firefox|Navigator|chromium|brave-browser)$",
        float = true,
    },
    stay_focused = true,
})

hl.window_rule({
    name = "mpv-fullscreen-idle-inhibit",
    match = { class = "^(mpv)$" },
    idle_inhibit = "fullscreen",
})
