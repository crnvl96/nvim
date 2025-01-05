vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('crnvl96-on-lsp-attach', { clear = true }),
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end
    Config.on_attach(client, e.buf)
  end,
})

---@class LinterConfig
---@field cond? fun(buf: number): boolean
---@field linters string[]

--- Returns a list of linters grouped by the filetype they should run on
---@return table<string, LinterConfig>
local function linters_by_ft()
  return {
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
end

local linters = linters_by_ft()

vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('crnvl96-nvim-lint', { clear = true }),
  callback = function(e)
    local buf = e.buf
    local ft = vim.bo[buf].filetype
    local conf = linters[ft]

    if conf and (not conf.cond or conf.cond(buf)) then require('lint').try_lint(conf.linters) end
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(e)
    require('conform').format({
      bufnr = e.buf,
      timeout_ms = 3000,
      async = false,
      quiet = false,
      lsp_format = 'fallback',
    })
  end,
})
