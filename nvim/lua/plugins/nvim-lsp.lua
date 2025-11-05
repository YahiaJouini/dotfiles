return {
	"neovim/nvim-lspconfig",
	config = function()
		local vim = vim
		vim.lsp.enable({
			"lua_ls",
			"clangd",
			"ts_ls",
		})
		-- Diagnostic configuration
		vim.diagnostic.config({
			float = {
				border = "rounded",
				focusable = false,
				style = "minimal",
				source = "always", -- show source (e.g. "eslint", "tsserver")
				header = "",
				prefix = "",
				wrap = true,
			},
			virtual_text = true,
			signs = true,
			underline = true,
			update_in_insert = false,
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local bufnr = ev.buf
				local opts = { buffer = bufnr }

				-- Hover documentation (shows function parameters, types, docs)
				vim.keymap.set(
					"n",
					"K",
					vim.lsp.buf.hover,
					vim.tbl_extend("force", opts, { desc = "Hover Documentation" })
				)

				-- Other LSP keymaps:
				vim.keymap.set(
					"n",
					"gd",
					vim.lsp.buf.definition,
					vim.tbl_extend("force", opts, { desc = "Go to Definition" })
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
					"n",
					"<leader>ca",
					vim.lsp.buf.code_action,
					vim.tbl_extend("force", opts, { desc = "Code Action" })
				)
			end,
		})
	end,
}
