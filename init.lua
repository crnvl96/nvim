local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({
  path = {
    package = path_package,
  },
})

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function() vim.cmd.colorscheme('base16_gruvbox') end)

now(function() require('config.opts') end)
now(function() require('config.keymaps') end)
now(function() require('mini.extra').setup() end)
now(function() require('plugins.mini-basics') end)
now(function() require('plugins.mini-icons') end)

later(function() add('tpope/vim-fugitive') end)
later(function() require('plugins.mini-completion') end)
later(function() require('plugins.treesitter') end)
later(function() require('plugins.lsp') end)
later(function() require('plugins.conform') end)
later(function() require('plugins.mini-pick') end)
later(function() require('plugins.mini-files') end)
