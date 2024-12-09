return {
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
          on_attach(client, buf)

          local map = function(m, l, r, d, o)
            o = o or {}
            o.buffer = buf
            o.desc = d
            set(m, l, r, o)
          end

          map('n', '<leader>ca', function() vim.cmd.RustLsp('codeAction') end, 'code ation')
          map('n', '<leader>cu', function() vim.cmd.RustLsp('runnables') end, 'runnables')
          map('n', '<leader>dg', function() vim.cmd.RustLsp('debuggables') end, 'debuggables')
          map('n', 'K', function() vim.cmd.RustLsp({ 'hover', 'actions' }) end, 'hover')
        end,
        default_settings = {
          ['rust-analyzer'] = {
            -- We disable this in favor of bacon and bacon-ls
            -- Check the config definition at lsp and mason files
            checkOnSave = { enable = false },
            diagnostics = { enable = false },
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = { enable = true },
            },
            procMacro = {
              enable = true,
              ignored = {
                ['async-trait'] = { 'async_trait' },
                ['napi-derive'] = { 'napi' },
                ['async-recursion'] = { 'async_recursion' },
              },
            },
          },
        },
      },
    }
  end,
}
