local add = MiniDeps.add

for _, cli in ipairs({
  'tree-sitter',
  'rg',
  'rustc',
  'npm',
  'fzf',
}) do
  if vim.fn.executable(cli) ~= 1 then
    local msg = cli .. ' is not installed in the system.'
    local lvl = vim.log.levels.ERROR

    vim.notify(msg, lvl)
  end
end

_G.Mason_tools = {
  -- javascript/typescript
  'vtsls',
  'eslint_d',
  'deno',
  'prettierd',

  -- lua
  'lua-language-server',
  'stylua',
  'selene',

  -- python
  'basedpyright',
  'ruff',
  'debugpy',
}

_G.Treesitter_parsers = {
  'c',
  'vim',
  'vimdoc',
  'query',
  'markdown',
  'markdown_inline',

  -- lua
  'lua',

  -- js/ts
  'javascript',
  'typescript',
  'tsx',

  -- python
  'python',
}

_G.Formatters = {
  by_ft = {
    markdown = { 'prettierd', 'injected' },
    css = { 'prettierd' },
    html = { 'prettierd' },
    json = { 'prettierd' },
    toml = { 'taplo' },
    lua = { 'stylua' },
    javascript = { 'deno_fmt', 'prettierd' },
    typescript = { 'deno_fmt', 'prettierd' },
    javascriptreact = { 'deno_fmt', 'prettierd' },
    typescriptreact = { 'deno_fmt', 'prettierd' },
    ['javascript.tsx'] = { 'deno_fmt', 'prettierd' },
    ['typescript.tsx'] = { 'deno_fmt', 'prettierd' },
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
  },
  specs = {
    injected = { ignore_errors = true },
    prettierd = {
      condition = function()
        local buffer = vim.api.nvim_get_current_buf()
        return (
          vim.tbl_contains({
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.tsx',
          }, vim.bo[buffer].filetype) and not vim.fs.root(buffer, { 'package.json' })
        ) or true
      end,
    },
    deno_fmt = {
      condition = function()
        return vim.fs.root(vim.api.nvim_get_current_buf(), { 'deno.json', 'deno.jsonc' }) and true or false
      end,
    },
  },
}

_G.Servers = {
  vtsls = {
    root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { 'package.json' }) end,
    single_file_support = false, -- avoid setting up vtsls on deno projects
  },
  denols = {
    root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { 'deno.json', 'deno.jsonc' }) end,
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
            'MiniPick',
            'MiniClue',
            'MiniDeps',
            'MiniNotify',
            'MiniIcons',
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
        -- Using stylua for formatting.
        format = { enable = false },
        hint = {
          enable = true,
          arrayIndex = 'Disable',
        },
        -- completion = { callSnippet = 'Replace' },
        completion = {
          callSnippet = 'Disable',
          keywordSnippet = 'Disable',
        },
      },
    },
  },
}

_G.Debuggers_by_ft = function()
  ---
  --- Python
  ---

  add({ source = 'mfussenegger/nvim-dap-python' })

  ---@return string?
  local function get_install_path(tool)
    local path = require('mason-registry').get_package(tool):get_install_path()
    return path or nil
  end

  local debugpy_path = get_install_path('debugpy')

  if not debugpy_path then
    vim.notify('You need to install `debugpy` for dap to work properly', vim.log.levels.ERROR)
    return
  end

  require('dap-python').setup(debugpy_path .. '/venv/bin/python')
end
