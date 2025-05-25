MiniDeps.now(function()
  MiniDeps.add { name = 'mini.nvim' }
  MiniDeps.add 'nvim-lua/plenary.nvim'

  vim.keymap.set('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>')
  vim.keymap.set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>')
  vim.keymap.set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>')
  vim.keymap.set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>')

  require('mini.icons').setup()
  require('mini.icons').mock_nvim_web_devicons()

  MiniDeps.add 'neovim/nvim-lspconfig'
  MiniDeps.add 'tpope/vim-fugitive'
  MiniDeps.add 'tpope/vim-rhubarb'
  MiniDeps.add 'tpope/vim-sleuth'
  MiniDeps.add 'mbbill/undotree'
  MiniDeps.add 'christoomey/vim-tmux-navigator'
end)

require 'plugins.treesitter'
require 'plugins.mason'
require 'plugins.blink'
require 'plugins.dap'
require 'plugins.fzf-lua'
require 'plugins.mini-files'
require 'plugins.code-companion'
require 'plugins.conform'
require 'plugins.lint'
