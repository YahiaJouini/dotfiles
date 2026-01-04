return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = false,
			term_colors = true,
			color_overrides = {
				mocha = {
					base = "#000000", -- Pitch black background
					mantle = "#010101", -- Slightly lighter black for sidebars
					crust = "#000000",
				},
			},
			integrations = {
				neotree = true,
				bufferline = true,
				treesitter = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
			},
			custom_highlights = function(colors)
				return {
					-- This creates the vertical line between Neo-tree and the editor
					WinSeparator = { fg = colors.surface2, style = { "bold" } },
					NeoTreeWinSeparator = { fg = colors.surface2, style = { "bold" } },
					-- Makes the active buffer tab stand out more
					BufferLineIndicatorSelected = { fg = colors.pink },
				}
			end,
		})

		vim.cmd.colorscheme("catppuccin")
	end,
}
