return {
  'echasnovski/mini.operators',
  event = 'VeryLazy',
  config = function()
    local remap = function(mode, lhs_from, lhs_to)
      local keymap = vim.fn.maparg(lhs_from, mode, false, true)
      local rhs = keymap.callback or keymap.rhs
      if rhs == nil then error('Could not remap from ' .. lhs_from .. ' to ' .. lhs_to) end
      vim.keymap.set(mode, lhs_to, rhs, { desc = keymap.desc })
    end

    remap('n', 'gx', '<Leader>cx')
    remap('x', 'gx', '<Leader>cx')

    require('mini.operators').setup()
  end,
}
