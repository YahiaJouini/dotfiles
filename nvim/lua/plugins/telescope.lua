return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					path_display = { "truncate" },
					file_ignore_patterns = {
						"%.git/",
						"node_modules/",
						"%.jpg",
						"%.jpeg",
						"%.png",
						"%.svg",
						"%.otf",
						"%.ttf",
						"%.lock",
						"%.DS_Store",
						"%.pdf",
						"%.zip",
						"%.tar.gz",
						"%.exe",
						"%.bin",
					},
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						},
					},
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
						"--glob=!*.{png,jpg,jpeg,gif,webp,pdf,zip,exe,so,dll,o,pyc,pyd}",
					},
				},
				pickers = {
					find_files = {
						hidden = true,
						find_command = {
							"fd",
							"--type",
							"f",
							"--strip-cwd-prefix",
							"--exclude",
							".git",
							"--exclude",
							"*.png",
							"--exclude",
							"*.jpg",
							"--exclude",
							"*.jpeg",
							"--exclude",
							"*.exe",
							"--exclude",
							"*.bin",
							"--exclude",
							"*.so",
							"--exclude",
							"*.dll",
							"--exclude",
							"*.pyc",
							"--exclude",
							"*.pdf",
							"--exclude",
							"*.zip",
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})

			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find Files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
			vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent Files" })
			vim.keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Find String Under Cursor" })
		end,
	},
}
