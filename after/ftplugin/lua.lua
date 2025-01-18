Utils.Group('crnvl96-handle-lua-autofmt', function(g)
  Utils.Req('stylua')

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
        formatters = { 'stylua' },
      })
    end,
  })
end)

Utils.Group('crnvl96-handle-lua-linters', function(g)
  Utils.Req('selene')

  Utils.Autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
    group = g,
    callback = function(e)
      if vim.fs.root(e.buf, { 'selene.toml' }) ~= nil then require('lint').try_lint({ 'selene' }) end
    end,
  })
end)
