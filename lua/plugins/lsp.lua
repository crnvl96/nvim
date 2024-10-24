MiniDeps.add({
  source = 'neovim/nvim-lspconfig',
  depends = {
    {
      source = 'williamboman/mason-lspconfig.nvim',
      depends = {
        {
          source = 'williamboman/mason.nvim',
          hooks = {
            post_checkout = function() vim.cmd('MasonUpdate') end,
          },
        },
      },
    },
  },
})

require('mason').setup()

require('mason-registry').refresh(function()
  for _, tool in ipairs({
    'stylua',
    'prettierd',
    'prettier',
  }) do
    local pkg = require('mason-registry').get_package(tool)
    if not pkg:is_installed() then pkg:install() end
  end
end)

local capabilities = vim.tbl_deep_extend('force', {}, vim.lsp.protocol.make_client_capabilities())

local servers = {
  vtsls = {},
  eslint = {
    settings = {
      format = false,
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.split(package.path, ';'),
        },
        diagnostics = {
          globals = {
            'vim',
          },
          disable = {
            'need-check-nil',
          },
          workspaceDelay = -1,
        },
        workspace = {
          ignoreSubmodules = true,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
}

require('mason-lspconfig').setup({
  ensure_installed = vim.tbl_keys(servers),
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      server.capabilities = capabilities
      require('lspconfig')[server_name].setup(server)
    end,
  },
})
