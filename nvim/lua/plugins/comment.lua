return {
	"numToStr/Comment.nvim",
	keys = {
		{ "m", mode = { "n", "v" }, desc = "Toggle comment" },
	},
	config = function()
		require("Comment").setup()

		-- Normal mode: toggle current line
		vim.keymap.set("n", "m", function()
			require("Comment.api").toggle.linewise.current()
		end, { noremap = true, silent = true })

		-- Visual mode: toggle selected lines
		vim.keymap.set("v", "m", function()
			local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
			vim.api.nvim_feedkeys(esc, "nx", false)
			require("Comment.api").toggle.linewise(vim.fn.visualmode())
		end, { noremap = true, silent = true })
	end,
}
