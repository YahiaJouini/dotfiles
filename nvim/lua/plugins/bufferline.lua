return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("bufferline").setup({
			options = {
				numbers = "ordinal",
				close_command = "bdelete %d",
				right_mouse_command = "bdelete %d",
				diagnostics = "nvim_lsp",
				offsets = {
					{
						filetype = "neo-tree",
						text = "File Explorer",
						highlight = "Directory",
						text_align = "left",
					},
				},
				always_show_bufferline = true,
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		})

		vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", { silent = true })
		vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", { silent = true })
		-- azer keyboard mappings
		for i, key in ipairs({ "&", "é", '"', "'", "(", "-", "è", "_", "ç" }) do
			vim.keymap.set("n", key, string.format(":BufferLineGoToBuffer %d<CR>", i), { silent = true })
		end
	end,
}
