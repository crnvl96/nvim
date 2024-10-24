return {
  'ibhagwan/fzf-lua',
  cmd = 'FzfLua',
  config = function()
    local actions = require('fzf-lua.actions')
    local trouble = require('trouble.sources.fzf').actions

    require('fzf-lua').setup({
      fzf_colors = true,
      fzf_opts = { ['--no-scrollbar'] = true },
      winopts = {
        border = false,
        fullscreen = false,
        row = 0.50,
        col = 0.50,
        preview = {
          hidden = 'hidden',
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
          ['ctrl-l'] = trouble.open,
        },
      },
    })
  end,
  keys = {
    { '<c-j>', '<c-j>', ft = 'fzf', mode = 't', nowait = true },
    { '<c-k>', '<c-k>', ft = 'fzf', mode = 't', nowait = true },
    { '<leader>ff', function() require('fzf-lua').files() end, desc = 'files' },
    {
      '<leader>fb',
      function() require('fzf-lua').buffers({ sort_mru = true, sort_lastused = true }) end,
      desc = 'buffers',
    },
    { '<leader>fo', function() require('fzf-lua').oldfiles() end, desc = 'oldfiles' },
    { '<leader>fl', function() require('fzf-lua').blines() end, desc = 'blines' },
    { '<leader>fg', function() require('fzf-lua').grep_project() end, desc = 'grep' },
    { '<leader>fr', function() require('fzf-lua').resume() end, desc = 'resume' },
    { '<leader>fh', function() require('fzf-lua').helptags() end, desc = 'help' },
    { '<leader>fk', function() require('fzf-lua').keymaps() end, desc = 'maps' },
  },
}
