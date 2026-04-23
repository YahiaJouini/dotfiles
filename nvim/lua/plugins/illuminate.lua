return {
  "RRethy/vim-illuminate",
  -- Load only when holding the cursor, not immediately on startup
  event = { "CursorHold", "CursorHoldI" },
  config = function()
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
        "lazy",
      },
    })
  end,
}
