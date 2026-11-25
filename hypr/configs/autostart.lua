hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")

    hl.exec_cmd("~/.config/hypr/scripts/resetxdgportal.sh")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    hl.exec_cmd("sleep 1 && waybar")

    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("wl-clip-persist --clipboard regular")

    hl.exec_cmd("swaync")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 22")
    hl.exec_cmd("hyprsunset --identity")

    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,pkcs11,ssh")
    hl.exec_cmd("swayosd-server -s ~/.config/swayosd/style.css --top-margin 0.5")
end)
