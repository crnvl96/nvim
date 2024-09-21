return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    delay = 200,
    preset = 'helix',
    icons = {
      group = ' +',
    },
  },
  config = function(_, opts)
    local wk = require('which-key')
    local wkx = require('which-key.extras')

    local function l(map) return '<leader>' .. map end

    local function extend_hl(name, def)
      local current_def = vim.api.nvim_get_hl(0, { name = name })
      local new_def = vim.tbl_extend('force', {}, current_def, def)

      vim.api.nvim_set_hl(0, name, new_def)
    end

    extend_hl('WhichKeySeparator', { bg = vim.g.palette.base00 })

    local maps = {
      { l('c'), group = 'Code' },
      { l('d'), group = 'Debug' },
      { l('f'), group = 'Files' },
      { l('x'), group = 'Quickfix' },
      { l('b'), group = 'Buffers', expand = function() return wkx.expand.buf() end },
    }

    wk.setup(opts)
    wk.add(maps)
  end,
  keys = function()
    local wk = require('which-key')
    local l = function(map) return '<leader>' .. map end

    return {
      { l('?'), function() wk.show({ global = false }) end, desc = 'keymaps' },
    }
  end,
}
