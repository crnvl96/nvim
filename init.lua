pcall(function() vim.loader.enable() end)

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

for _, name in ipairs({ 'zathura', 'tex-fmt', 'tree-sitter' }) do
  if vim.fn.executable(name) ~= 1 then vim.notify(name .. ' is not installed in the system.', vim.log.levels.ERROR) end
end

require('config.opts')
require('config.keymaps')
require('config.autocmds')

require('lazy').setup({
  defaults = {
    lazy = true,
    version = false,
  },
  spec = {
    { import = 'plugins' },
  },
  change_detection = {
    enabled = false,
  },
  performance = {
    rtp = {
      reset = true,
      disabled_plugins = {
        'gzip',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
