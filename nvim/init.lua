require("vim._core.ui2").enable({
  enable = true,
  msg = {
    target = "cmd", -- Routes all messages to the cmdline area
    pager = { height = 0.4 },
    msg = { height = 0.5, timeout = 3000 },
    dialog = { height = 0.5 },
    cmd = { height = 0.5 },
  },
})

local kitty_padding_group = vim.api.nvim_create_augroup("KittyPadding", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = kitty_padding_group,
  callback = function()
    os.execute("kitty @ set-spacing padding=0")
  end,
})

vim.api.nvim_create_autocmd("VimLeave", {
  group = kitty_padding_group,
  callback = function()
    os.execute("kitty @ set-spacing padding=10")
  end,
})

require("config.options")
require("config.keymaps")
require("config.pack")
