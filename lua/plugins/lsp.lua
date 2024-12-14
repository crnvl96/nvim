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
      OnAttach(client, vim.api.nvim_get_current_buf())
      return register_capability(err, res, ctx)
    end
  end,
  config = function()
    require('lspconfig').vtsls.setup({
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      on_attach = OnAttach,
      root_dir = function(_, buf)
        local ctx = { buf = buf }
        return MatchAtRoot(ctx, { 'package.json' })
      end,
      single_file_support = false, -- avoid setting up vtsls on deno projects
    })

    require('lspconfig').denols.setup({
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      on_attach = OnAttach,
      root_dir = function(_, buf)
        local ctx = { buf = buf }
        return MatchAtRoot(ctx, { 'deno.json', 'deno.jsonc' })
      end,
    })

    require('lspconfig').basedpyright.setup({
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      on_attach = OnAttach,
      settings = {
        basedpyright = {
          typeCheckingMode = 'basic', -- Options: "off", "basic", "strict"
        },
      },
    })

    require('lspconfig').lua_ls.setup({
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      on_attach = OnAttach,
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
