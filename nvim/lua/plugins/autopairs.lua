return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		local npairs = require("nvim-autopairs")
		npairs.setup({
			check_ts = true, -- enables Treesitter integration
			fast_wrap = {},
		})
	end,
}
