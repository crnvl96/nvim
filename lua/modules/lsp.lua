---@brief
---
--- ```lua
--- Tools = {
---   {
---     name = 'uv managed tools',
---     install = 'uv tool install pyright ruff',
---     update = 'uv tool upgrade pyright ruff',
---   },
---   {
---     name = 'mise managed tools',
---     install = 'mise use -g stylua taplo prettier jq dprint lua-language-server',
---     update = 'mise upgrade --bump',
---   },
---   {
---     name = 'npm managed tools',
---     install = 'npm i -g vscode-langservers-extracted typescript-language-server yaml-language-server',
---     update = 'npm i -g vscode-langservers-extracted@latest typescript-language-server@latest yaml-language-server@latest',
---   },
--- }
--- ```

vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities({
    general = {
      positionEncodings = {
        'utf-16',
      },
    },
  }),
})

local files = os.getenv('HOME') .. '/.config/nvim/lsp/*.lua'
local server_configs = vim
  .iter(vim.fn.glob(files, true, true))
  :map(function(file)
    assert(loadfile(file))()
    return vim.fn.fnamemodify(file, ':t:r')
  end)
  :totable()

vim.lsp.enable(server_configs)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('crnvl-lsp', { clear = true }),
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end
    vim.keymap.set('n', 'E', vim.diagnostic.open_float, { buffer = e.buf })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = e.buf })
    vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, { buffer = e.buf })
    vim.keymap.set('n', 'gn', vim.lsp.buf.rename, { buffer = e.buf })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = e.buf })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = e.buf })
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = e.buf, nowait = true })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = e.buf })
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, { buffer = e.buf })
    vim.keymap.set('n', 'ge', vim.diagnostic.setqflist, { buffer = e.buf })
    vim.keymap.set('n', 'gs', vim.lsp.buf.document_symbol, { buffer = e.buf })
    vim.keymap.set('n', 'gS', vim.lsp.buf.workspace_symbol, { buffer = e.buf })
    vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = e.buf })
  end,
})
