return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile', 'VeryLazy' },
  depencencies = {
    -- Wrapper around rust-analyzer, that should only be activated on rust files
    {
      'mrcjkb/rustaceanvim',
      ft = 'rust',
      config = function()
        local package_path = require('mason-registry').get_package('codelldb'):get_install_path()
        local codelldb = package_path .. '/extension/adapter/codelldb'
        local library_path = package_path .. '/extension/lldb/lib/liblldb.so'
        local capabilities = require('blink.cmp').get_lsp_capabilities()

        vim.g.rustaceanvim = {
          dap = {
            adapter = require('rustaceanvim.config').get_codelldb_adapter(codelldb, library_path),
          },
          server = {
            capabilities = capabilities,
            on_attach = function(client, buf)
              local M = require('config.functions')
              local on_attach = M.on_attach

              on_attach(client, buf)

              local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buf, desc = desc }) end

              map('n', '<leader>la', function() vim.cmd.RustLsp('codeAction') end, 'code ation')
              map('n', '<leader>lu', function() vim.cmd.RustLsp('runnables') end, 'runnables')
              map('n', '<leader>dg', function() vim.cmd.RustLsp('debuggables') end, 'debuggables')
              map('n', 'K', function() vim.cmd.RustLsp({ 'hover', 'actions' }) end, 'hover')
            end,
            default_settings = {
              -- rust-analyzer language server configuration
              ['rust-analyzer'] = {
                cargo = {
                  allFeatures = true,
                  loadOutDirsFromCheck = true,
                  buildScripts = {
                    enable = true,
                  },
                },
                -- We disable this in favor of bacon and bacon-ls
                -- Check the config definition at lsp and mason files
                checkOnSave = { enable = false },
                diagnostics = { enable = false },
                procMacro = {
                  enable = true,
                  ignored = {
                    ['async-trait'] = { 'async_trait' },
                    ['napi-derive'] = { 'napi' },
                    ['async-recursion'] = { 'async_recursion' },
                  },
                },
                files = {
                  excludeDirs = {
                    '.direnv',
                    '.git',
                    '.github',
                    '.gitlab',
                    'bin',
                    'node_modules',
                    'target',
                    'venv',
                    '.venv',
                  },
                },
              },
            },
          },
        }
      end,
    },
  },
  init = function()
    local M = require('config.functions')

    -- Enhance LSP client registration by automatically calling on_attach
    -- when a language server registers its capabilities, ensuring custom
    -- setup is applied to newly connected LSP clients
    local register_capability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
    vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if not client then return end
      M.on_attach(client, vim.api.nvim_get_current_buf())
      return register_capability(err, res, ctx)
    end

    vim.diagnostic.config({ source = true })
  end,
  config = function()
    local M = require('config.functions')
    local on_attach = M.on_attach

    local capabilities = require('blink.cmp').get_lsp_capabilities()
    local lspconfig = require('lspconfig')

    --Background code checker for rust
    --
    -- https://dystroy.org/bacon/
    --
    -- We still need to launch bacon as a separate process, since this lsp
    -- server only integrates an already running process to publish
    -- its diagnostics within nvim
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
