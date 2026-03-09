require('mini.completion').setup({
  lsp_completion = {
    source_func = 'omnifunc',
    auto_setup = false,
    process_items = function(items, base)
      local default = MiniCompletion.default_process_items
      return default(items, base, { kind_priority = { Text = -1, Snippet = -1 } })
    end,
  },
})

vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })

vim.api.nvim_create_autocmd('LspAttach', {
  group = Config.gr,
  callback = function(e)
    vim.bo[e.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
  end,
})
