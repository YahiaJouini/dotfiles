require("config.lazy")

-- global default border type
vim.o.winborder = "rounded"

-- Disable any Shift+Arrow mappings in visual mode
vim.api.nvim_set_keymap("v", "<S-Down>", "j", { noremap = true })
vim.api.nvim_set_keymap("v", "<S-Up>", "k", { noremap = true })

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

-- Normal mode remaps
vim.api.nvim_set_keymap("n", "<C-f>", "<C-u>zz", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-b>", "<C-d>zz", { noremap = true })

-- Visual mode
vim.api.nvim_set_keymap("v", "<C-f>", "<C-u>zz", { noremap = true })
vim.api.nvim_set_keymap("v", "<C-b>", "<C-d>zz", { noremap = true })

--go to the start of the line
vim.keymap.set({ "n", "v", "o" }, "ù", "0", { desc = "Go to start of line (absolute)" })

vim.keymap.set("n", "<S-Down>", "<Nop>", { silent = true })
vim.keymap.set("n", "<S-Up>", "<Nop>", { silent = true })
