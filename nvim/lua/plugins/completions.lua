-- this file only works for nvim 0.12+, check git history for older versions of nvim
return {
  { "github/copilot.vim" },
  { "ray-x/lsp_signature.nvim", event = "LspAttach" },
  { "luckasRanarison/tailwind-tools.nvim" },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local types = require("cmp.types")

      local kind_priority = {
        [types.lsp.CompletionItemKind.Variable]   = 1,
        [types.lsp.CompletionItemKind.Constant]   = 1,
        [types.lsp.CompletionItemKind.EnumMember] = 1,
        [types.lsp.CompletionItemKind.Enum]       = 1,
        [types.lsp.CompletionItemKind.Field]      = 2,
        [types.lsp.CompletionItemKind.Property]   = 2,
        [types.lsp.CompletionItemKind.Function]   = 3,
        [types.lsp.CompletionItemKind.Method]     = 3,
        [types.lsp.CompletionItemKind.Keyword]    = 100,
        [types.lsp.CompletionItemKind.Text]       = 100,
      }

      cmp.setup({
        performance = {
          debounce = 20,
          throttle = 10,
          fetching_timeout = 200,
        },

        -- Custom Sorting Engine
        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.exact,
            -- 1. Hard Source Priority: LSP always beats Buffer/Path
            function(entry1, entry2)
              local src1 = entry1.source.name
              local src2 = entry2.source.name
              if src1 == "nvim_lsp" and src2 ~= "nvim_lsp" then return true end
              if src2 == "nvim_lsp" and src1 ~= "nvim_lsp" then return false end
              return nil
            end,
            -- 2. Strict semantic hierarchy
            function(entry1, entry2)
              local kind1 = entry1:get_kind()
              local kind2 = entry2:get_kind()
              local priority1 = kind_priority[kind1] or 10
              local priority2 = kind_priority[kind2] or 10
              if priority1 ~= priority2 then
                return priority1 < priority2
              end
              return nil
            end,
            cmp.config.compare.locality,
            cmp.config.compare.recently_used,
            cmp.config.compare.score,
            cmp.config.compare.offset,
            cmp.config.compare.order,
          },
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources({
          { 
            name = "nvim_lsp", 
            priority = 1000,
            -- Hard Filter: Annihilate snippets at the source level
            entry_filter = function(entry)
              return entry:get_kind() ~= types.lsp.CompletionItemKind.Snippet
            end
          },
          { name = "path", priority = 500 },
          { name = "buffer", priority = 250, keyword_length = 3 },
        }),

        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            menu = {
              nvim_lsp = "[LSP]",
              buffer   = "[Buf]",
              path     = "[Path]",
            },
            before = function(entry, vim_item)
              vim_item.dup = 0 -- Safety net deduplication
              return require("tailwind-tools.cmp").lspkind_format(entry, vim_item)
            end,
          }),
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
    end,
  },
}
