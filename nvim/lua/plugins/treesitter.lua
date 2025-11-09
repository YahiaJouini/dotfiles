return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		opts = {
			-- Languages for Next.js + TypeScript + C/C++ development
			ensure_installed = {
				-- Frontend (Next.js/React)
				"typescript",
				"tsx",
				"javascript",
				"html",
				"css",
				"json",

				-- Backend/Systems
				"cpp",
				"c",
				"lua",
				"bash",

				-- Config/Documentation
				"markdown",
				"markdown_inline",
				"yaml",
				"toml",

				-- Essential
				"vim",
				"vimdoc",
			},

			sync_install = false,
			auto_install = true,

			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},

			indent = {
				enable = true,
				disable = { "python" }, -- Sometimes buggy
			},

			-- Incremental selection with Treesitter
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},

			-- Text objects for better code navigation
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						-- Functions
						["af"] = "@function.outer",
						["if"] = "@function.inner",

						-- Classes/Components
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",

						-- Loops
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",

						-- Conditionals
						["ai"] = "@conditional.outer",
						["ii"] = "@conditional.inner",

						-- Parameters/Arguments
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",

						-- Comments
						["a/"] = "@comment.outer",
					},
				},

				-- Move between functions, classes, etc.
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
					},
				},

				-- Swap parameters/arguments
				swap = {
					enable = true,
					swap_next = {
						["<leader>sp"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>sP"] = "@parameter.inner",
					},
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
