return {
	"projekt0n/github-nvim-theme",
	name = "github-theme",
	lazy = false,
	priority = 1000,
	config = function()
		require("github-theme").setup({
			options = {
				theme_style = "dark_dimmed",
			},
		})
		vim.cmd("colorscheme github_dark_dimmed")

		-- enable transparency
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	end,
}
