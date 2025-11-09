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

			-- Load friendly snippets
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				-- Performance optimization
				performance = {
					debounce = 60,
					throttle = 30,
					fetching_timeout = 500,
					max_view_entries = 30,
				},

				-- Mapping configuration
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.abort(),

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
				}),

				-- Source priority configuration
				sources = cmp.config.sources({
					{
						name = "nvim_lsp",
						priority = 1000,
						-- Filter out Text kind from LSP (usually noise)
						entry_filter = function(entry)
							return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
						end,
					},
					{
						name = "luasnip",
						priority = 750,
						max_item_count = 5,
					},
					{
						name = "path",
						priority = 500,
						option = {
							trailing_slash = true,
						},
					},
					{
						name = "buffer",
						priority = 250,
						keyword_length = 3, -- Only trigger after 3 chars
						max_item_count = 5,
					},
				}),

				sorting = {
					priority_weight = 2,
					comparators = {
						cmp.config.compare.locality, -- LOCAL VARIABLES FIRST!
						cmp.config.compare.recently_used, -- Recently used items
						cmp.config.compare.score, -- LSP relevance score
						cmp.config.compare.offset, -- Position in line
						cmp.config.compare.exact, -- Exact matches
						cmp.config.compare.kind, -- CompletionItemKind
						cmp.config.compare.sort_text, -- LSP sortText
						cmp.config.compare.length, -- Shorter items first
						cmp.config.compare.order, -- Original order
					},
				},

				-- Better visual formatting
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						local kind_icons = {
							Text = "󰉿",
							Method = "󰆧",
							Function = "󰊕",
							Constructor = "",
							Field = "󰜢",
							Variable = "󰀫",
							Class = "󰠱",
							Interface = "",
							Module = "",
							Property = "󰜢",
							Unit = "󰑭",
							Value = "󰎠",
							Enum = "",
							Keyword = "󰌋",
							Snippet = "",
							Color = "󰏘",
							File = "󰈙",
							Reference = "󰈇",
							Folder = "󰉋",
							EnumMember = "",
							Constant = "󰏿",
							Struct = "󰙅",
							Event = "",
							Operator = "󰆕",
							TypeParameter = "",
						}

						vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
						vim_item.menu = ({
							nvim_lsp = "[LSP]",
							luasnip = "[Snip]",
							buffer = "[Buf]",
							path = "[Path]",
						})[entry.source.name]

						return vim_item
					end,
				},

				-- Better window styling
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				-- Experimental features
				experimental = {
					ghost_text = false, -- Disable ghost text (can be distracting)
				},
			})

			-- Cmdline completions
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},
}
