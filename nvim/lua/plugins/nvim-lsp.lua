return {
   {
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
   },
   -- Signature hints
   {
      "ray-x/lsp_signature.nvim",
      event = "InsertEnter",
      config = function()
         require("lsp_signature").setup({
            bind = true,                 -- hook into LSP
            floating_window = true,      -- show hints in floating window
            hint_enable = true,
            hint_prefix = " ",         -- icon
            hi_parameter = "Search",     -- highlight current parameter
            max_height = 8,
            max_width = 80,
            always_trigger = true,        -- always show hints while typing
            timer_interval = 100,         -- update frequency (ms)
            handler_opts = { border = "rounded" },
         })
      end,
   },

   -- nvim-cmp for autocompletion
   {
      "hrsh7th/nvim-cmp",
      dependencies = {
         "hrsh7th/cmp-nvim-lsp",
         "hrsh7th/cmp-buffer",
         "hrsh7th/cmp-path",
         "saadparwaiz1/cmp_luasnip",
         "L3MON4D3/LuaSnip",
         "rafamadriz/friendly-snippets",
      },
      config = function()
         local cmp = require("cmp")
         local luasnip = require("luasnip")

         cmp.setup({
            snippet = {
               expand = function(args)
                  luasnip.lsp_expand(args.body)
               end,
            },
            mapping = {
               ["<C-Space>"] = cmp.mapping.complete(),       -- trigger completion
               ["<CR>"] = cmp.mapping.confirm({ select = true }), -- confirm selection
               ["<Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     cmp.select_next_item()
                  elseif luasnip.expand_or_jumpable() then
                     luasnip.expand_or_jump()
                  else
                     fallback()
                  end
               end, { "i", "s" }),
               ["<S-Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     cmp.select_prev_item()
                  elseif luasnip.jumpable(-1) then
                     luasnip.jump(-1)
                  else
                     fallback()
                  end
               end, { "i", "s" }),
            },
            sources = cmp.config.sources({
               { name = "nvim_lsp" },
               { name = "luasnip" },
               { name = "buffer" },
               { name = "path" },
            }),
            experimental = { ghost_text = true }, -- VSCode-style inline preview
         })

         -- use cmp for cmdline completion
         cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })
         cmp.setup.cmdline(":", { sources = { { name = "path" }, { name = "cmdline" } } })
      end,
   },
}
