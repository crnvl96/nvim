---@class LinterConfig
---@field cond? fun(buf: number): boolean
---@field linters string[]

---@type table<string, LinterConfig>
local linters_by_ft = {
  lua = {
    cond = function(buf) return vim.fs.root(buf, { 'selene.toml' }) ~= nil end,
    linters = { 'selene' },
  },
  python = { linters = { 'ruff' } },
  javascript = { linters = { 'eslint_d' } },
  typescript = { linters = { 'eslint_d' } },
  javascriptreact = { linters = { 'eslint_d' } },
  typescriptreact = { linters = { 'eslint_d' } },
  ['javascript.tsx'] = { linters = { 'eslint_d' } },
  ['typescript.tsx'] = { linters = { 'eslint_d' } },
}

vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('crnvl96-nvim-lint', { clear = true }),
  callback = function(event)
    local buf = event.buf
    local ft = vim.bo[buf].filetype
    local conf = linters_by_ft[ft]

    if conf and (not conf.cond or conf.cond(buf)) then require('lint').try_lint(conf.linters) end
  end,
})
