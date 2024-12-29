for _, cli in ipairs({
  'zathura', -- pdf viewer
  'tex-fmt', -- LaTex formatter
  'tree-sitter', -- Treesitter cli
  'rg', -- MiniPick
  'rustc', -- blink.cmp (needs rustc nightly)
  'npm', -- markdown-preview
}) do
  if vim.fn.executable(cli) ~= 1 then
    vim.notify(cli .. ' is not installed in the system.', vim.log.levels.ERROR)
    return
  end
end

local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
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

require('mini.deps').setup()

_G.Config = {}
