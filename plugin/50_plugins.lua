vim.pack.add({
  'https://github.com/christoomey/vim-tmux-navigator',
  'https://github.com/tpope/vim-sleuth',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/kevalin/mermaid.nvim',
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/stevearc/oil.nvim',
  'https://codeberg.org/andyg/leap.nvim',
})

require('mini.extra').setup()
require('mini.icons').setup()
require('mini.align').setup()
require('mini.misc').setup()
require('mini.splitjoin').setup()
require('mermaid').setup()

require('mini.ai').setup({
  search_method = 'cover',
  custom_textobjects = {
    f = require('mini.ai').gen_spec.treesitter({
      a = '@function.outer',
      i = '@function.inner',
    }),
    g = function()
      local from = { line = 1, col = 1 }
      local to = {
        line = vim.fn.line('$'),
        col = math.max(vim.fn.getline('$'):len(), 1),
      }
      return { from = from, to = to }
    end,
  },
})

require('oil').setup({
  columns = { 'icon' },
  watch_for_changes = false,
  view_options = { show_hidden = true },
})
