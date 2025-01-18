vim.cmd('setlocal colorcolumn=89')

Utils.Group('crnvl96-handle-python-autofmt', function(g)
  Utils.Req('ruff')

  Utils.Autocmd('BufWritePre', {
    group = g,
    callback = function(e)
      if not vim.g.autoformat then return end

      require('conform').format({
        bufnr = e.buf or vim.api.nvim_get_current_buf(),
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = 'fallback',
        formatters = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
      })
    end,
  })
end)

Utils.Set('n', '<Leader>dpc', function() require('dap-python').test_class() end, { desc = 'Debug class' })
Utils.Set('n', '<Leader>dpt', function() require('dap-python').test_method() end, { desc = 'Debug method' })
