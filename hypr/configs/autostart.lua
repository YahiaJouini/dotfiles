hl.on("hyprland.start", function()
    -- MUST be first — makes Wayland/portal env vars available to all D-Bus activated services
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")

    -- --- XDG Desktop Portal ---
    -- Handles screen sharing, file pickers, etc. Kill stale portals first to avoid conflicts.
    hl.exec_cmd("~/.config/hypr/scripts/resetxdgportal.sh")

    -- --- Authentication Agent (Polkit) ---
    -- Required for apps that need sudo/elevated permissions via GUI (e.g. partition managers)
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    -- --- Status Bar ---
    hl.exec_cmd("sleep 1 && waybar")

    -- --- Clipboard Manager ---
    -- cliphist stores both text and image clipboard history
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    -- wl-clip-persist keeps clipboard alive after an app closes (critical on Wayland)
    hl.exec_cmd("wl-clip-persist --clipboard regular")

    -- --- Notifications ---
    hl.exec_cmd("swaync")

    -- --- Network Manager Applet (tray icon) ---
    hl.exec_cmd("nm-applet --indicator")

    -- --- Idle / Lock daemon ---
    hl.exec_cmd("hypridle")

    hl.exec_cmd("awww-daemon")

    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 22")

    hl.exec_cmd("hyprsunset --identity")

    -- ---Theming
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'")

    -- --Gnome keyring-daemon
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,pkcs11,ssh")

    -- -- Audio OSD
    hl.exec_cmd("swayosd-server -s ~/.config/swayosd/style.css --top-margin 0.5")
end)
