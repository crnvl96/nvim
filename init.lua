local tools = {
  'zathura',
  'tex-fmt',
  'tree-sitter',
  'rg',
  'rustc',
  'npm',
}

for _, cli in ipairs(tools) do
  if vim.fn.executable(cli) ~= 1 then
    local msg = cli .. ' is not installed in the system.'
    local lvl = vim.log.levels.ERROR

    vim.notify(msg, lvl)
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
