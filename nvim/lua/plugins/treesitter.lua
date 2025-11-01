return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "typescript", "javascript", "cpp", "c" }, -- add other langs if needed
      sync_install=false,
      highlight = {
        enable = true,        -- enable Treesitter-based highlighting
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,        -- smart indentation
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}

