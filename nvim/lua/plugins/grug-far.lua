return {
  "MagicDuck/grug-far.nvim",
  opts = {},
  keys = {
    {
      "<leader>S",
      function()
        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e") or ""
        require("grug-far").open({
          prefills = {
            -- Grab word under cursor
            search = vim.fn.expand("<cword>"),
          }
        })
      end,
      mode = { "n", "v" },
      desc = "Project-wide Search & Replace (Grug-far)",
    },
  },
}

