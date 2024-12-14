return {
  'mfussenegger/nvim-lint',
  event = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
  config = function()
    local lint = require('lint')

    ---@class LinterConfig
    ---@field cond? fun(buf: number): boolean
    ---@field linters string[]

    ---@type table<string, LinterConfig>
    local linters_by_ft = {
      lua = {
        cond = function(buf)
          local ctx = { buf = buf }
          return MatchAtRoot(ctx, { 'selene.toml' }) and true or false
        end,
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

    Au({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
      group = Group('nvim-lint'),
      callback = function(event)
        local buf = event.buf
        local ft = vim.bo[buf].filetype
        local conf = linters_by_ft[ft]

        if conf and (not conf.cond or conf.cond(buf)) then lint.try_lint(conf.linters) end
      end,
    })
  end,
}
