return {
  'ibhagwan/fzf-lua',
  cmd = 'FzfLua',
  init = function()
    Au('User', {
      pattern = 'VeryLazy',
      group = Group('fzf-register-ui-select'),
      callback = function() OnLoad('fzf-lua', require('fzf-lua').register_ui_select) end,
    })
  end,
  opts = function()
    local actions = require('fzf-lua.actions')

    return {
      fzf_colors = true,
      fzf_opts = {
        ['--no-scrollbar'] = true,
        ['--cycle'] = true,
      },
      winopts = {
        row = 0.50,
        border = 'double',
        preview = {
          hidden = 'hidden',
          vertical = 'down:50%',
          horizontal = 'right:50%',
          layout = 'flex',
          flip_columns = 120,
        },
      },
      defaults = {
        keymap = {
          fzf = {
            ['alt-s'] = 'jump',
          },
        },
      },
      actions = {
        files = {
          true,
          ['ctrl-q'] = actions.file_sel_to_qf,
        },
      },
    }
  end,
  keys = {
    { '<c-j>', '<c-j>', ft = 'fzf', mode = 't', nowait = true },
    { '<c-k>', '<c-k>', ft = 'fzf', mode = 't', nowait = true },
    { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'fzf: files' },
    { '<leader>fb', '<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>', desc = 'fzf: buffers' },
    { '<leader>fo', '<cmd>FzfLua oldfiles<cr>', desc = 'fzf: oldfiles' },
    { '<leader>fl', '<cmd>FzfLua blines<cr>', desc = 'fzf: blines' },
    { '<leader>fg', '<cmd>FzfLua live_grep_glob<cr>', desc = 'fzf: grep' },
    { '<leader>fr', '<cmd>FzfLua resume<cr>', desc = 'fzf: resume' },
    { '<leader>fh', '<cmd>FzfLua helptags<cr>', desc = 'fzf: help' },
    { '<leader>fk', '<cmd>FzfLua keymaps<cr>', desc = 'fzf: maps' },
  },
}
