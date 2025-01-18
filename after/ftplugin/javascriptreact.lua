Utils.Group('crnvl96-handle-javascriptreact-autofmt', function(g)
  Utils.Req('prettierd')

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
        formatters = { 'prettierd' },
      })
    end,
  })
end)
