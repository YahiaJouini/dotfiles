vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
})

-- Neovim 0.12: highlight and indent are now built-in via vim.treesitter
-- The nvim-treesitter plugin is now only used for parser management (TSInstall/TSUpdate)

-- Enable native treesitter highlighting for all supported filetypes
vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})

-- Install parsers on first launch (async, non-blocking)
vim.api.nvim_create_autocmd("User", {
  pattern = "PackChanged",
  once = true,
  callback = function()
    local parsers = {
      -- Frontend
      "typescript", "tsx", "javascript", "html", "css", "json",
      -- Backend/Systems
      "cpp", "c", "lua", "bash", "python", "go",
      -- Config
      "markdown", "markdown_inline", "yaml", "toml",
      -- Essential
      "vim", "vimdoc", "query",
    }
    vim.cmd("TSInstall " .. table.concat(parsers, " "))
  end,
})
