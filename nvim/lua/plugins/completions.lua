return {
	--github copilot
	{
		"github/copilot.vim",
		config = function()
			-- disable default tab mapping
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true

			-- accept the whole suggestion
			vim.api.nvim_set_keymap(
				"i",
				"<S-Right>",
				'copilot#Accept("")',
				{ silent = true, expr = true, replace_keycodes = false }
			)

			-- accept one word at a time
			vim.api.nvim_set_keymap(
				"i",
				"<C-Right>",
				'copilot#AcceptWord("")',
				{ silent = true, expr = true, replace_keycodes = false }
			)
		end,
	},
	-- Signature hints
	{
		"ray-x/lsp_signature.nvim",
		event = "LspAttach", -- Better event trigger
		config = function()
			require("lsp_signature").setup({
				bind = true,
				floating_window = true,
				floating_window_above_cur_line = true,
				hint_enable = false,
				always_trigger = true,
				auto_close_after = 3,
				max_height = 10,
				max_width = 80,
				timer_interval = 200,
				handler_opts = {
					border = "rounded",
				},
				padding = " ",
			})
		end,
	},
	-- nvim-cmp for autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = {
					["<C-Space>"] = cmp.mapping.complete(), -- trigger completion
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- confirm selection
					["<Down>"] = cmp.mapping.select_next_item(),
					["<Up>"] = cmp.mapping.select_prev_item(),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
				experimental = { ghost_text = true }, -- VSCode-style inline preview
			})

			-- use cmp for cmdline completion
			cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })
			cmp.setup.cmdline(":", { sources = { { name = "path" }, { name = "cmdline" } } })
		end,
	},
}
