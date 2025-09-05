local U = require('utils')

vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities({
    general = {
      positionEncodings = {
        'utf-16',
      },
    },
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
      onTypeFormatting = {
        dynamicRegistration = false,
      },
    },
  }),
})

U.augroup('cnnvl96-lsp-enable-lsp-servers', function(g)
  U.aucmd({ 'BufReadPre', 'BufNewFile' }, {
    once = true,
    group = g,
    callback = function()
      local server_configs = vim
        .iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
        :map(function(file) return vim.fn.fnamemodify(file, ':t:r') end)
        :filter(function(server) return server ~= 'zuban' and server ~= 'pyrefly' and server ~= 'ty' end)
        :totable()
      require('mini.misc').put(server_configs)
      vim.lsp.enable(server_configs)
    end,
  })
end)

U.augroup('crnvl-lspattach', function(g)
  U.aucmd('LspAttach', {
    group = g,
    callback = function(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)
      if not client then return end

      -- if client:supports_method('textDocument/completion') then
      --   client.server_capabilities.completionProvider.triggerCharacters =
      --     vim.iter(string.gmatch('abcdefghijklmnopqrstuvwxyz.,:', '.')):totable()
      --   vim.lsp.completion.enable(true, client.id, e.buf, {
      --     autotrigger = true,
      --   })
      -- end

      U.lspmap(e.buf, 'E', vim.diagnostic.open_float, 'Show Error')
      U.lspmap(e.buf, 'K', vim.lsp.buf.hover, 'Hover')
      U.lspmap(e.buf, 'ga', vim.lsp.buf.code_action, 'Code Actions')
      U.lspmap(e.buf, 'gn', vim.lsp.buf.rename, 'Rename Symbol')
      U.lspmap(e.buf, 'gd', vim.lsp.buf.definition, 'Goto Definition')
      U.lspmap(e.buf, 'gD', vim.lsp.buf.declaration, 'Goto Declaration')
      U.lspmap(e.buf, 'gR', vim.lsp.buf.references, 'Goto References')
      U.lspmap(e.buf, 'gi', vim.lsp.buf.implementation, 'Goto Implementations')
      U.lspmap(e.buf, 'gy', vim.lsp.buf.type_definition, 'Goto T[y]pe Definitions')
      U.lspmap(e.buf, 'ge', vim.diagnostic.setqflist, 'Send Diagnostics to Qf list')
      U.lspmap(e.buf, 'gs', vim.lsp.buf.document_symbol, 'Show Document Symbols')
      U.lspmap(e.buf, 'gS', vim.lsp.buf.workspace_symbol, 'Show Workspace Symbols')
      U.lspmap(e.buf, '<C-k>', vim.lsp.buf.signature_help, 'Signature Help', 'i')
    end,
  })
end)
