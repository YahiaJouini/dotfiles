vim.pack.add({ {
	src = "https://github.com/bluz71/vim-moonfly-colors",
	name = "moonfly",
} })

vim.g.moonflyItalics = true
vim.g.moonflyTerminalColors = true
vim.g.moonflyTransparent = false

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "moonfly",
	callback = function()
		-- Hard, visible window dividers
		vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#555555", bg = "none" })
		vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = "#555555", bg = "none" })

		-- Distinct Neo-tree cursor block
		vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = "#2e2e2e", bold = true })
	end,
})

vim.cmd.colorscheme("moonfly")
