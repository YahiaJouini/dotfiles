return
   {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "MunifTanjim/nui.nvim",
         "nvim-tree/nvim-web-devicons",
      },
      lazy = false,
      keys = {
         {
            "<C-e>",
            function()
               -- Toggle / focus logic
               local buf_ft = vim.bo.filetype
               if buf_ft == "neo-tree" then
                  -- If currently in the Neo-tree buffer, switch back
                  vim.cmd("wincmd p")
                  return
               end
               -- Otherwise, try to find an existing Neo-tree window
               for _, win in ipairs(vim.api.nvim_list_wins()) do
                  local b = vim.api.nvim_win_get_buf(win)
                  if vim.api.nvim_buf_get_option(b, "filetype") == "neo-tree" then
                     -- Focus that window
                     vim.api.nvim_set_current_win(win)
                     return
                  end
               end
               -- If no Neo-tree window is open, open (with reveal)
               require("neo-tree.command").execute({
                  toggle = true,
                  reveal = true,
                  position = "left",
                  source = "filesystem",
               })
            end,
            desc = "Toggle/focus Neo-tree",
         },
         {
            "<C-c>",
            function()
               -- always close Neo-tree
               require("neo-tree.command").execute({ action = "close" })
            end,
            desc = "Close Neo-tree",
         },
      },
      opts = {
         close_if_last_window = false,
         filesystem = {
            follow_current_file = { enabled = true },
            use_libuv_file_watcher = true,
         },
         window = {
            mappings = {
               -- you can add or override mappings inside Neo-tree buffer
               ["<cr>"] = "open",
               ["o"] = "open",
               ["S"] = "open_split",
            },
         },
      },
      config = function(_, opts)
         require("neo-tree").setup(opts)
      end,
   }
