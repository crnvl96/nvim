local U = require('utils')

local function evaluate_fmt(root_marker, target, fallback)
  local util = require('conform.util')
  return util.root_file(root_marker) and target or fallback
end

local function get_web_fmt()
  return evaluate_fmt(
    { 'biome.json', 'biome.jsonc' },
    { 'biome', 'biome-check', 'biome-organize-imports' },
    { 'prettier' }
  )
end

vim.g.autoformat = true
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require('conform').setup({
  notify_on_error = true,
  formatters = {
    injected = {
      ignore_errors = true,
    },
  },
  formatters_by_ft = {
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
    json = { 'jq' },
    jsonc = { 'jq' },
    lua = { 'stylua' },
    markdown = { 'injected' },
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
    rust = { 'rustfmt' },
    css = get_web_fmt,
    javascript = get_web_fmt,
    javascriptreact = get_web_fmt,
    typescript = get_web_fmt,
    typescriptreact = get_web_fmt,
    toml = function() return evaluate_fmt({ 'pyproject.toml' }, { 'pyproject-fmt' }, { 'taplo' }) end,
  },
  format_on_save = function() return vim.g.autoformat and { timeout_ms = 3000, lsp_format = 'fallback' } end,
})

vim.api.nvim_create_user_command('ToggleFormat', function()
  vim.g.autoformat = not vim.g.autoformat
  U.publish(string.format('%s formatting...', vim.g.autoformat and 'Enabling' or 'Disabling'))
end, { desc = 'Toggle conform.nvim auto-formatting', nargs = 0 })
