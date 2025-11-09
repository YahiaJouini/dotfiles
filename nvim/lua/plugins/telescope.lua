return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make", -- C-based sorter for massive speed boost
			},
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					path_display = { "truncate" },
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						},
					},
					file_ignore_patterns = {
						"node_modules",
						".git/",
						"dist/",
						"build/",
					},
				},
				pickers = {
					find_files = {
						hidden = true,
					},
				},
			})

			-- Load fzf native extension for better performance
			telescope.load_extension("fzf")

			-- Keymaps
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find Files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
			vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent Files" })
			vim.keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Find String Under Cursor" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
