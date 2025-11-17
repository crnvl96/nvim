local mini_path = vim.fn.stdpath 'data' .. '/site/pack/deps/start/mini.nvim'
---@diagnostic disable-next-line: undefined-field
if not vim.loop.fs_stat(mini_path) then
  vim.cmd 'echo "Installing `mini.nvim`" | redraw'
  local origin = 'https://github.com/nvim-mini/mini.nvim'
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', origin, mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd 'packadd mini.nvim | helptags ALL'
  vim.cmd 'echo "Installed `mini.nvim`" | redraw'
end

require('mini.deps').setup()

local node_bin = vim.env.HOME .. '/.local/share/mise/installs/node/24.11.0/bin'
vim.g.node_host_prog = node_bin .. '/node'
-- vim.env.PATH = node_bin .. vim.env.PATH

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-highlight-after-yank', {}),
  callback = function() vim.highlight.on_yank() end,
})
