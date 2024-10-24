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

    local icons = {
      ERROR = '',
      WARN = '',
      HINT = '',
      INFO = '',
    }

    vim.diagnostic.config({
      update_in_insert = true,
      severity_sort = true,
      virtual_text = false,
      float = {
        border = 'double',
        source = true,
        prefix = function(diag)
          local level = vim.diagnostic.severity[diag.severity]
          local prefix = string.format(' %s ', icons[level])
          return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
        end,
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.ERROR,
          [vim.diagnostic.severity.WARN] = icons.WARN,
          [vim.diagnostic.severity.HINT] = icons.HINT,
          [vim.diagnostic.severity.INFO] = icons.INFO,
        },
      },
    })

    local show_handler = vim.diagnostic.handlers.virtual_text.show
    assert(show_handler)

    local hide_handler = vim.diagnostic.handlers.virtual_text.hide
    vim.diagnostic.handlers.virtual_text = {
      show = function(ns, bufnr, diagnostics, opts)
        table.sort(diagnostics, function(diag1, diag2) return diag1.severity > diag2.severity end)
        return show_handler(ns, bufnr, diagnostics, opts)
      end,
      hide = hide_handler,
    }
  end,
  config = function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    require('lspconfig').vtsls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = function(_, bufnr) return bufnr and vim.fs.root(bufnr, { 'package.json' }) or nil end,
      single_file_support = false, -- avoid setting up vtsls on deno projects
    })

    require('lspconfig').denols.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = function(_, bufnr) return bufnr and vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' }) or nil end,
    })

    require('lspconfig').eslint.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = function(_, bufnr) return bufnr and vim.fs.root(bufnr, { 'package.json' }) or nil end,
      settings = { format = false, workingDirectory = { mode = 'auto' } },
    })

    require('lspconfig').lua_ls.setup({
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

    require('lspconfig').bacon_ls.setup({
      autostart = true,
      settings = {
        locationsFile = '.bacon-locations',
        baconSettings = {
          spawn = true,
          command = 'bacon clippy -- --all-features',
        },
      },
    })
  end,
}
