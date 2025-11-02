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
			virtual_text = true,
			signs = true,
			underline = true,
			update_in_insert = false,
		})
      -- Keymaps for LSP
		vim.keymap.set("n", "<S-i>", vim.lsp.buf.hover, {})
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
	end,
}
