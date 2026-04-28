vim.pack.add({
  'https://github.com/MagicDuck/grug-far.nvim',
})

require("grug-far").setup({})

vim.keymap.set({ "n", "v" }, "<leader>S", function()
  require("grug-far").open({
    prefills = {
      -- Grab word under cursor
      search = vim.fn.expand("<cword>"),
    }
  })
end, { desc = "Project-wide Search & Replace (Grug-far)" })
