-- Global Window Management
vim.o.winborder = "rounded"
vim.o.laststatus = 3 -- Global statusline (optimal for Tmux/Terminal workflows)
vim.o.cmdheight = 0  -- Invisible command line until needed

-- UI Mechanics
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.pumheight = 10

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Native Completion & Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"

-- Reliability & Performance
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 250 -- Faster diagnostic/UI refresh
vim.opt.timeoutlen = 300 -- Snappier mapped sequences
vim.opt.ttimeoutlen = 0  -- Instant mode switching

-- Message Handling (Anti-Flicker for cmdheight=0)
vim.opt.shortmess:append("Ic")  -- Hide startup and completion messages
vim.opt.shortmess:append("AsW") -- Avoid "Press Enter" prompts for saving/loading
vim.opt.shortmess:append("F")   -- Don't give file info when editing a file

-- Highlighting (using Lua API)
local set_hl = vim.api.nvim_set_hl
set_hl(0, "NormalFloat", { bg = "NONE" })
set_hl(0, "FloatBorder", { fg = "#5c6370", bg = "NONE" })

-- LSP Integration
vim.lsp.inlay_hint.enable(true)

-- Global Notification Filter (Pragmatic Suppression)
local notify = vim.notify
vim.notify = function(msg, level, opts)
  if msg:find("lspconfig") then return end
  notify(msg, level, opts)
end
