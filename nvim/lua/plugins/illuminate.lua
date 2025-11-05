return {
	"RRethy/vim-illuminate",
	event = "VeryLazy",
	config = function()
		require("illuminate").configure({
			delay = 200,
			filetypes_denylist = { "neo-tree", "NvimTree", "TelescopePrompt" },
		})
	end,
}
