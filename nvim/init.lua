require("config.lazy")

-- global default border type
vim.o.winborder = "rounded"

--  customize highlight groups for floating windows
vim.cmd([[
  hi! NormalFloat guibg=NONE   " or some subtle background color
  hi! FloatBorder guifg=#5c6370 guibg=NONE
]])

-- yank saved to clipboard
vim.opt.clipboard = "unnamedplus"

vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set number")
vim.cmd("set relativenumber")
vim.cmd("set cursorline")
vim.cmd("set wrap")
vim.cmd("set scrolloff=8")
vim.cmd("set sidescrolloff=8")

--go to the start of the line
vim.keymap.set({ "n", "v", "o" }, "ù", "0", { desc = "Go to start of line (absolute)" })
--ctrl+f go down 10 lines
vim.keymap.set({ "n", "v", "o" }, "<C-f>", "15j", { noremap = true, silent = true, desc = "Move down 10 lines" })
--ctrl + b go up 10 lines
vim.keymap.set({ "n", "v", "o" }, "<C-b>", "15k", { noremap = true, silent = true, desc = "Move up 10 lines" })

vim.keymap.set("n", "<S-Down>", "<Nop>", { silent = true })
vim.keymap.set("n", "<S-Up>", "<Nop>", { silent = true })
