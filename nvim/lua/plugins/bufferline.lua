-- fix auto-session warning
vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
return {
   {
      "akinsho/bufferline.nvim",
      version = "*",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
         require("bufferline").setup{
            options = {
               numbers = "ordinal",          -- show buffer numbers
               close_command = "bdelete! %d", -- delete buffer without closing window
               right_mouse_command = "bdelete! %d",
               diagnostics = "nvim_lsp",    -- show LSP diagnostics
               offsets = {
                  {
                     filetype = "neo-tree",
                     text = "File Explorer",
                     highlight = "Directory",
                     text_align = "left"
                  }
               },
            },
         }

         -- Keymaps 
         vim.keymap.set('n', '<S-l>', ':BufferLineCycleNext<CR>', { silent = true })
         vim.keymap.set('n', '<S-k>', ':BufferLineCyclePrev<CR>', { silent = true })
         -- Map buffers 1-9 according to AZERTY top row
         vim.keymap.set('n', '&', ':BufferLineGoToBuffer 1<CR>', { silent = true })
         vim.keymap.set('n', 'é', ':BufferLineGoToBuffer 2<CR>', { silent = true })
         vim.keymap.set('n', '"', ':BufferLineGoToBuffer 3<CR>', { silent = true })
         vim.keymap.set('n', '\'', ':BufferLineGoToBuffer 4<CR>', { silent = true })
         vim.keymap.set('n', '(', ':BufferLineGoToBuffer 5<CR>', { silent = true })
         vim.keymap.set('n', '-', ':BufferLineGoToBuffer 6<CR>', { silent = true })
         vim.keymap.set('n', 'è', ':BufferLineGoToBuffer 7<CR>', { silent = true })
         vim.keymap.set('n', '_', ':BufferLineGoToBuffer 8<CR>', { silent = true })
         vim.keymap.set('n', 'ç', ':BufferLineGoToBuffer 9<CR>', { silent = true })
      end
   },
   -- Auto-session for saving/restoring sessions
   {
      "rmagatti/auto-session",
      lazy = false,
      keys = {
         -- use Telescope to search sessions 
         { "<leader>wr", "<cmd>AutoSession search<CR>", desc = "Session search" },
         { "<leader>ws", "<cmd>AutoSession save<CR>", desc = "Save session" },
         { "<leader>wa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
      },
      opts = {
         suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
         picker_opts = {
            load_on_setup = true,
         },
         -- seperate session for each git branch 
         auto_session_use_git_branch = true
      },

   }
}
