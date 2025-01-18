Add({
  source = 'nvim-treesitter/nvim-treesitter',
  hooks = {
    post_checkout = function() vim.cmd('TSUpdate') end,
  },
})

Add({
  source = 'Saghen/blink.cmp',
  hooks = {
    post_install = function(params)
      Later(function() Utils.Build(params, { 'cargo', 'build', '--release' }) end)
    end,
    post_checkout = function(params)
      Later(function() Utils.Build(params, { 'cargo', 'build', '--release' }) end)
    end,
  },
})

Add('nvim-treesitter/nvim-treesitter-textobjects')
Add('folke/snacks.nvim')
Add('nvim-lua/plenary.nvim')
Add('lambdalisue/vim-suda')
Add('tpope/vim-fugitive')
Add('tpope/vim-rhubarb')
Add('hat0uma/csvview.nvim')
Add('andymass/vim-matchup')
Add('mfussenegger/nvim-lint')
Add('stevearc/conform.nvim')
Add('Vigemus/iron.nvim')
Add('saghen/blink.compat')
Add('olimorris/codecompanion.nvim')
Add('theHamsta/nvim-dap-virtual-text')
Add('mfussenegger/nvim-dap-python')
Add('mfussenegger/nvim-dap')
Add('igorlfs/nvim-dap-view')
Add('neovim/nvim-lspconfig')
