-- INSTALL: https://github.com/neovim/neovim/blob/master/INSTALL.md#pre-built-archives-2

_G.Config = {}

vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

vim.cmd.colorscheme('miniwinter')

local misc = require('mini.misc')

misc.setup()
misc.setup_auto_root()
misc.setup_restore_cursor()
misc.setup_termbg_sync()

Config.now = function(f) misc.safely('now', f) end
Config.later = function(f) misc.safely('later', f) end

Config.gr = vim.api.nvim_create_augroup('custom-config', {})

Config.on_packchanged = function(name, kinds, callback)
  vim.api.nvim_create_autocmd('PackChanged', {
    group = Config.gr,
    callback = function(e)
      if not (e.data.spec.name == name and vim.tbl_contains(kinds, e.data.kind)) then return end
      if not e.data.active then vim.cmd.packadd(name) end
      callback(e)
    end,
  })
end
