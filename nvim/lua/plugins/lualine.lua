vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
})

-- 2. Synchronous execution to prevent UI flicker on boot
require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "moonfly",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },

		-- Forces a single, global statusline at the bottom of Neovim.
		-- Prevents UI clutter when opening multiple vertical/horizontal splits.
		globalstatus = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	extensions = { "neo-tree", "mason" },
})
