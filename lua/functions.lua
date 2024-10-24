_G.set = vim.keymap.set
_G.au = vim.api.nvim_create_autocmd
_G.group = vim.api.nvim_create_augroup
_G.user = vim.api.nvim_create_user_command
_G.hl = vim.api.nvim_set_hl
_G.bigfile = math.floor(0.5 * 1024 * 1024) -- 0.5 mb

function _G.on_attach(client, buf)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  local function has(method)
    if not method then return true end

    if type(method) == 'table' then
      for _, m in ipairs(method) do
        if has(m) then return true end
      end
      return false
    end

    if client.supports_method(method) then return true end

    return false
  end

  local function lspset(mode, lhs, rhs, opts, method)
    opts = opts or {}
    opts.buffer = buf

    if has(method) then set(mode, lhs, rhs, opts) end
  end

	-- stylua: ignore start
  lspset('n', '<leader>ld', function() require('fzf-lua').lsp_definitions() end, { desc = 'Definition' }, 'textDocument/definition')
  lspset('n', '<leader>lr', function() require('fzf-lua').lsp_references() end, { desc = 'References', nowait = true })
  lspset('n', '<leader>lI', function() require('fzf-lua').lsp_implementations() end, { desc = 'Implementation' })
  lspset('n', '<leader>ly', function() require('fzf-lua').lsp_typedefs() end, { desc = 'Type definition' })
  lspset('n', '<leader>lD', function() require('fzf-lua').lsp_declarations() end, { desc = 'Declaration' })
  lspset('n', '<leader>ls', function() require('fzf-lua').lsp_document_symbols() end, { desc = 'Document symbols' })
  lspset('n', '<leader>lS', function() require('fzf-lua').lsp_live_workspace_symbols() end, { desc = 'Workspace symbols' })
  lspset('n', '<leader>li', function() require('fzf-lua').lsp_incoming_calls() end, { desc = 'Incoming calls' })
  lspset('n', '<leader>lo', function() require('fzf-lua').lsp_outgoing_calls() end, { desc = 'Outgoinc calls' })
  lspset('n', '<leader>lx', function() require('fzf-lua').lsp_document_diagnostics() end, { desc = 'Document diagnostics' })
  lspset('n', '<leader>lX', function() require('fzf-lua').lsp_workspace_diagnostics() end, { desc = 'Workspace diagnostics' })
  lspset('n', 'K', function() vim.lsp.buf.hover({ border = 'double' }) end, { desc = 'Hover' })
  lspset('n', '<leader>lK', function() vim.lsp.buf.signature_help({ border = 'double' }) end, { desc = 'Signature help' }, 'textDocument/signatureHelp')
  lspset('i', '<C-k>', function() vim.lsp.buf.signature_help({ border = 'double' }) end, { desc = 'Signature help' }, 'textDocument/signatureHelp')
  lspset({ 'n', 'v' }, '<Leader>ca', function() require('fzf-lua').lsp_code_actions() end, { desc = 'Code actions' }, 'textDocument/codeAction')
  lspset({ 'n', 'v' }, '<Leader>cc', function() vim.lsp.codelens.run() end, { desc = 'Code lens' }, 'textDocument/codeLens')
  lspset('n', '<Leader>cC', function() vim.lsp.codelens.refresh() end, { desc = 'Display code lens' }, 'textDocument/codeLens')
  lspset('n', '<Leader>cr', function() vim.lsp.buf.rename() end, { desc = 'Rename' })
  lspset('n', 'L', function() vim.diagnostic.open_float() end, { desc = 'Open float' })

  if has('textDocument/foldingRange') then
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
  end
end
