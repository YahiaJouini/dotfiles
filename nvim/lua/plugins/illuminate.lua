vim.pack.add({
  'https://github.com/RRethy/vim-illuminate',
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  once = true,
  callback = function()
    require("illuminate").configure({
      delay = 250, -- Throttled
      providers = {
        "lsp",
        "treesitter",
        "regex",
      },
      -- Short-circuit on anything remotely large
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
      filetypes_denylist = {
        "neo-tree",
        "NvimTree",
        "TelescopePrompt",
        "checkhealth",
        "help",
      },
    })
  end
})
