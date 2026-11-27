-- Don't let floating windows get maximize-spammed by apps
hl.window_rule({
  name = "float-suppress-maximize",
  match = { float = true },
  suppress_event = "maximize",
})
-- hl.window_rule({
--     name = "float-suppress-fullscreen",
--     match = { float = true },
--     suppress_event = "fullscreen",
-- }) -- optional

-- XWayland empty helper windows (ghost/no-class): never steal focus
hl.window_rule({
  name = "xwayland-ghost-no-focus",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
  },
  no_focus = true,
})

-- Modals behave like modals
hl.window_rule({
  name = "modals-behavior",
  match = { modal = true },
  float = true,
  center = true,
  stay_focused = true,
})

-- Pinentry focus fix
hl.window_rule({
  name = "pinentry-focus",
  match = { class = "^(pinentry-.*)$" },
  stay_focused = true,
})

-- ---- pavucontrol popup
hl.window_rule({
  name = "pavucontrol-popup",
  match = { class = "^(org\\.pulseaudio\\.pavucontrol)$" },
  float = true,
  size = "800 400",
  center = true,
  stay_focused = true,
})

-- ---- Satty Screenshot Annotation
-- NO stay_focused here — it blocks the file dialog from getting input!
hl.window_rule({
  name = "satty-annotation",
  match = { class = "^(com\\.gabm\\.satty)$" },
  float = true,
  center = true,
  size = "1200 800",
  suppress_event = "fullscreen",
})

-- ---- Satty's file save dialog (GTK4 native, same class, different title)
hl.window_rule({
  name = "satty-file-dialog",
  match = {
    class = "^(com\\.gabm\\.satty)$",
    title = "^(Save|Open|Choose)(.*)$",
  },
  float = true,
  center = true,
  size = "900 600",
  stay_focused = true,
})

-- ---- Network Manager GUI
hl.window_rule({
  name = "nm-connection-editor",
  match = { class = "^(nm-connection-editor)$" },
  float = true,
  size = "800 600",
  center = true,
  stay_focused = true,
})

-- ---- System TUIs (Audio & Network)
hl.window_rule({
  name = "sys-audio-mixer",
  match = { class = "^(sys-audio-mixer)$" },
  float = true,
  size = "800 450",
  center = true,
  stay_focused = true,
})

-- ---- Nautilus file picker (GTK portal)
hl.window_rule({
  name = "gtk-file-picker",
  match = { class = "^(xdg-desktop-portal-gtk)$" },
  float = true,
  size = "900 600",
  center = true,
  stay_focused = true,
})

-- ---- mpv
hl.window_rule({
  name = "mpv-window",
  match = { class = "^(mpv)$" },
  float = true,
  size = "1280 720",
  center = true,
  stay_focused = true,
  -- Prevent idle/lock while mpv is fullscreen
  idle_inhibit = "fullscreen",
})

-- Fix: JS alert()/confirm() dialogs not surfacing in browsers
hl.window_rule({
  name = "browser-float-dialogs",
  match = {
    class = "^(firefox|Navigator|chromium|brave-browser)$",
    float = true,
  },
  stay_focused = true,
})

hl.window_rule({
  name = "quick-viewers-float",
  match = { class = "^(imv|org\\.pwmt\\.zathura)$" },
  float = true,
  center = true,
  size = { 1000, 750 },
})
