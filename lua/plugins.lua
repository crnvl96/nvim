MiniDeps.now(function()
  MiniDeps.add { name = 'mini.nvim' }
  MiniDeps.add 'nvim-lua/plenary.nvim'

  require('mini.icons').setup()
end)

require 'plugins.ash'
require 'plugins.treesitter'
require 'plugins.mason'
require 'plugins.nosetup'
require 'plugins.blink'
require 'plugins.dap'
require 'plugins.fzf-lua'
require 'plugins.mini-files'
require 'plugins.render-markdown'
require 'plugins.code-companion'
require 'plugins.conform'
require 'plugins.lint'
