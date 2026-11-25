-- ── NVIDIA ────────────────────────────────────────────────────────────────────
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GL_GSYNC_ALLOWED", "1")
hl.env("__GL_VRR_ALLOWED", "1")

-- ── Session Identity (D-Bus / Portals) ────────────────────────────────────────
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_MENU_PREFIX", "arch-")

-- ── Wayland Backends ──────────────────────────────────────────────────────────
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- ── Qt Theming ────────────────────────────────────────────────────────────────
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- ── Electron / Chrome Apps ────────────────────────────────────────────────────
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- ── Firefox ───────────────────────────────────────────────────────────────────
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- ── Cursor ────────────────────────────────────────────────────────────────────
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "22")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "22")

-- ── SSH ───────────────────────────────────────────────────────────────────────
local xdg_runtime_dir = os.getenv("XDG_RUNTIME_DIR")
if xdg_runtime_dir then
    hl.env("SSH_AUTH_SOCK", xdg_runtime_dir .. "/keyring/ssh")
end
