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
