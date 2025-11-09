-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- NAVIGATION
-- ============================================================================

-- Scroll and center
-- Normal mode remaps
vim.api.nvim_set_keymap("n", "<C-f>", "<C-u>zz", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-b>", "<C-d>zz", { noremap = true })
-- Visual mode
vim.api.nvim_set_keymap("v", "<C-f>", "<C-u>zz", { noremap = true })
vim.api.nvim_set_keymap("v", "<C-b>", "<C-d>zz", { noremap = true })

-- Go to start of line
vim.keymap.set({ "n", "v", "o" }, "ù", "0", { desc = "Go to start of line" })

-- Disable Shift+Arrow in normal mode
vim.keymap.set("n", "<S-Down>", "<Nop>", { silent = true })
vim.keymap.set("n", "<S-Up>", "<Nop>", { silent = true })

-- Fix Shift+Arrow in visual mode
vim.keymap.set("v", "<S-Down>", "j", { noremap = true })
vim.keymap.set("v", "<S-Up>", "k", { noremap = true })
