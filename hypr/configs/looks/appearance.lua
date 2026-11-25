hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 5,
        border_size = 2,
        col = {
            active_border = "rgba(cdd6f4aa)",
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 0,
        active_opacity = 1.0,
        inactive_opacity = 0.9,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = true,
            size = 6,
            passes = 3,
            ignore_opacity = true,
        },
    },
})

hl.layer_rule({
    match = { namespace = "^(logout_dialog)$" },
    blur = true,
})

hl.layer_rule({
    match = { namespace = "^(swayosd)$" },
    blur = true,
})

hl.layer_rule({
    match = { namespace = "^(swayosd)$" },
    ignore_alpha = 0.2,
})
