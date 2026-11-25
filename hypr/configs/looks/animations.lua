hl.config({
    animations = {
        enabled = true,
    },
})

-- Bezier curves
hl.curve("smoothOut", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.03 } } })
hl.curve("smoothIn",  { type = "bezier", points = { { 0.2, 1 },    { 0.5, 1 }    } })
hl.curve("linear",    { type = "bezier", points = { { 0, 0 },      { 1, 1 }      } })

-- Windows
hl.animation({ leaf = "windows",     enabled = true, speed = 3,   bezier = "smoothOut", style = "slide" })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 3,   bezier = "smoothIn",  style = "slide" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 2.5, bezier = "smoothOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3,   bezier = "smoothIn",  style = "slide" })

-- Fades
hl.animation({ leaf = "fade",    enabled = true, speed = 3,   bezier = "smoothIn"  })
hl.animation({ leaf = "fadeIn",  enabled = true, speed = 3,   bezier = "smoothIn"  })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2.5, bezier = "smoothOut" })

-- Layers (bars, launchers, notifications)
hl.animation({ leaf = "layers",        enabled = true, speed = 3,   bezier = "smoothOut", style = "fade" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 3,   bezier = "smoothIn",  style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5, bezier = "linear",    style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 2.5, bezier = "smoothIn"  })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.5, bezier = "linear"    })

-- Borders, workspaces, and zoom
hl.animation({ leaf = "border",     enabled = true, speed = 4, bezier = "smoothOut" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "smoothOut", style = "slidefade 10%" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 5, bezier = "smoothIn"  })
