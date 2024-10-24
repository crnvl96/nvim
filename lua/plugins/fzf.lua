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
        height = 0.85,
        width = 0.80,
        row = 0.50,
        col = 0.50,
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
	-- stylua: ignore
  keys = {
    { '<c-j>', '<c-j>', ft = 'fzf', mode = 't', nowait = true },
    { '<c-k>', '<c-k>', ft = 'fzf', mode = 't', nowait = true },
    { '<Leader>ff', function() require('fzf-lua').files() end, desc = 'Files' },
    { '<Leader>fb', function() require('fzf-lua').buffers({ sort_mru = true, sort_lastused = true, }) end, desc = 'Buffers' },
    { '<Leader>fo', function() require('fzf-lua').oldfiles() end, desc = 'Oldfiles' },
    { '<Leader>fl', function() require('fzf-lua').blines() end, desc = 'Blines' },
    { '<Leader>fg', function() require('fzf-lua').grep_project() end, desc = 'Grep' },
    { '<Leader>fr', function() require('fzf-lua').resume() end, desc = 'Resume' },
    { '<Leader>fh', function() require('fzf-lua').helptags() end, desc = 'Help' },
    { '<Leader>fk', function() require('fzf-lua').keymaps() end, desc = 'Maps' },
  },
}
