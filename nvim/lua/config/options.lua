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

-- Floating Window Highlights
vim.cmd([[
  hi! NormalFloat guibg=NONE
  hi! FloatBorder guifg=#5c6370 guibg=NONE
]])

-- Suppress lspconfig deprecation warnings

local notify = vim.notify
vim.notify = function(msg, ...)
	if msg:match("lspconfig") then
		return
	end
	notify(msg, ...)
end
