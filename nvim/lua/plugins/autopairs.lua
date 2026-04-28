-- download and register the plugin
vim.pack.add({
  'https://github.com/windwp/nvim-autopairs',
})

-- lazy load the plugin when entering insert mode for the first time
vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    require("nvim-autopairs").setup({
      check_ts = true,
      fast_wrap = {},
    })
  end
})
