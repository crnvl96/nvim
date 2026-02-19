-- INSTALL: https://github.com/neovim/neovim/blob/master/INSTALL.md#pre-built-archives-2

_G.Config = {}

vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

require('mini.misc').setup()

MiniMisc.setup_auto_root()
MiniMisc.setup_restore_cursor()
MiniMisc.setup_termbg_sync()

Config.now = function(f) MiniMisc.safely('now', f) end
Config.later = function(f) MiniMisc.safely('later', f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later

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
