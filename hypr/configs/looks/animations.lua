hl.curve("smoothOut", {
    type = "bezier",
    points = { { 0.05, 0.9 }, { 0.1, 1.03 } },
})
hl.curve("smoothIn", {
    type = "bezier",
    points = { { 0.2, 1 }, { 0.5, 1 } },
})
hl.curve("linear", {
    type = "bezier",
    points = { { 0, 0 }, { 1, 1 } },
})
hl.curve("silky", {
    type = "bezier",
    points = { { 0.25, 0.1 }, { 0.25, 1 } },
})

hl.animation({ leaf = "global", enabled = true, speed = 3, bezier = "smoothOut" })
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "smoothOut", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "smoothIn", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "smoothOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "smoothIn", style = "slide" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "smoothIn" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 3, bezier = "smoothOut" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "smoothOut", style = "slidefade 10%" })
