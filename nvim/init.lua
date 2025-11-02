require("config.lazy")

vim.cmd.colorscheme "catppuccin"
vim.cmd("set expandtab")
vim.cmd("set tabstop=3")
vim.cmd("set softtabstop=3")
vim.cmd("set shiftwidth=3")
-- yank saved to clipboard
vim.opt.clipboard = "unnamedplus"


--go to the start of the line
vim.keymap.set({ 'n', 'v', 'o'}, 'ù', '0', { desc = 'Go to start of line (absolute)' })
--ctrl+f go down 10 lines
vim.keymap.set({'n','v','o'}, '<C-f>', '10j', { noremap = true, silent = true, desc = 'Move down 10 lines' })
--ctrl + b go up 10 lines
vim.keymap.set({'n','v','o'}, '<C-b>', '10k', { noremap = true, silent = true, desc = 'Move up 10 lines' })
-- stop ctrl+z from quitting nvim
vim.keymap.set({'n','v','o'}, '<C-z>', '<nop>')
