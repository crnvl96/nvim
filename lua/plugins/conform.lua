local U = require('utils')

vim.g.autoformat = true
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require('conform').setup({
  notify_on_error = true,
  format_on_save = function()
    if not vim.g.autoformat then return nil end
    return { timeout_ms = 500, lsp_format = 'fallback' }
  end,
  formatters = {
    prettier = {
      require_cwd = true,
    },
    ['pyproject-fmt'] = {
      condition = function(_, ctx) return vim.fs.basename(ctx.filename) == 'pyproject.toml' end,
    },
  },
  formatters_by_ft = {
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
    markdown = { 'prettier', name = 'dprint' },
    json = { 'prettier', name = 'dprint' },
    jsonc = { 'prettier', name = 'dprint' },
    toml = { 'pyproject-fmt', name = 'dprint' },
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format', name = 'dprint' },
    javascript = { 'prettier', name = 'dprint' },
    typescript = { 'prettier', name = 'dprint' },
    javascriptreact = { 'prettier', name = 'dprint' },
    typescriptreact = { 'prettier', name = 'dprint' },
    yaml = { 'prettier' },
    go = { name = 'gopls', lsp_format = 'prefer' },
    rust = { name = 'rust_analyzer', lsp_format = 'prefer' },
    lua = { 'stylua' },
  },
})

vim.api.nvim_create_user_command('ToggleFormat', function()
  vim.g.autoformat = not vim.g.autoformat
  U.publish(('%s formatting...'):format(vim.g.autoformat and 'Enabling' or 'Disabling'))
end, { desc = 'Toggle conform.nvim auto-formatting', nargs = 0 })
