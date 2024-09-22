return {
  { 'williamboman/mason-lspconfig.nvim' },
  { 'williamboman/mason.nvim', build = ':MasonUpdate' },
  { 'hrsh7th/cmp-nvim-lsp' },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = function()
      return {
        ensure_installed = {
          'stylua',
          'prettierd',
          'js-debug-adapter',
          'debugpy',
          'black',
        },
        servers = {
          basedpyright = {},
          eslint = { settings = { format = false } },
          vtsls = {
            settings = {
              complete_function_calls = true,
              vtsls = {
                enableMoveToFileCodeAction = true,
                autoUseWorkspaceTsdk = true,
                experimental = {
                  maxInlayHintLength = 30,
                  completion = {
                    enableServerSideFuzzyMatch = true,
                  },
                },
              },
              typescript = {
                suggest = { completeFunctionCalls = true },
                inlayHints = {
                  functionLikeReturnTypes = { enabled = true },
                  parameterNames = { enabled = 'literals' },
                  variableTypes = { enabled = true },
                },
              },
              javascript = {
                suggest = { completeFunctionCalls = true },
                inlayHints = {
                  functionLikeReturnTypes = { enabled = true },
                  parameterNames = { enabled = 'literals' },
                  variableTypes = { enabled = true },
                },
              },
            },
          },
          lua_ls = {
            on_init = function(client)
              local path = client.workspace_folders and client.workspace_folders[1] and client.workspace_folders[1].name
              if
                not path
                or not (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
              then
                client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                  Lua = {
                    runtime = {
                      version = 'LuaJIT',
                    },
                    workspace = {
                      checkThirdParty = false,
                      library = {
                        vim.env.VIMRUNTIME,
                        '${3rd}/luv/library',
                      },
                    },
                  },
                })
                client.notify(
                  vim.lsp.protocol.Methods.workspace_didChangeConfiguration,
                  { settings = client.config.settings }
                )
              end

              return true
            end,
            settings = {
              Lua = {
                format = { enable = false },
                hint = {
                  enable = true,
                  arrayIndex = 'Disable',
                },
                completion = { callSnippet = 'Replace' },
              },
            },
          },
        },
        capabilities = function()
          return vim.tbl_deep_extend(
            'force',
            {},
            vim.lsp.protocol.make_client_capabilities(),
            require('cmp_nvim_lsp').default_capabilities()
          )
        end,
      }
    end,
    config = function(_, opts)
      local servers = opts.servers
      local capabilities = opts.capabilities()

      require('mason').setup()

      local mr = require('mason-registry')
      mr:on('package:install:success', function()
        vim.defer_fn(
          function()
            require('lazy.core.handler.event').trigger({
              event = 'FileType',
              buf = vim.api.nvim_get_current_buf(),
            })
          end,
          100
        )
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then p:install() end
        end
      end)

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
    end,
  },
}
