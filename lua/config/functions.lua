local M = {}

M.set = vim.keymap.set
M.au = vim.api.nvim_create_autocmd
M.group = vim.api.nvim_create_augroup
M.user = vim.api.nvim_create_user_command
M.hl = vim.api.nvim_set_hl

-- These functions have been retired from https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/init.lua

-- Checks if a plugin is installed
function M.has(plugin) return require('lazy.core.config').spec.plugins[plugin] ~= nil end

-- Check if a plugin has already been loaded
function M.is_loaded(name)
  local Config = require('lazy.core.config')
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

-- Run a callback when a plugin loads
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn()
  else
    M.au('User', {
      pattern = 'LazyLoad',
      group = M.group('crnvl96-lazy-util-on-load', { clear = true }),
      callback = function(event)
        if event.data == name then
          fn()
          return true
        end
      end,
    })
  end
end

local function emit_notify(msg, lvl)
  if M.has('snacks.nvim') and M.is_loaded('snacks.nvim') then
    Snacks.notify[lvl](msg)
  else
    vim.notify(msg, vim.log.levels[string.upper(lvl)])
  end
end

M.notify = {
  info = function(msg) emit_notify(msg, 'info') end,
  error = function(msg) emit_notify(msg, 'error') end,
}

-- Wrapper meant to add/override some LSP functionatities, such ad capabilities
-- and keymaps
function M.on_attach(client, buf)
  -- Since our keymaps are all centered around fzf-lua, if this packags does not exist, we must
  -- stop the execution
  if not M.has('fzf-lua') then
    M.notify.error('You need to install fzf-lua, which is a dependency for the `on_attach` wrapper')
    return
  end

  -- Formatting and Range formatting are both handled by `conform.nvim` plugin
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  -- Function to chech if a LSP method if enabled for the current language server
  local function supports(method)
    -- If we pass no method, we don't care about this function, and
    -- can directly return `true`
    if not method then return true end

    -- Recursively calls itself for each method on the table
    --
    -- When the arguments passed is a table, we want to ensure that
    -- at least one of the methods present there are valid.
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

    if supports(method) then M.set(mode, lhs, rhs, opts) end
  end

  --
  -- These keymaps will only be set if the respective methods (last argument)
  -- are available for the current lsp server
  lspset('i', '<c-k>', vim.lsp.buf.signature_help, { desc = 'signature help' }, 'textDocument/signatureHelp')
  lspset('n', 'K', vim.lsp.buf.hover, { desc = 'hover' })
  lspset('n', 'L', vim.diagnostic.open_float, { desc = 'open float' })

  lspset('n', '<leader>ld', '<cmd>FzfLua lsp_definitions<cr>', { desc = 'definition' }, 'textDocument/definition')
  lspset('n', '<leader>lr', '<cmd>FzfLua lsp_references<cr>', { desc = 'references', nowait = true })
  lspset('n', '<leader>lI', '<cmd>FzfLua lsp_implementations<cr>', { desc = 'implementations' })
  lspset('n', '<leader>ly', '<cmd>FzfLua lsp_typedefs<cr>', { desc = 'type definition' })
  lspset('n', '<leader>lD', '<cmd>FzfLua lsp_declarations<cr>', { desc = 'declaration' })
  lspset('n', '<leader>ls', '<cmd>FzfLua lsp_document_symbols<cr>', { desc = 'document symbols' })
  lspset('n', '<leader>lS', '<cmd>FzfLua lsp_live_workspace_symbols<cr>', { desc = 'workspace symbols' })
  lspset('n', '<leader>li', '<cmd>FzfLua lsp_incoming_calls<cr>', { desc = 'incoming calls' })
  lspset('n', '<leader>lo', '<cmd>FzfLua lsp_outgoing_calls<cr>', { desc = 'outgoing calls' })
  lspset('n', '<leader>lx', '<cmd>FzfLua lsp_document_diagnostics<cr>', { desc = 'document diagnostics' })
  lspset('n', '<leader>lX', '<cmd>FzfLua lsp_workspace_diagnostics<cr>', { desc = 'workspace diagnostics' })
  lspset('n', '<leader>lK', vim.lsp.buf.signature_help, { desc = 'signature help' }, 'textDocument/signatureHelp')
  lspset('n', '<leader>lC', vim.lsp.codelens.refresh, { desc = 'display code lens' }, 'textDocument/codeLens')
  lspset('n', '<leader>ln', vim.lsp.buf.rename, { desc = 'rename' })

  lspset('n', '<leader>lc', vim.lsp.codelens.run, { desc = 'code lens' }, 'textDocument/codeLens')
  lspset('v', '<leader>lc', vim.lsp.codelens.run, { desc = 'code lens' }, 'textDocument/codeLens')

  lspset('n', '<leader>la', '<cmd>FzfLua lsp_code_actions<cr>', { desc = 'actions' }, 'textDocument/codeAction')
  lspset('v', '<leader>la', '<cmd>FzfLua lsp_code_actions<cr>', { desc = 'actions' }, 'textDocument/codeAction')
end

return M
