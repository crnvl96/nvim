-- vim.cmd([[let g:sneak#label = 1]])
-- vim.cmd([[let g:sneak#s_next = 0]])
-- vim.cmd([[let g:sneak#use_ic_scs = 1]])
-- vim.cmd([[let g:sneak#target_labels = ";sftunq/SFGHLTUNRMQZ?0"]])

vim.cmd([[let g:dirvish_mode = ':sort ,^.*[\/],']])

vim.pack.add({
  'https://github.com/christoomey/vim-tmux-navigator',
  'https://github.com/tpope/vim-sleuth',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/kevalin/mermaid.nvim',
  'https://github.com/justinmk/vim-dirvish',
  'https://github.com/rlane/pounce.nvim',
  'https://github.com/stevearc/conform.nvim',
})

require('pounce').setup()

require('mini.extra').setup()
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
