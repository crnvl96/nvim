Utils.Req({
  'selene',
  'tree-sitter',
  'ruff',
  'prettierd',
  'stylua',
  'node',
  'cargo',
  'zoxide',
  'lazydocker',
  'lazygit',
  'aider',
})

Utils.SetNodePath(os.getenv('HOME') .. '/.asdf/installs/nodejs/20.17.0')

local cargo = function(params)
  Later(function() Utils.Build(params, { 'cargo', 'build', '--release' }) end)
end

Add('nvim-lua/plenary.nvim')
Add({ source = 'nvim-treesitter/nvim-treesitter', hooks = { post_checkout = function() vim.cmd('TSUpdate') end } })

Add('folke/snacks.nvim')

Add('mfussenegger/nvim-lint')
Add('stevearc/conform.nvim')

Add('hat0uma/csvview.nvim')
Add('olimorris/codecompanion.nvim')

Add('theHamsta/nvim-dap-virtual-text')
Add('mfussenegger/nvim-dap-python')
Add('mfussenegger/nvim-dap')
Add('igorlfs/nvim-dap-view')

Add('tpope/vim-fugitive')
Add('andymass/vim-matchup')

Add('saghen/blink.compat')
Add({ source = 'Saghen/blink.cmp', hooks = { post_install = cargo, post_checkout = cargo } })
Add('neovim/nvim-lspconfig')
