_G.Config = {}

vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

require('mini.misc').setup()
require('mini.extra').setup()

MiniMisc.setup_auto_root()
MiniMisc.setup_restore_cursor()
MiniMisc.setup_termbg_sync()

Config.gr = vim.api.nvim_create_augroup('custom-config', {})

function Config.now(f)
  MiniMisc.safely('now', f)
end

function Config.later(f)
  MiniMisc.safely('later', f)
end

Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later

function Config.on_packchanged(name, kinds, callback)
  vim.api.nvim_create_autocmd('PackChanged', {
    group = Config.gr,
    callback = function(e)
      local is_target = e.data.spec.name == name
        and vim.tbl_contains(kinds, e.data.kind)

      if not is_target then
        return
      end

      if not e.data.active then
        vim.cmd.packadd(name)
      end

      callback(e)
    end,
  })
end

Config.now(function()
  vim.pack.add({ 'https://github.com/folke/tokyonight.nvim' })

  require('tokyonight').setup()

  local colorschemes = {
    tokyonight = {
      'tokyonight-night',
      'tokyonight-storm',
      'tokyonight-day',
      'tokyonight-moon',
    },
  }

  vim.cmd.colorscheme(colorschemes.tokyonight[1])
end)
