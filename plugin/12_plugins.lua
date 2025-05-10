MiniDeps.now(function()
  MiniDeps.add { name = 'mini.nvim' }
  MiniDeps.add 'nvim-lua/plenary.nvim'

  require('mini.icons').setup()
end)

require 'plugins.treesitter'
require 'plugins.mason'
require 'plugins.nosetup'
require 'plugins.dap'
require 'plugins.fzf-lua'
require 'plugins.mini-files'
require 'plugins.code-companion'
require 'plugins.conform'
require 'plugins.lint'
