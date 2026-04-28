vim.pack.add({
  'https://github.com/scottmckendry/cyberdream.nvim',
})

require("cyberdream").setup({
  transparent = false,
  italic_comments = true,
  terminal_colors = true,
})

vim.cmd.colorscheme("cyberdream")

-- Enforce Treesitter Highlighting over LSP Semantic Tokens
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Disable LSP semantic highlighting",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})
