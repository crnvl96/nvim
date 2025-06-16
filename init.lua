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

vim.cmd [[colorscheme ansi]]

local lsp_dir = vim.fn.stdpath 'config' .. '/lsp'
local excluded_servers = { 'basedpyright', 'pyrefly', 'rubocop' }

local lsp_servers = {}
for _, file in ipairs(vim.fn.glob(lsp_dir .. '/*.lua', true, true)) do
  local server_name = vim.fn.fnamemodify(file, ':t:r')
  if not vim.tbl_contains(excluded_servers, server_name) then
    table.insert(lsp_servers, server_name)
    local chunk = assert(loadfile(file))
    vim.lsp.config(server_name, chunk())
  end
end

vim.lsp.enable(lsp_servers)

require 'settings'
require 'lsp'
require 'plugins'
