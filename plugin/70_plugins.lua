vim.pack.add({
  'https://github.com/christoomey/vim-tmux-navigator',
  'https://github.com/tpope/vim-sleuth',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/kevalin/mermaid.nvim',
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/stevearc/oil.nvim',
  'https://codeberg.org/andyg/leap.nvim',
  'https://github.com/rachartier/tiny-inline-diagnostic.nvim',
  'https://github.com/rachartier/tiny-code-action.nvim',
  'https://github.com/rachartier/tiny-cmdline.nvim',
})

require('mini.extra').setup()
require('mini.align').setup()
require('mini.splitjoin').setup()
require('mini.icons').setup()
require('mini.align').setup()
require('mini.misc').setup()
require('mini.splitjoin').setup()
require('mermaid').setup()
require('tiny-code-action').setup({ picker = 'buffer' })

vim.o.cmdheight = 0
require('vim._core.ui2').enable({ enable = true, msg = { targets = 'msg', msg = { height = 0.5, timeout = 3000 } } })

vim.diagnostic.config({ virtual_text = false })
require('tiny-inline-diagnostic').setup({ preset = 'classic' })

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

Config.set('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>', { noremap = true, desc = 'Go to left window' })
Config.set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>', { noremap = true, desc = 'Go to window below' })
Config.set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>', { noremap = true, desc = 'Go to window above' })
Config.set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>', { noremap = true, desc = 'Go to right window' })

Config.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
Config.set('n', 'S', '<Plug>(leap-from-window)')

Config.set('n', '<leader>ef', '<Cmd>Oil<CR>', { desc = 'File explorer' })

Config.set('n', '<leader>la', function() require('tiny-code-action').code_action() end, { desc = 'LSP code actions' })
