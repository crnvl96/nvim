MiniDeps.add({
  source = 'stevearc/conform.nvim',
  depends = {
    { source = 'williamboman/mason.nvim' },
  },
})

local conform = require('conform')

local get_first_formatter = function(buffer, ...)
  for i = 1, select('#', ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, buffer).available then return formatter end
  end

  return select(1, ...)
end

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

conform.setup({
  notify_on_error = false,
  formatters_by_ft = {
    markdown = function(buf) return { get_first_formatter(buf, 'prettierd', 'prettier'), 'injected' } end,
    json = { 'prettierd', 'prettier', stop_after_first = true },
    jsonc = { 'prettierd', 'prettier', stop_after_first = true },
    json5 = { 'prettierd', 'prettier', stop_after_first = true },
    lua = { 'stylua' },
    typescript = { 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
  },
  formatters = {
    injected = {
      options = {
        ignore_errors = true,
      },
    },
  },
  format_on_save = {
    timeout_ms = 1000,
    lsp_format = 'fallback',
  },
})
