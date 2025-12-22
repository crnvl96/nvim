local mini_path = vim.fn.stdpath 'data' .. '/site/pack/deps/start/mini.nvim'
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
vim.env.PATH = node_bin .. ':' .. vim.env.PATH

vim.cmd.colorscheme 'miniautumn'

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-highlight-after-yank', {}),
  callback = function() vim.highlight.on_yank() end,
})

MiniDeps.later(function()
  local conf = vim.diagnostic.config
  conf {
    signs = { priority = 9999, severity = { min = 'HINT', max = 'ERROR' } },
    underline = { severity = { min = 'HINT', max = 'ERROR' } },
    virtual_text = { current_line = true, severity = { min = 'ERROR', max = 'ERROR' } },
    virtual_lines = false,
    update_in_insert = false,
  }
end)
