return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      popup_border_style = "rounded",
      
      enable_git_status = true,
      enable_diagnostics = false,

      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
        },
        icon = {
          folder_empty = "󰜌",
          default = "*",
        },
      },
      
      filesystem = {
        open_on_setup = false,
        use_libuv_file_watcher = true,
        
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = true,
          hide_by_name = {
            ".DS_Store",
            "node_modules",
            "__pycache__",
          },
        },
        
        follow_current_file = {
          enabled = false,
        },
        group_empty_dirs = false,
        hijack_netrw_behavior = "open_default",
        
        window = {
          mappings = {
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
            ["H"] = "toggle_hidden",
            ["/"] = "fuzzy_finder",
            ["f"] = "filter_on_submit",
            ["<c-x>"] = "clear_filter",
          },
        },
      },
      
    window = {
        position = "left",
        width = 35,
        mapping_options = { noremap = true, nowait = true },
        mappings = {
          ["<space>"] = "none", 
          
          ["<tab>"] = "toggle_node", 
          ["l"] = "focus_preview", 
          
          ["<cr>"] = "open",
          ["<esc>"] = "cancel",
          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["C"] = "close_node",
          ["a"] = { "add", config = { show_path = "none" } },
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["q"] = "close_window",
          ["R"] = "refresh",
          ["?"] = "show_help",
        },
      },
    })

    vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { noremap = true, silent = true, desc = "Toggle Neo-tree" })
    vim.keymap.set("n", "<leader>fe", "<cmd>Neotree reveal<cr>", { noremap = true, silent = true, desc = "Reveal file in Neo-tree" })
    vim.keymap.set("n", "<leader>o", "<cmd>Neotree focus<cr>", { noremap = true, silent = true, desc = "Focus Neo-tree" })
  end,
}
