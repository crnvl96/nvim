local mini_path = vim.fn.stdpath 'data' .. '/site/pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd 'packadd mini.nvim | helptags ALL'
  vim.cmd 'echo "Installed `mini.nvim`" | redraw'
end

require('mini.deps').setup()

vim.cmd 'colorscheme ansi'

vim.lsp.enable {
  'basedpyright',
  'biome',
  'cssls',
  'eslint',
  'lua_ls',
  'ruff',
  'ts_ls',
}

require 'settings'
require 'lsp'
require 'plugins'
require 'quickfix'
