local function on_attach(client, buf)
  if require('lazy.core.config').spec.plugins['fzf-lua'] == nil then
    vim.notify('Please install fzf-lua', vim.log.levels.ERROR)
    return
  end

  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  local function supports(method)
    if not method then return true end

    if type(method) == 'table' then
      for _, m in ipairs(method) do
        if supports(m) then return true end
      end

      return false
    end

    return client.supports_method(method) and true or false
  end

  local function lspset(mode, lhs, rhs, opts, method)
    opts = opts or {}
    opts.buffer = buf

    if supports(method) then vim.keymap.set(mode, lhs, rhs, opts) end
  end

  local function sign_help() vim.lsp.buf.signature_help({ border = 'double' }) end

  lspset('i', '<c-k>', sign_help, { desc = 'lsp: signature help' }, 'textDocument/signatureHelp')
  lspset('n', 'K', function() vim.lsp.buf.hover({ border = 'double' }) end, { desc = 'lsp: hover' })
  lspset('n', 'L', function() vim.diagnostic.open_float({ border = 'double' }) end, { desc = 'lsp: open float' })
  lspset('n', '<leader>ld', '<cmd>FzfLua lsp_definitions<cr>', { desc = 'lsp: definition' }, 'textDocument/definition')
  lspset('n', '<leader>lr', '<cmd>FzfLua lsp_references<cr>', { desc = 'lsp: references', nowait = true })
  lspset('n', '<leader>lI', '<cmd>FzfLua lsp_implementations<cr>', { desc = 'lsp: implementations' })
  lspset('n', '<leader>ly', '<cmd>FzfLua lsp_typedefs<cr>', { desc = 'lsp: type definition' })
  lspset('n', '<leader>lD', '<cmd>FzfLua lsp_declarations<cr>', { desc = 'lsp: declaration' })
  lspset('n', '<leader>ls', '<cmd>FzfLua lsp_document_symbols<cr>', { desc = 'lsp: document symbols' })
  lspset('n', '<leader>lS', '<cmd>FzfLua lsp_live_workspace_symbols<cr>', { desc = 'lsp: workspace symbols' })
  lspset('n', '<leader>li', '<cmd>FzfLua lsp_incoming_calls<cr>', { desc = 'lsp: incoming calls' })
  lspset('n', '<leader>lo', '<cmd>FzfLua lsp_outgoing_calls<cr>', { desc = 'lsp: outgoing calls' })
  lspset('n', '<leader>lx', '<cmd>FzfLua lsp_document_diagnostics<cr>', { desc = 'lsp: document diagnostics' })
  lspset('n', '<leader>lX', '<cmd>FzfLua lsp_workspace_diagnostics<cr>', { desc = 'lsp: workspace diagnostics' })
  lspset('n', '<leader>lK', vim.lsp.buf.signature_help, { desc = 'lsp: signature help' }, 'textDocument/signatureHelp')
  lspset('n', '<leader>lC', vim.lsp.codelens.refresh, { desc = 'lsp: display code lens' }, 'textDocument/codeLens')
  lspset('n', '<leader>ln', vim.lsp.buf.rename, { desc = 'lsp: rename' })
  lspset('n', '<leader>lc', vim.lsp.codelens.run, { desc = 'lsp: code lens' }, 'textDocument/codeLens')
  lspset('v', '<leader>lc', vim.lsp.codelens.run, { desc = 'lsp: code lens' }, 'textDocument/codeLens')
  lspset('n', '<leader>la', '<cmd>FzfLua lsp_code_actions<cr>', { desc = 'lsp: actions' }, 'textDocument/codeAction')
  lspset('v', '<leader>la', '<cmd>FzfLua lsp_code_actions<cr>', { desc = 'lsp: actions' }, 'textDocument/codeAction')
end

return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile', 'VeryLazy' },
  depencencies = {},
  init = function()
    -- Enhance LSP client registration by automatically calling on_attach
    -- when a language server registers its capabilities, ensuring custom
    -- setup is applied to newly connected LSP clients
    local register_capability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
    vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if not client then return end
      on_attach(client, vim.api.nvim_get_current_buf())
      return register_capability(err, res, ctx)
    end
  end,
  config = function()
    require('lspconfig').vtsls.setup({
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      on_attach = on_attach,
      root_dir = function(_, buf) return buf and vim.fs.root(buf, { 'package.json' }) end,
      single_file_support = false, -- avoid setting up vtsls on deno projects
    })

    require('lspconfig').denols.setup({
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      on_attach = on_attach,
      root_dir = function(_, buf) return buf and vim.fs.root(buf, { 'deno.json', 'deno.jsonc' }) end,
    })

    require('lspconfig').basedpyright.setup({
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      on_attach = on_attach,
      settings = {
        basedpyright = {
          typeCheckingMode = 'basic', -- Options: "off", "basic", "strict"
        },
      },
    })

    require('lspconfig').lua_ls.setup({
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      on_attach = on_attach,
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          codeLens = { enable = true },
          doc = { privateName = { '^_' } },
        },
      },
    })
  end,
}
