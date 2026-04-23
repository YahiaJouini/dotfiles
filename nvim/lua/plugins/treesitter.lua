-- this file only works for nvim 0.12+, check git history for older versions of nvim

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        -- Frontend
        "typescript", "tsx", "javascript", "html", "css", "json",
        -- Backend/Systems
        "cpp", "c", "lua", "bash", "python", "go",
        -- Config
        "markdown", "markdown_inline", "yaml", "toml",
        -- Essential
        "vim", "vimdoc", "query",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true, disable = { "python" } },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },
}