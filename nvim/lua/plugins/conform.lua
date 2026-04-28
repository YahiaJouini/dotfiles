vim.pack.add({
  'https://github.com/stevearc/conform.nvim',
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    c = { "clang-format" },
    cpp = { "clang-format" },

    -- Frontend: Try prettierd first for speed, fallback to prettier
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },

    -- Note: Go and Python are explicitly omitted here because
    -- gopls and ruff already format perfectly via the native LSP client.
  },

  -- Native, safe format-on-save
  format_on_save = {
    timeout_ms = 1000,
    lsp_format = "fallback",
  },
})
