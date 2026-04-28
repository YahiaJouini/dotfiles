vim.pack.add({
  'https://github.com/lukas-reineke/indent-blankline.nvim',
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  once = true,
  callback = function()
    require("ibl").setup({
      indent = {
        char = "│",
        tab_char = "│",
      },
      -- Treesitter scope calculation on CursorMoved kills performance in TSX/Python.
      scope = { enabled = false },

      whitespace = { remove_blankline_trail = true },
    })
  end
})
