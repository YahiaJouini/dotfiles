-- this hook is for packages that are not standard lua plugins and require compilation

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind, path = ev.data.spec.name, ev.data.kind, ev.data.path
    -- Treesitter: Update parsers
    if name == 'nvim-treesitter' and (kind == 'update' or kind == 'install') then
      vim.cmd('TSUpdate')
    end
    -- FZF Native: Compile C binary in the plugin's path
    if name == 'telescope-fzf-native.nvim' and (kind == 'update' or kind == 'install') then
      vim.fn.system({ 'make', '-C', path })
    end
  end
})

-- files containing the configs of plugins
local configs = {
  "theme",
  "lualine",
  "indent-guide",
  "treesitter", -- highlighting engine
  "nvim-lsp",
  "completions",
  "telescope",
  "neotree",
  "harpoon",
  "autopairs",
  "conform",
  "illuminate", -- word highlighting
  "grug-far",
}

for _, module in ipairs(configs) do
  require("plugins." .. module)
end
