vim.pack.add({
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/christoomey/vim-tmux-navigator',
  'https://github.com/tpope/vim-sleuth',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/kevalin/mermaid.nvim',
  'https://github.com/justinmk/vim-dirvish',
  'https://github.com/justinmk/vim-sneak',
  'https://github.com/stevearc/conform.nvim',
})

vim.cmd([[let g:sneak#label = 1]])
vim.cmd([[let g:sneak#s_next = 0]])
vim.cmd([[let g:sneak#use_ic_scs = 1]])
vim.cmd([[let g:sneak#target_labels = ";sftunq/SFGHLTUNRMQZ?0"]])
vim.cmd([[let g:dirvish_mode = ':sort ,^.*[\/],']])

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

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.g.autoformat = true

require('conform').setup({
  notify_on_error = false,
  notify_no_formatters = false,
  default_format_opts = {
    lsp_format = 'fallback',
    timeout_ms = 1000,
  },
  formatters = {
    stylua = { require_cwd = true },
    prettier = { require_cwd = false },
    oxfmt = { require_cwd = false },
  },
  formatters_by_ft = {
    markdown = { 'oxfmt', 'injected' },
    python = { 'ruff_organize_imports', 'ruff_fix', 'ruff_format' },
    lua = { 'stylua' },
    json = { 'oxfmt', lsp_format = 'prefer', name = 'oxfmt' },
    jsonc = { 'oxfmt', lsp_format = 'prefer', name = 'oxfmt' },
    jsonc5 = { 'oxfmt', lsp_format = 'prefer', name = 'oxfmt' },
    ['_'] = { 'trim_whitespace', 'trim_newline' },
  },
  format_on_save = function()
    if not vim.g.autoformat then return nil end
    return {}
  end,
})
