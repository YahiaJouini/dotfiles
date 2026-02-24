return {
	"neovim/nvim-lspconfig",
	config = function()
		local vim = vim

		-- Get completion capabilities from nvim-cmp
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Helper: smarter formatting client selection
		local function format_buffer(bufnr)
			local ft = vim.bo[bufnr].filetype

			vim.lsp.buf.format({
				async = true,
				bufnr = bufnr,
				filter = function(client)
					-- Python: prefer ruff for formatting
					if ft == "python" then
						return client.name == "ruff"
					end

					-- JS/TS: prefer eslint if attached
					if
						ft == "javascript"
						or ft == "javascriptreact"
						or ft == "typescript"
						or ft == "typescriptreact"
					then
						if client.name == "eslint" then
							return true
						end
						-- fallback if eslint not attached
						return client.name == "ts_ls"
					end

					-- Default: allow any formatter-capable client
					return client:supports_method("textDocument/formatting")
				end,
			})
		end

		-- Configure clangd with optimal settings
		vim.lsp.config.clangd = {
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=iwyu",
				"--completion-style=detailed",
				"--function-arg-placeholders",
				"--fallback-style=llvm",
				"--all-scopes-completion",
				"--log=error",
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

		-- Configure gopls (Go)
		vim.lsp.config.gopls = {
			capabilities = capabilities,
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
						nilness = true,
						shadow = true,
					},
					staticcheck = true,
					codelenses = {
						gc_details = true,
						test = true,
						tidy = true,
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						rangeVariableTypes = true,
					},
					gofumpt = true,
				},
			},
			filetypes = { "go", "gomod" },
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

		-- Configure tailwindcss
		vim.lsp.config.tailwindcss = {
			capabilities = capabilities,
		}

		-- Configure eslint
		vim.lsp.config.eslint = {
			capabilities = capabilities,
		}

		-- Configure pyright (Python completion/type checking)
		vim.lsp.config.pyright = {
			capabilities = capabilities,
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "workspace",
						typeCheckingMode = "basic", -- "off" | "basic" | "strict"
					},
				},
			},
			filetypes = { "python" },
		}

		-- Configure ruff (Python linting + formatting + import organization)
		vim.lsp.config.ruff = {
			capabilities = capabilities,
			init_options = {
				settings = {
					-- If your installed ruff supports these, they'll be used.
					-- Safe to keep here for modern setups.
					format = {
						enabled = true,
					},
					organizeImports = true,
				},
			},
			filetypes = { "python" },
		}

		-- Enable the LSPs
		vim.lsp.enable({
			"lua_ls",
			"clangd",
			"ts_ls",
			"gopls",
			"tailwindcss",
			"eslint",
			"pyright",
			"ruff",
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
				source = true,
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

		if vim.lsp.inlay_hint then
			vim.lsp.inlay_hint.enable(false)
		end

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
					format_buffer(bufnr)
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

		-- Auto-show diagnostics on cursor hold (only if there is something on cursor line)
		vim.o.updatetime = 500
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = function()
				local diags = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
				if not diags or vim.tbl_isempty(diags) then
					return
				end

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
