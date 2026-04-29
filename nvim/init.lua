require("vim._core.ui2").enable({
	enable = true,
	msg = {
		target = "cmd", -- Routes all messages to the cmdline area
		pager = { height = 0.4 },
		msg = { height = 0.5, timeout = 3000 },
		dialog = { height = 0.5 },
		cmd = { height = 0.5 },
	},
})

require("config.options")
require("config.keymaps")
require("config.pack")
