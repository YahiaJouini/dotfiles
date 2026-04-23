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
        ensure_installed = { "lua_ls", "clangd", "vtsls", "gopls", "basedpyright", "ruff" }
      })

      local servers = { "lua_ls", "clangd", "vtsls", "gopls", "basedpyright", "ruff" }

      for _, server in ipairs(servers) do
        local server_opts = {
          capabilities = capabilities,
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(".git", "pyproject.toml", "package.json", "go.mod")(fname)
              or vim.fn.getcwd()
          end,
        }

        -- Server-specific configuration overrides
        if server == "basedpyright" then
          server_opts.settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "strict",
                diagnosticSeverityOverrides = {
                  reportUnusedImport = "none",
                  reportUnusedVariable = "none",
                },
              }
            }
          }
        elseif server == "vtsls" then
          server_opts.settings = {
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              preferences = { importModuleSpecifierPreference = "non-relative" },
              inlayHints = {
                parameterNames = { enabled = "literals" },
                variableTypes = { enabled = true },
              },
            },
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completionConfig = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
          }
        end

        lspconfig[server].setup(server_opts)
      end

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
          
          vim.keymap.set("n", "gd", function()
            vim.lsp.buf.definition({
              on_list = function(options)
                if not options.items or #options.items == 0 then
                  vim.notify("No definition found", vim.log.levels.WARN)
                  return
                end
                local first_def = options.items[1]
                vim.cmd("edit " .. vim.fn.fnameescape(first_def.filename))
                vim.api.nvim_win_set_cursor(0, { first_def.lnum, first_def.col - 1 })
                vim.cmd("normal! zz") 
              end
            })
          end, vim.tbl_extend("force", opts, { desc = "Go to Definition (Bypass QF)" }))
          
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
          vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)

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
