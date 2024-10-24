return {
  'williamboman/mason.nvim',
  lazy = false,
  build = ':MasonUpdate',
  opts = {},
  config = function(_, opts)
    require('mason').setup(opts)

    au('User', {
      group = group('crnvl96-mason-install-tools', { clear = true }),
      pattern = 'VeryLazy',
      callback = function()
        local mr = require('mason-registry')
        mr:on('package:install:success', function()
          vim.defer_fn(function()
            -- trigger FileType event to possibly load this newly installed LSP server
            require('lazy.core.handler.event').trigger({
              event = 'FileType',
              buf = vim.api.nvim_get_current_buf(),
            })
          end, 100)
        end)

        mr.refresh(function()
          for _, tool in ipairs({
            'vtsls',
            'eslint-lsp',
            'prettierd',
            'prettier',
            'deno',
            'lua-language-server',
            'stylua',
            'rust-analyzer',
            'taplo',
            'codelldb',
            'bacon',
            'bacon-ls',
          }) do
            local p = mr.get_package(tool)
            if not p:is_installed() then p:install() end
          end
        end)
      end,
    })
  end,
}
