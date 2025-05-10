MiniDeps.later(function()
  MiniDeps.add 'neovim/nvim-lspconfig'
  MiniDeps.add 'tpope/vim-dadbod'
  MiniDeps.add 'kristijanhusak/vim-dadbod-ui'
  MiniDeps.add 'tpope/vim-fugitive'
  MiniDeps.add 'tpope/vim-rhubarb'
  MiniDeps.add 'tpope/vim-sleuth'
  MiniDeps.add 'mbbill/undotree'
  MiniDeps.add 'christoomey/vim-tmux-navigator'

  vim.keymap.set('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>')
  vim.keymap.set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>')
  vim.keymap.set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>')
  vim.keymap.set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>')
end)
