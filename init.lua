_G.Config = {}

vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

require('mini.misc').setup()

MiniMisc.setup_auto_root()
MiniMisc.setup_restore_cursor()
MiniMisc.setup_termbg_sync()

Config.gr = vim.api.nvim_create_augroup('custom-config', {})

Config.set = vim.keymap.set
Config.set_keymap = function(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { desc = desc }) end
Config.now = function(f) MiniMisc.safely('now', f) end
Config.later = function(f) MiniMisc.safely('later', f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
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

Config.now(function()
  vim.pack.add({ 'https://github.com/folke/tokyonight.nvim' })

  require('tokyonight').setup()
  require('vim._core.ui2').enable({
    enable = true,
    msg = {
      target = 'msg',
      timeout = 4000,
    },
  })

  vim.cmd.colorscheme('tokyonight-night')
  -- vim.cmd.colorscheme('tokyonight-storm')
  -- vim.cmd.colorscheme('tokyonight-day')
  -- vim.cmd.colorscheme('tokyonight-moon')
end)
