return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting

		null_ls.setup({
			sources = {
				formatting.clang_format, -- C/C++
				formatting.prettier, -- TypeScript/JS
				formatting.stylua, -- Lua
			},
		})

		-- Format on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			callback = function()
				vim.lsp.buf.format({ timeout_ms = 3000 })
			end,
		})
	end,
}
