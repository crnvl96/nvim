return {
  'williamboman/mason.nvim',
  build = ':MasonUpdate',
  lazy = false,
  opts = {},
  config = function(_, opts)
    local M = require('config.functions')
    require('mason').setup(opts)

    -- PERF: lazyly update and install missing mason tools
    M.au('User', {
      group = M.group('crnvl96-mason-install-tools', { clear = true }),
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
            -- javascript/typescript
            'vtsls',
            'eslint_d',
            'deno',
            'prettierd',

            -- lua
            'lua-language-server',
            'stylua',
            'selene',

            -- rust
            'bacon-ls',
            'rust-analyzer',
            'bacon',
            'codelldb',

            -- toml
            'taplo',

            -- python
            'basedpyright',
            'ruff',
            'debugpy',
          }) do
            local p = mr.get_package(tool)
            if not p:is_installed() then p:install() end
          end
        end)
      end,
    })
  end,
}
