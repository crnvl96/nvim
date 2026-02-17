Config.gr = vim.api.nvim_create_augroup('custom-config', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = Config.gr,
  callback = function() vim.highlight.on_yank() end,
  desc = 'Highlight yanked text',
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = Config.gr,
  pattern = '[^l]*',
  command = 'cwindow',
  desc = 'Automatically open quickfix window after certain events',
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end
    local methods = vim.lsp.protocol.Methods

    local function sup(method) return client:supports_method(method, e.buf) end
    local function pumvisible() return tonumber(vim.fn.pumvisible()) ~= 0 end
    local function feed(key) vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 'n', true) end
    local function s(mode, lhs, rhs, opts)
      opts = opts or {}
      local ext_opts = vim.tbl_extend('error', { buffer = e.buf }, opts)
      vim.keymap.set(mode, lhs, rhs, ext_opts)
    end
    local function complete(map)
      if pumvisible() then
        feed(map)
      else
        if next(vim.lsp.get_clients({ bufnr = 0 })) then
          vim.lsp.completion.get()
        else
          if vim.bo.omnifunc == '' then
            feed('<C-x>' .. map)
          else
            feed('<C-x><C-o>')
          end
        end
      end
    end

    if sup(methods.textDocument_documentColor) then vim.lsp.document_color.enable(true, e.buf) end
    if sup(methods.textDocument_completion) then
      vim.lsp.completion.enable(true, client.id, e.buf, { autotrigger = true })
      local confirm = function() return pumvisible() and '<C-y>' or '<CR>' end
      s('i', '<CR>', confirm, { expr = true })
      for _, k in ipairs({ '<C-n>', '<Tab>' }) do
        local function complete_next() complete('<C-n>') end
        s('i', k, complete_next)
      end
      for _, k in ipairs({ '<C-p>', '<S-Tab>' }) do
        local function complete_prev() complete('<C-p>') end
        s('i', k, complete_prev)
      end
    end
    if sup(methods.textDocument_documentHighlight) then
      local hl = vim.api.nvim_create_augroup('crnvl96-cursor-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
        group = hl,
        buffer = e.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
        group = hl,
        buffer = e.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
    if sup(methods.textDocument_publishDiagnostics) then
      local function goto_nxt_err() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end
      s('n', ']e', goto_nxt_err, { desc = 'Goto next error' })
      local function goto_prev_err() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end
      s('n', '[e', goto_prev_err, { desc = 'Goto previous error' })
      local function open() vim.diagnostic.open_float() end
      s('n', 'E', open)
    end
    if sup(methods.textDocument_hover) then
      local hover = function() vim.lsp.buf.hover() end
      s('n', 'K', hover)
    end
    if sup(methods.textDocument_signatureHelp) then
      local sign_help = function() vim.lsp.buf.signature_help() end
      s('i', '<C-k>', sign_help)
    end
    if sup(methods.textDocument_declaration) then
      local f = function() MiniExtra.pickers.lsp({ scope = 'declaration' }) end
      s('n', '<Leader>lD', f, { desc = 'Lsp declaration' })
    end
    if sup(methods.textDocument_definition) then
      local f = function() MiniExtra.pickers.lsp({ scope = 'definition' }) end
      s('n', '<Leader>ld', f, { desc = 'Lsp definition' })
    end
    if sup(methods.textDocument_documentSymbol) then
      local f = function() MiniExtra.pickers.lsp({ scope = 'document_symbol' }) end
      s('n', '<Leader>ls', f, { desc = 'Lsp document symbols' })
      local F = function() MiniExtra.pickers.lsp({ scope = 'workspace_symbol_live' }) end
      s('n', '<Leader>lS', F, { desc = 'Lsp workspace symbols' })
    end
    if sup(methods.textDocument_implementation) then
      local f = function() MiniExtra.pickers.lsp({ scope = 'implementation' }) end
      s('n', '<Leader>li', f, { desc = 'Lsp implementation' })
    end
    if sup(methods.textDocument_references) then
      local f = function() MiniExtra.pickers.lsp({ scope = 'references' }) end
      s('n', '<Leader>lr', f, { desc = 'Lsp references' })
    end
    if sup(methods.textDocument_typeDefinition) then
      local f = function() MiniExtra.pickers.lsp({ scope = 'type_definition' }) end
      s('n', '<Leader>lt', f, { desc = 'Lsp type definition' })
    end
    if sup(methods.textDocument_codeAction) then
      local f = function() vim.lsp.buf.code_action() end
      s('n', '<Leader>la', f, { desc = 'Lsp code actions' })
    end
    if sup(methods.textDocument_rename) then
      local f = function() vim.lsp.buf.rename() end
      s('n', '<Leader>ln', f, { desc = 'Lsp rename symbol' })
    end
  end,
})
