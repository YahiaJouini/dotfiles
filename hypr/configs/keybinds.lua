-- Set programs
local terminal = "kitty"
local fileManager = "nautilus"
local menu = "rofi -show drun"

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

local home = os.getenv("HOME") or "~"
local scriptsDir = home .. "/.config/scripts"

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(scriptsDir .. "/cliphist.sh"), { description = "clipboard" })
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist wipe")) -- clear clipboard
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + C", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreenstate 1 0"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(scriptsDir .. "/sys-power.sh"))
-- Region capture -> save to clipboard only
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
-- Region capture -> save to file
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(scriptsDir .. "/satty-shot.sh"))

-- Zoom
-- Zoom in (Ctrl + Super + Scroll Up)
hl.bind("CTRL + SUPER + mouse_down", function()
    local z = tonumber(hl.get_config("cursor.zoom_factor")) or 1.0
    hl.config({ cursor = { zoom_factor = z + 0.5 } })
end)
-- Zoom out (Ctrl + Super + Scroll Down)
hl.bind("CTRL + SUPER + mouse_up", function()
    local z = tonumber(hl.get_config("cursor.zoom_factor")) or 1.0
    hl.config({ cursor = { zoom_factor = math.max(z - 0.5, 1.0) } })
end)
-- Reset zoom (Ctrl + Super + Click Middle Mouse Button)
hl.bind("CTRL + SUPER + mouse:274", function()
    hl.config({ cursor = { zoom_factor = 1.0 } })
end)

-- Script bindings
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(scriptsDir .. "/wallpaper.sh")) -- pick random wallpaper
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(scriptsDir .. "/hyprsunset-toggle.sh"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(home .. "/.config/waybar/scripts/launch.sh")) -- reload waybar

-- Switch workspaces with mainMod + [1-4]
for i = 1, 4 do
    hl.bind(mainMod .. " + code:" .. (9 + i), hl.dsp.focus({ workspace = i }))
end

-- Move active window to a workspace with mainMod + SHIFT + [1-4]
for i = 1, 4 do
    hl.bind(mainMod .. " + SHIFT + code:" .. (9 + i), hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume +5"),          { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume -5"),          { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),              { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),              { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Resize windows
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.resize({ x = -50, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 50,  y = 0 }), { repeating = true })
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.resize({ x = 0,   y = -50 }), { repeating = true })
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.resize({ x = 0,   y = 50 }), { repeating = true })

-- Move windows
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

-- Swap windows
hl.bind(mainMod .. " + ALT + left",  hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + ALT + up",    hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + ALT + down",  hl.dsp.window.swap({ direction = "down" }))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
