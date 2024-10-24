return {
  'williamboman/mason.nvim',
  -- We don't lazy load the plugin startup since a various
  -- other plugins depend on this.
  lazy = false,
  build = ':MasonUpdate',
  opts = {},
  config = function(_, opts)
    require('mason').setup(opts)

    -- PERF: lazyly update and install missing mason tools
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
            -- javascript/typescript
            'vtsls',
            'eslint-lsp',
            'deno',
            'prettierd',
            'prettier',

            -- lua
            'lua-language-server',
            'stylua',

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
            -- if the tool is not installed yet, do it now.
            if not p:is_installed() then p:install() end
          end
        end)
      end,
    })
  end,
}
