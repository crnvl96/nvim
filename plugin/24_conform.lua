MiniDeps.add({ source = 'stevearc/conform.nvim' })

vim.g.autoformat = true
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require('conform').setup({
  notify_on_error = true,
  format_on_save = function()
    if not vim.g.autoformat then return nil end
    return {
      timeout_ms = 500,
      lsp_format = 'fallback',
    }
  end,
  formatters = {
    prettier = {
      require_cwd = true,
    },
  },
  formatters_by_ft = {
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
    javascript = { 'prettier', name = 'dprint' },
    javascriptreact = { 'prettier', name = 'dprint' },
    typescript = { 'prettier', name = 'dprint' },
    typescriptreact = { 'prettier', name = 'dprint' },
    json = { name = 'dprint' },
    jsonc = { name = 'dprint' },
    lua = { 'stylua' },
    markdown = { name = 'dprint' },
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format', name = 'dprint' },
    rust = { lsp_format = 'prefer' },
    go = { lsp_format = 'prefer' },
    toml = { name = 'dprint' },
    yaml = { lsp_format = 'prefer' },
  },
})

vim.api.nvim_create_user_command('Fmt', function()
  local buf = vim.api.nvim_get_current_buf()
  require('conform').format({ bufnr = buf })
end, { nargs = 0 })

vim.api.nvim_create_user_command('ToggleFmt', function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify(('%s formatting...'):format(vim.g.autoformat and 'Enabling' or 'Disabling'), vim.log.levels.INFO)
end, { nargs = 0 })
