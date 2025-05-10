MiniDeps.later(function()
  MiniDeps.add 'mfussenegger/nvim-lint'

  local lint = require 'lint'

  lint.linters_by_ft = {}

  vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave', 'TextChanged' }, {
    group = vim.api.nvim_create_augroup('crnvl96-try-lint', {}),
    callback = function() lint.try_lint() end,
  })
end)
