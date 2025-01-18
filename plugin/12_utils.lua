Add, Now, Later = MiniDeps.add, MiniDeps.now, MiniDeps.later

_G.Utils = {}

Utils.Set = vim.keymap.set
Utils.Autocmd = vim.api.nvim_create_autocmd

Utils.Group = function(name, fn) fn(vim.api.nvim_create_augroup(name, { clear = true })) end

Utils.Log = function(msg, code)
  local lvls = { 'INFO', 'WARN', 'ERROR' }
  local lvl = lvls[code]

  vim.notify(msg, vim.log.levels[lvl])
end

Utils.Req = function(tool)
  if vim.fn.executable(tool) ~= 1 then Utils.Log(tool .. ' is not installed in the system!', 3) end
end

Utils.Build = function(params, cmd)
  local pref = 'Building ' .. params.name
  Utils.Log(pref, 1)

  local obj = vim.system(cmd, { cwd = params.path }):wait()
  local res = obj.code == 0 and (pref .. ' done') or (pref .. ' failed')
  local lvl = obj.code == 0 and 1 or 3

  Utils.Log(res, lvl)
end

Utils.lsp_capabilities = function()
  local ok = pcall(require, 'blink.cmp')

  if not ok then
    vim.notify('blink.cmp must be installed to have access to full capabilities.', vim.log.levels.ERROR)
    return vim.lsp.protocol.make_client_capabilities()
  end

  return require('blink.cmp').get_lsp_capabilities(
    vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = false,
          },
        },
      },
    })
  )
end

Utils.get_parsers = function()
  return {
    'c',
    'vim',
    'vimdoc',
    'query',
    'markdown',
    'markdown_inline',
    'lua',
    'javascript',
    'typescript',
    'tsx',
    'python',
    'sql',
    'csv',
  }
end

Utils.lsp_get_servers = function()
  return {
    vtsls = {
      root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { 'package.json' }) end,
      single_file_support = false,
    },
    eslint = {
      workingDirectories = { mode = 'auto' },
    },
    ruff = {
      on_attach = function(client) client.server_capabilities.hoverProvider = false end,
      cmd_env = { RUFF_TRACE = 'messages' },
      init_options = {
        settings = {
          logLevel = 'error',
        },
      },
    },
    basedpyright = {
      settings = {
        basedpyright = {
          typeCheckingMode = 'basic', -- Options: "off", "basic", "strict"
        },
      },
    },
    lua_ls = {
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then return end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          diagnostics = {
            globals = {
              'vim',
            },
          },
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
        })
      end,
      settings = {
        Lua = {
          format = { enable = false },
          hint = {
            enable = true,
            arrayIndex = 'Disable',
          },
          completion = {
            callSnippet = 'Disable',
            keywordSnippet = 'Disable',
          },
        },
      },
    },
  }
end
