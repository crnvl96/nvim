return {
  'ibhagwan/fzf-lua',
  cmd = 'FzfLua',
  init = function()
    local M = require('config.functions')

    M.au('User', {
      pattern = 'VeryLazy',
      group = M.group('crnvl96-snacks', { clear = true }),
      callback = function() M.on_load('fzf-lua', require('fzf-lua').register_ui_select) end,
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
    { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'files' },
    { '<leader>fb', '<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>', desc = 'buffers' },
    { '<leader>fo', '<cmd>FzfLua oldfiles<cr>', desc = 'oldfiles' },
    { '<leader>fl', '<cmd>FzfLua blines<cr>', desc = 'blines' },
    { '<leader>fg', '<cmd>FzfLua live_grep_glob<cr>', desc = 'grep' },
    { '<leader>fr', '<cmd>FzfLua resume<cr>', desc = 'resume' },
    { '<leader>fh', '<cmd>FzfLua helptags<cr>', desc = 'help' },
    { '<leader>fk', '<cmd>FzfLua keymaps<cr>', desc = 'maps' },
  },
}
