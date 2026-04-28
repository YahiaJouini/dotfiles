vim.pack.add({
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/neovim/nvim-lspconfig',
})

local function patch_inlay_hints_api()
  local orig_set_extmark = vim.api.nvim_buf_set_extmark
  local inlay_ns = vim.api.nvim_create_namespace("nvim.lsp.inlayhint")

  vim.api.nvim_buf_set_extmark = function(buffer, ns_id, line, col, opts)
    if ns_id == inlay_ns then
      local ok, id = pcall(orig_set_extmark, buffer, ns_id, line, col, opts)
      return ok and id or nil
    end
    return orig_set_extmark(buffer, ns_id, line, col, opts)
  end
end

local function setup_diagnostics()
  vim.diagnostic.config({
    virtual_text = { spacing = 4, prefix = "●" },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = { border = "rounded", source = "always", header = "", prefix = "" },
  })

  vim.api.nvim_create_autocmd("CursorHold", {
    desc = "Show diagnostic on hover",
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
end

local function setup_inlay_hints()
  local lsp_group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
  local inlay_hint_grp = vim.api.nvim_create_augroup("LspInlayHints", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_group,
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client and client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
      end
    end,
  })

  vim.api.nvim_create_autocmd("InsertEnter", {
    group = inlay_hint_grp,
    callback = function(args)
      if vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }) then
        vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
        vim.b[args.buf].inlay_hints_restored = true
      end
    end,
  })

  vim.api.nvim_create_autocmd("InsertLeave", {
    group = inlay_hint_grp,
    callback = function(args)
      if vim.b[args.buf].inlay_hints_restored then
        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        vim.b[args.buf].inlay_hints_restored = false
      end
    end,
  })
end

patch_inlay_hints_api()
setup_diagnostics()
setup_inlay_hints()

-- Inject Mason binaries into the Neovim instance path natively
vim.env.PATH = vim.fn.expand("~/.local/share/nvim/mason/bin:") .. vim.env.PATH

-- Nvim-Cmp Capability bridging
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.offsetEncoding = { "utf-16" }

-- Initialize Mason
require("mason").setup({ ui = { border = "rounded" } })
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "clangd", "vtsls", "gopls", "basedpyright", "ruff" }
})

-- Initialize Servers
local lspconfig = require("lspconfig")
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

  if server == "basedpyright" then
    server_opts.root_dir = function(fname)
      local util = require("lspconfig.util")
      return util.root_pattern("pyrightconfig.json")(fname)
          or util.root_pattern("pyproject.toml", ".git")(fname)
          or vim.fn.getcwd()
    end
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
          completionConfig = { enableServerSideFuzzyMatch = true },
        },
      },
    }
  end

  lspconfig[server].setup(server_opts)
end
