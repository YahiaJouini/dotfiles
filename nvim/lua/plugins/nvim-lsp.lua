-- this file only works for nvim 0.12+, check git history for older versions of nvim
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspInfo", "Mason", "MasonInstall" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      vim.env.PATH = vim.fn.expand("~/.local/share/nvim/mason/bin:") .. vim.env.PATH

      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      -- Native 0.12 fix for Fedora/clangd encoding
      capabilities.offsetEncoding = { "utf-16" }

      require("mason").setup({ ui = { border = "rounded" } })
      require("mason-lspconfig").setup({
        -- ts_ls is back in the automated pipeline
        ensure_installed = { "lua_ls", "clangd", "ts_ls", "gopls", "basedpyright", "ruff" }
      })

      local servers = { "lua_ls", "clangd", "ts_ls", "gopls", "basedpyright", "ruff" }

      for _, server in ipairs(servers) do
        lspconfig[server].setup({
          capabilities = capabilities,
          -- Standard root detection
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(".git", "pyproject.toml", "package.json", "go.mod")(fname)
              or vim.fn.getcwd()
          end,
          
          -- Silence Pyright's linter so Ruff can do its job without duplicating errors
          settings = (server == "basedpyright") and {
            basedpyright = {
              analysis = {
                typeCheckingMode = "strict",
                diagnosticSeverityOverrides = {
                  reportUnusedImport = "none",
                  reportUnusedVariable = "none",
                },
              }
            }
          } or nil
        })
      end

      -- Modern 0.12 Diagnostic UI
      vim.diagnostic.config({
        virtual_text = { spacing = 4, prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- Hover Popup on CursorHold
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "always",
            prefix = " ",
            scope = "cursor",
          })
        end,
      })

      -- Buffer-local keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
          vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)

          -- Wayland/Kitty clipboard logic for diagnostics
          vim.keymap.set("n", "<leader>ce", function()
            local line = vim.api.nvim_win_get_cursor(0)[1] - 1
            local diags = vim.diagnostic.get(0, { lnum = line })
            
            if #diags == 0 then
              vim.notify("No diagnostic found on this line", vim.log.levels.WARN)
              return
            end
            
            local msg = diags[1].message
            vim.fn.setreg("+", msg)
            vim.fn.setreg('"', msg)
            vim.notify("Copied: " .. msg, vim.log.levels.INFO)
          end, vim.tbl_extend("force", opts, { desc = "Copy Error to Clipboard" }))
        end,
      })
    end,
  }
}
