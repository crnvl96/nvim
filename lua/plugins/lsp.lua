return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile', 'VeryLazy' },
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
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    local lspconfig = require('lspconfig')

    lspconfig.bacon_ls.setup({
      autostart = true,
      settings = {
        locationsFile = '.bacon-locations',
        baconSettings = {
          spawn = true,
          command = 'bacon clippy -- --all-features',
        },
      },
    })

    lspconfig.vtsls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = function(_, bufnr) return bufnr and vim.fs.root(bufnr, { 'package.json' }) or nil end,
      single_file_support = false, -- avoid setting up vtsls on deno projects
    })

    lspconfig.denols.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = function(_, bufnr) return bufnr and vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' }) or nil end,
    })

    lspconfig.eslint.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = function(_, bufnr) return bufnr and vim.fs.root(bufnr, { 'package.json' }) or nil end,
      settings = { format = false, workingDirectory = { mode = 'auto' } },
    })

    lspconfig.ruff.setup({
      capabilities = capabilities,
      on_attach = function(client, buf)
        client.server_capabilities.hoverProvider = false
        on_attach(client, buf)
      end,
      cmd_env = { RUFF_TRACE = 'messages' },
      init_options = {
        settings = {
          logLevel = 'error',
        },
      },
    })

    lspconfig.basedpyright.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        basedpyright = {
          typeCheckingMode = 'basic', -- Options: "off", "basic", "strict"
        },
      },
    })

    lspconfig.taplo.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          codeLens = { enable = true },
          completion = { callSnippet = 'Replace' },
          doc = { privateName = { '^_' } },
        },
      },
    })
  end,
}
