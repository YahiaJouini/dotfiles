return {
	"neovim/nvim-lspconfig",
	config = function()
		local vim = vim

		-- Get completion capabilities from nvim-cmp
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Configure clangd with optimal settings
		vim.lsp.config.clangd = {
			cmd = {
				"clangd",
				"--background-index", -- Index project in background
				"--clang-tidy", -- Enable clang-tidy checks
				"--header-insertion=iwyu", -- Smart include insertion
				"--completion-style=detailed", -- Detailed completions
				"--function-arg-placeholders", -- Show parameter placeholders
				"--fallback-style=llvm", -- Default style
				"--all-scopes-completion", -- Complete from all scopes
				"--log=error", -- Less verbose logging
			},
			capabilities = capabilities,
			root_markers = {
				"compile_commands.json",
				".clangd",
				".git",
				"CMakeLists.txt",
			},
			filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
		}

		-- Configure lua_ls
		vim.lsp.config.lua_ls = {
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = { enable = false },
				},
			},
		}

		-- Configure ts_ls
		vim.lsp.config.ts_ls = {
			capabilities = capabilities,
		}

		-- Configure ts_ls with inlay hints
		vim.lsp.config.ts_ls = {
			capabilities = capabilities,
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
				javascript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
			},
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			},
		}

		-- Enable the LSPs
		vim.lsp.enable({
			"lua_ls",
			"clangd",
			"ts_ls",
		})

		-- Diagnostic configuration
		vim.diagnostic.config({
			virtual_text = {
				spacing = 4,
				prefix = "●",
				format = function(diagnostic)
					local msg = diagnostic.message or ""
					local first_line = msg:match("^[^\n]+") or msg
					first_line = first_line:gsub("^%s+", ""):gsub("%s+$", "")
					return first_line
				end,
				severity = { min = vim.diagnostic.severity.WARN },
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		-- Customize diagnostic signs
		local signs = { Error = "", Warn = "", Hint = "", Info = "" }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end

		vim.lsp.inlay_hint.enable(false)

		-- LSP attach autocmd for keybindings
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local bufnr = ev.buf
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				local opts = { buffer = bufnr, silent = true }

				-- Keymaps
				vim.keymap.set(
					"n",
					"K",
					vim.lsp.buf.hover,
					vim.tbl_extend("force", opts, { desc = "Hover Documentation" })
				)
				vim.keymap.set(
					"n",
					"gd",
					vim.lsp.buf.definition,
					vim.tbl_extend("force", opts, { desc = "Go to Definition" })
				)
				vim.keymap.set(
					"n",
					"gD",
					vim.lsp.buf.declaration,
					vim.tbl_extend("force", opts, { desc = "Go to Declaration" })
				)
				vim.keymap.set(
					"n",
					"gi",
					vim.lsp.buf.implementation,
					vim.tbl_extend("force", opts, { desc = "Go to Implementation" })
				)
				vim.keymap.set(
					"n",
					"gt",
					vim.lsp.buf.type_definition,
					vim.tbl_extend("force", opts, { desc = "Go to Type Definition" })
				)
				vim.keymap.set(
					"n",
					"gr",
					vim.lsp.buf.references,
					vim.tbl_extend("force", opts, { desc = "Go to References" })
				)
				vim.keymap.set(
					"n",
					"<leader>rn",
					vim.lsp.buf.rename,
					vim.tbl_extend("force", opts, { desc = "Rename Symbol" })
				)
				vim.keymap.set(
					{ "n", "v" },
					"<leader>ca",
					vim.lsp.buf.code_action,
					vim.tbl_extend("force", opts, { desc = "Code Action" })
				)
				vim.keymap.set("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, vim.tbl_extend("force", opts, { desc = "Format" }))

				-- Clangd-specific: switch between header/source
				if client and client.name == "clangd" then
					vim.keymap.set(
						"n",
						"<leader>ch",
						"<cmd>ClangdSwitchSourceHeader<cr>",
						vim.tbl_extend("force", opts, { desc = "Switch Header/Source" })
					)
				end
			end,
		})

		-- Auto-show diagnostics on cursor hold
		vim.o.updatetime = 500
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = function()
				vim.diagnostic.open_float(nil, {
					focusable = false,
					border = "rounded",
					source = "always",
					scope = "cursor",
				})
			end,
		})
	end,
}
