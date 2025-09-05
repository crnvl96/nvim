local U = require('utils')

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

vim.lsp.config('lua_ls', {
  root_markers = { '.luarc.json', '.luarc.jsonc' },
  settings = {
    Lua = {
      completion = { callSnippet = 'Disable' },
      format = { enable = false },
      hint = { enable = false },
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          '${3rd}/luv/library',
        },
      },
    },
  },
})

vim.lsp.config('eslint', {
  settings = {
    format = false,
  },
})

vim.lsp.config('dprint', {})

vim.lsp.config('taplo', {})

vim.lsp.config('ts_ls', {})

vim.lsp.config('jsonls', {
  settings = {
    json = {
      validate = { enable = true },
      schemas = require('schemastore').json.schemas(),
    },
  },
})

vim.lsp.config('pyright', {
  settings = {
    pyright = {
      disableOrganizeImports = true, -- Using Ruff's import organizer
    },
    python = {
      analysis = {
        ignore = { '*' }, -- Ignore all files for analysis to exclusively use Ruff for linting
      },
    },
  },
})

vim.lsp.config('ruff', {
  init_options = {
    settings = { logLevel = 'debug' },
  },
})

vim.lsp.config('yamlls', {
  on_init = function(client) client.server_capabilities.documentFormattingProvider = true end,
  settings = {
    yaml = {
      format = { enable = true },
      schemastore = { enable = false, url = '' },
      schemas = require('schemastore').yaml.schemas(),
    },
  },
})

vim.lsp.enable({
  'eslint',
  'lua_ls',
  'jsonls',
  'pyright',
  'ruff',
  'yamlls',
  'dprint',
  'taplo',
  'ts_ls',
})

U.augroup('crnvl-lspattach', function(g)
  U.aucmd('LspAttach', {
    group = g,
    callback = function(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)
      if not client then return end
      U.lspmap(e.buf, 'E', vim.diagnostic.open_float, 'Show Error')
      U.lspmap(e.buf, 'K', vim.lsp.buf.hover, 'Hover')
      U.lspmap(e.buf, 'ga', vim.lsp.buf.code_action, 'Code Actions')
      U.lspmap(e.buf, 'gn', vim.lsp.buf.rename, 'Rename Symbol')
      U.lspmap(e.buf, 'gd', vim.lsp.buf.definition, 'Goto Definition')
      U.lspmap(e.buf, 'gD', vim.lsp.buf.declaration, 'Goto Declaration')
      U.lspmap(e.buf, 'gr', vim.lsp.buf.references, 'Goto References')
      U.lspmap(e.buf, 'gi', vim.lsp.buf.implementation, 'Goto Implementations')
      U.lspmap(e.buf, 'gy', vim.lsp.buf.type_definition, 'Goto T[y]pe Definitions')
      U.lspmap(e.buf, 'ge', vim.diagnostic.setqflist, 'Send Diagnostics to Qf list')
      U.lspmap(e.buf, 'gs', vim.lsp.buf.document_symbol, 'Show Document Symbols')
      U.lspmap(e.buf, 'gS', vim.lsp.buf.workspace_symbol, 'Show Workspace Symbols')
      U.lspmap(e.buf, '<C-k>', vim.lsp.buf.signature_help, 'Signature Help', 'i')
    end,
  })
end)
