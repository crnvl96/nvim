return {
  'mfussenegger/nvim-lint',
  event = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
  config = function()
    local M = require('config.functions')
    local lint = require('lint')

    lint.linters_by_ft = {
      lua = { 'selene' },
      python = { 'ruff' },
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
      ['javascript.tsx'] = { 'eslint_d' },
      ['typescript.tsx'] = { 'eslint_d' },
    }

    M.au({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
      group = M.group('crnvl96-nvim-lint', { clear = true }),
      callback = function(e)
        local buf = e.buf
        local ft = vim.bo[buf].filetype
        local filename = vim.api.nvim_buf_get_name(buf)

        if ft == 'lua' then
          if vim.fs.find({ 'selene.toml' }, { path = filename, upward = true })[1] then lint.try_lint('selene') end
        else
          lint.try_lint()
        end
      end,
    })
  end,
}
