return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons", "echasnovski/mini.bufremove" },
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
		-- safer delete current buffer
		vim.keymap.set("n", "<leader>bd", function()
			bufremove.delete(0, false)
		end, { silent = true, desc = "Delete current buffer" })

		-- buffer navigation
		vim.keymap.set("n", "<S-m>", ":BufferLineCycleNext<CR>", { silent = true })
		vim.keymap.set("n", "<S-l>", ":BufferLineCyclePrev<CR>", { silent = true })

		-- azerty keyboard mappings
		for i, key in ipairs({ "&", "é", '"', "'", "(", "-", "è", "_", "ç" }) do
			vim.keymap.set("n", key, string.format(":BufferLineGoToBuffer %d<CR>", i), { silent = true })
		end
	end,
}
