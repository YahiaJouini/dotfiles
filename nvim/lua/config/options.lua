-- UI Settings
vim.o.winborder = "rounded"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Tab/Indent Settings
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Clipboard
vim.opt.clipboard = "unnamedplus"


vim.opt.swapfile = false
vim.opt.backup = false -- we use git instead
vim.opt.writebackup = false


-- Search
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true  -- Override ignorecase if search contains capitals
vim.opt.updatetime = 250  -- Faster completion and diagnostic display (default 4000ms)
vim.opt.timeoutlen = 300  -- Time to wait for a mapped sequence to complete
vim.opt.ttimeoutlen = 0   -- Eliminate delay when switching modes


--UI
vim.opt.termguicolors = true -- True color support
vim.opt.signcolumn = "yes"   -- Always show sign column to prevent "jumping" text
vim.opt.laststatus = 3       -- Global statusline (looks cleaner with Tmux)
vim.opt.pumheight = 10       -- Limit completion menu height

vim.opt.shortmess:append("Ic") -- Give messages more room to breath or stay hidden
vim.opt.shortmess:append("AsW") -- This prevents the "hit-enter" prompt 
vim.opt.cmdheight = 0 -- Hide the command line until needed
vim.opt.updatetime = 250 --shorter updatetime for faster UI refreshes


-- Floating Window Highlights
vim.cmd([[
  hi! NormalFloat guibg=NONE
  hi! FloatBorder guifg=#5c6370 guibg=NONE
]])


-- enable inlay hits (shows param names without hovering)
vim.lsp.inlay_hint.enable(true)


-- Suppress lspconfig deprecation warnings
local notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match("lspconfig") then
    return
  end
  notify(msg, ...)
end
