return {
  'ibhagwan/fzf-lua',
  cmd = 'FzfLua',
  opts = function()
    local config = require('fzf-lua.config')
    local actions = require('fzf-lua.actions')

    config.defaults.keymap.fzf['ctrl-q'] = 'select-all+accept'
    config.defaults.keymap.fzf['ctrl-u'] = 'half-page-up'
    config.defaults.keymap.fzf['ctrl-d'] = 'half-page-down'
    config.defaults.keymap.fzf['ctrl-z'] = 'unix-line-discard'
    config.defaults.keymap.fzf['ctrl-x'] = 'jump'
    config.defaults.keymap.fzf['ctrl-f'] = 'preview-page-down'
    config.defaults.keymap.fzf['ctrl-b'] = 'preview-page-up'
    config.defaults.keymap.builtin['<c-f>'] = 'preview-page-down'
    config.defaults.keymap.builtin['<c-b>'] = 'preview-page-up'
    config.defaults.actions.files['ctrl-t'] = require('trouble.sources.fzf').actions.open

    return {
      fzf_colors = true,
      fzf_opts = {
        ['--no-scrollbar'] = true,
      },
      defaults = {
        formatter = 'path.dirname_first',
      },
      winopts = {
        height = 0.85,
        width = 0.80,
        row = 0.50,
        col = 0.50,
        border = 'double',
        preview = {
          scrollchars = { '┃', '' },
        },
      },
      files = {
        cwd_prompt = false,
        actions = {
          ['alt-i'] = { actions.toggle_ignore },
          ['alt-h'] = { actions.toggle_hidden },
        },
      },
      grep = {
        actions = {
          ['alt-i'] = { actions.toggle_ignore },
          ['alt-h'] = { actions.toggle_hidden },
        },
      },
      lsp = {
        symbols = {
          symbol_hl = function(s) return 'TroubleIcon' .. s end,
          symbol_fmt = function(s) return s:lower() .. '\t' end,
          child_prefix = false,
        },
        code_actions = {
          previewer = vim.fn.executable('delta') == 1 and 'codeaction_native' or nil,
        },
      },
    }
  end,
  keys = {
    { '<c-j>', '<c-j>', ft = 'fzf', mode = 't', nowait = true },
    { '<c-k>', '<c-k>', ft = 'fzf', mode = 't', nowait = true },
    { '<Leader>ff', function() require('fzf-lua').files() end, desc = 'FZF files' },
    {
      '<Leader>fb',
      function()
        require('fzf-lua').buffers({
          sort_mru = true,
          sort_lastused = true,
        })
      end,
      desc = 'FZF buffers',
    },
    { '<Leader>fo', function() require('fzf-lua').oldfiles() end, desc = 'FZF oldfiles' },
    { '<Leader>fl', function() require('fzf-lua').blines() end, desc = 'FZF buffer lines' },
    { '<Leader>fg', function() require('fzf-lua').grep_project() end, desc = 'FZF grep' },
    { '<Leader>fr', function() require('fzf-lua').resume() end, desc = 'FZF resume' },
    { '<Leader>fh', function() require('fzf-lua').helptags() end, desc = 'FZF help' },
    { '<Leader>fk', function() require('fzf-lua').keymaps() end, desc = 'FZF keymaps' },
  },
}
