MiniDeps.later(function()
  MiniDeps.add 'stevearc/conform.nvim'

  vim.o.formatexpr = 'v:lua.require\'conform\'.formatexpr()'
  vim.g.conform = true

  require('conform').setup {
    notify_on_error = true,
    formatters = {
      injected = {
        ignore_errors = true,
      },
    },
    formatters_by_ft = {
      ['_'] = { 'trim_whitespace', 'trim_newlines' },
      lua = { 'stylua' },
      json = { 'prettier' },
      markdown = { 'prettier', 'injected' },
      python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },

      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      css = { 'prettier' },
      javascript = { 'prettier' },

      ruby = { 'rubocop' },
      eruby = { 'rubocop' },
    },
    format_on_save = function()
      return vim.g.conform and { timeout_ms = 3000, lsp_format = 'fallback' }
    end,
  }
end)
