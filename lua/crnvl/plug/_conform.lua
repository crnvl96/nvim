vim.pack.add({
  'https://github.com/stevearc/conform.nvim',
})

local autoformat = true

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
  format_on_save = function()
    if not autoformat then return nil end
    return {}
  end,
  formatters_by_ft = {
    javascript = { 'oxfmt', lsp_format = 'prefer', timeout_ms = 1000 },
    typescript = { 'oxfmt', lsp_format = 'prefer', timeout_ms = 1000 },
    javascriptreact = { 'oxfmt', lsp_format = 'prefer', timeout_ms = 1000 },
    typescriptreact = { 'oxfmt', lsp_format = 'prefer', timeout_ms = 1000 },
    typst = { 'typstyle', lsp_format = 'prefer', timeout_ms = 1000 },
    go = { 'gofumpt', lsp_format = 'prefer', timeout_ms = 1000 },

    json = { 'oxfmt', lsp_format = 'prefer', name = 'oxfmt', timeout_ms = 1000 },
    jsonc = { 'oxfmt', lsp_format = 'prefer', name = 'oxfmt', timeout_ms = 1000 },
    jsonc5 = { 'oxfmt', lsp_format = 'prefer', name = 'oxfmt', timeout_ms = 1000 },

    css = { 'oxfmt' },
    yaml = { 'oxfmt' },
    markdown = { 'oxfmt', 'injected' },

    python = { 'ruff_organize_imports', 'ruff_fix', 'ruff_format' },
    lua = { 'stylua' },
    ruby = { 'rubocop' },

    ['_'] = { 'trim_whitespace', 'trim_newline' },
  },
})

local toggle_autoformat = function() autoformat = not autoformat end

vim.keymap.set(
  'n',
  '<Leader>uf',
  toggle_autoformat,
  { desc = 'Toggle autoformat' }
)
vim.keymap.set(
  'n',
  '<Leader>ur',
  '<Cmd>lua MiniMisc.put(MiniMisc.find_root())<CR>',
  { desc = 'Find current root' }
)
