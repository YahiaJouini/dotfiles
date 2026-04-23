return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "BufReadPost",
  config = function()
    require("ibl").setup({
      indent = {
        char = "│",
        tab_char = "│",
      },
      -- Treesitter scope calculation on CursorMoved kills performance in TSX/Python.
      scope = { enabled = false },

      whitespace = { remove_blankline_trail = true },
    })
  end,
}
