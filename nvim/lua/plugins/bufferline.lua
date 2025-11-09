return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"famiu/bufdelete.nvim",
	},
	event = "VeryLazy",
	config = function()
		require("bufferline").setup({
			options = {
				mode = "buffers",
				numbers = "none",

				-- Use bufdelete for proper buffer deletion
				close_command = function(bufnum)
					require("bufdelete").bufdelete(bufnum, false)
				end,
				right_mouse_command = function(bufnum)
					require("bufdelete").bufdelete(bufnum, false)
				end,

				left_mouse_command = "buffer %d",
				middle_mouse_command = nil,

				indicator = {
					icon = "▎",
					style = "icon",
				},

				buffer_close_icon = "󰅖",
				modified_icon = "●",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",

				-- Offset for neo-tree
				offsets = {
					{
						filetype = "neo-tree",
						text = "File Explorer",
						text_align = "left",
						separator = true,
						highlight = "Directory",
						padding = 0,
					},
				},

				color_icons = true,
				show_buffer_icons = true,
				show_buffer_close_icons = true,
				show_close_icon = false,
				show_tab_indicators = true,
				show_duplicate_prefix = true,

				persist_buffer_sort = true,
				separator_style = "thin",
				enforce_regular_tabs = false,
				always_show_bufferline = true,

				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},

				sort_by = "insert_after_current",

				diagnostics = "nvim_lsp",
				diagnostics_update_in_insert = false,
				diagnostics_indicator = function(count, level)
					local icon = level:match("error") and " " or " "
					return " " .. icon .. count
				end,

				-- Filter out neo-tree and special buffers
				custom_filter = function(buf_number)
					local buftype = vim.bo[buf_number].buftype
					if buftype == "terminal" or buftype == "quickfix" then
						return false
					end

					local filetype = vim.bo[buf_number].filetype
					if filetype == "neo-tree" or filetype == "neo-tree-popup" then
						return false
					end

					return true
				end,

				max_name_length = 18,
				max_prefix_length = 15,
				tab_size = 18,
				truncate_names = true,
			},
		})

		-- Buffer delete
		vim.keymap.set("n", "<leader>db", function()
			require("bufdelete").bufdelete(0, false)
		end, {
			noremap = true,
			silent = true,
			desc = "Delete current buffer",
		})

		-- Force delete buffer
		vim.keymap.set("n", "<leader>dB", function()
			require("bufdelete").bufdelete(0, true)
		end, {
			noremap = true,
			silent = true,
			desc = "Force delete buffer",
		})

		-- Buffer navigation
		vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", {
			noremap = true,
			silent = true,
			desc = "Next buffer",
		})

		vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", {
			noremap = true,
			silent = true,
			desc = "Previous buffer",
		})

		-- AZERTY keyboard mappings (go to buffer by number)
		for i, key in ipairs({ "&", "é", '"', "'", "(", "-", "è", "_", "ç" }) do
			vim.keymap.set("n", key, string.format(":BufferLineGoToBuffer %d<CR>", i), {
				silent = true,
				desc = "Go to buffer " .. i,
			})
		end
		-- Delete all buffers except current
		vim.keymap.set("n", "<leader>bo", function()
			local current = vim.api.nvim_get_current_buf()
			local buffers = vim.api.nvim_list_bufs()
			for _, buf in ipairs(buffers) do
				if buf ~= current and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
					require("bufdelete").bufdelete(buf, false)
				end
			end
		end, {
			noremap = true,
			silent = true,
			desc = "Delete all buffers except current",
		})

		-- Pick buffer
		vim.keymap.set("n", "<leader>bp", ":BufferLinePick<CR>", {
			noremap = true,
			silent = true,
			desc = "Pick buffer",
		})

		-- Pick buffer to close
		vim.keymap.set("n", "<leader>bc", ":BufferLinePickClose<CR>", {
			noremap = true,
			silent = true,
			desc = "Pick buffer to close",
		})

		-- Move buffers
		vim.keymap.set("n", "<leader>b>", ":BufferLineMoveNext<CR>", {
			noremap = true,
			silent = true,
			desc = "Move buffer right",
		})

		vim.keymap.set("n", "<leader>b<", ":BufferLineMovePrev<CR>", {
			noremap = true,
			silent = true,
			desc = "Move buffer left",
		})

		-- Pin buffer
		vim.keymap.set("n", "<leader>bP", ":BufferLineTogglePin<CR>", {
			noremap = true,
			silent = true,
			desc = "Toggle buffer pin",
		})
	end,
}
