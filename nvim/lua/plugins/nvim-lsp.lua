return {
   "neovim/nvim-lspconfig",
   config = function()
      vim.lsp.enable({
         "lua_ls",   -- Lua
         "clangd",   -- C/C++
         "typescript-language-server"
      })
      vim.diagnostic.config({
         virtual_text = true,        -- show errors inline
         signs = true,               -- gutter signs
         underline = true,           -- underline problematic text
         update_in_insert = false,   -- don't update while typing
      })
      vim.keymap.set("n",'K',vim.lsp.buf.hover,{})
      vim.keymap.set("n","gd",vim.lsp.buf.definition,{})
      vim.keymap.set("n","<leader>ca", vim.lsp.buf.code_action,{})

   end,
}
