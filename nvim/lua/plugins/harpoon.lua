return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon Add" })
    vim.keymap.set("n", "<leader>l", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon Menu" })
    vim.keymap.set("n", "<leader>hr", function() harpoon:list():remove() end, { desc = "Harpoon Remove" })
    vim.keymap.set("n", "<leader>hc", function() harpoon:list():clear() end, { desc = "Harpoon Clear All" })

    vim.keymap.set("n", "&", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
    vim.keymap.set("n", "é", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
    vim.keymap.set("n", '"', function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
    vim.keymap.set("n", "'", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })
  end,
}
