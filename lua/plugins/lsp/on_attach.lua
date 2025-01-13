return function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  local sign_help = '<Cmd>lua vim.lsp.buf.signature_help({border="single"})<CR>'
  local open_float = '<Cmd>lua vim.diagnostic.open_float({boder="single"})<CR>'

  local set = vim.keymap.set

  local diagnostics = require('plugins.nvim-deck.sources.diagnostics')
  local references = require('plugins.nvim-deck.sources.lsp-references')
  local definition = require('plugins.nvim-deck.sources.lsp-definition')
  local implementations = require('plugins.nvim-deck.sources.lsp-implementations')
  local typedef = require('plugins.nvim-deck.sources.lsp-typedefinition')

  set('n', '<Leader>lx', diagnostics, { desc = 'Diagnostics' })
  set('n', '<Leader>ld', definition, { desc = 'Definition', buffer = bufnr })
  set('n', '<Leader>li', implementations, { desc = 'Implementation', buffer = bufnr })
  set('n', '<Leader>lr', references, { desc = 'References', buffer = bufnr })
  set('n', '<Leader>ly', typedef, { desc = 'Type definition', buffer = bufnr })

  set('n', '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'Code action', buffer = bufnr })
  set('n', '<Leader>le', '<Cmd>lua vim.lsp.buf.hover({border="single"})<CR>', { desc = 'Eval', buffer = bufnr })
  set('n', '<Leader>lh', sign_help, { desc = 'Signature help', buffer = bufnr })
  set('n', '<Leader>lj', '<Cmd>lua vim.diagnostic.goto_next()<CR>', { desc = 'Next diagnostic', buffer = bufnr })
  set('n', '<Leader>lk', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', { desc = 'Previous diagnostic', buffer = bufnr })
  set('n', '<Leader>ll', open_float, { desc = 'Inspect diagnostic', buffer = bufnr })
  set('n', '<Leader>ln', '<Cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'Rename symbol', buffer = bufnr })
end
