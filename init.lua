-- From `:h vim.loader.enable`:
--
-- Enables or disables the experimental Lua module loader:
--   - overrides `loadfile()`
--   - adds the Lua loader using the byte-compilation cache
--   - adds the libs loader
--   - removes the default Nvim loader
pcall(function() vim.loader.enable() end)

-- Path where lazy.nvim related files will be stored
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

-- Install lazy.nvim now if it it's already not present
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  -- Close the source repository
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

require('config.opts')
require('config.keymaps')
require('config.autocmds')

-- Loads Cfilter plugin
vim.cmd.packadd('cfilter')
vim.cmd('filetype plugin indent on') -- Enable all filetype plugins

-- Enable syntax highlighing if it wasn't already (as it is time consuming)
-- Don't use defer it because it affects start screen appearance
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

-- Here, we finally setup lazy.nvim
require('lazy').setup({
  defaults = {
    -- Lazy load plugins by default
    lazy = true,
    -- Use the last commit for each plugin
    -- This should be taken with a grain of salt, since plugins may contain breaking changes
    version = false,
  },
  spec = {
    -- Load our plugins that are located at `./lua/plugins`
    { import = 'plugins' },
  },
  change_detection = {
    -- Avoid annoying notifications about config changes
    enabled = false,
  },
  performance = {
    rtp = {
      -- Reset the runtime path to $VIMRUNTIME and your config directory
      reset = true,
      -- PERF:
      -- Disable some built-in nvim plugins, since we do not need them
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
