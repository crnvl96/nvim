_G.Utils = {}

Utils.Autocmd = vim.api.nvim_create_autocmd

Utils.Keymap = function(desc, opts)
  opts = opts or {}
  opts.desc = desc

  local lhs = ''
  local rhs = ''
  local mode = 'n'

  if opts.mode then
    mode = opts.mode
    opts.mode = nil
  end

  if opts.lhs then
    lhs = opts.lhs
    opts.lhs = nil
  end

  if opts.rhs then
    rhs = opts.rhs
    opts.rhs = nil
  end

  vim.keymap.set(mode, lhs, rhs, opts)
end

Utils.Group = function(name, fn) fn(vim.api.nvim_create_augroup(name, { clear = true })) end

Utils.Log = function(msg, code)
  local lvls = { 'INFO', 'WARN', 'ERROR' }
  local lvl = lvls[code]

  vim.notify(msg, vim.log.levels[lvl])
end

Utils.SetNodePath = function(node_path)
  if vim.fn.isdirectory(node_path) == 1 then
    vim.env.PATH = node_path .. '/bin:' .. vim.env.PATH
    vim.env.NODE_PATH = node_path

    Utils.Log('Node.js path set to: ' .. node_path, 1)
  else
    Utils.Log('Invalid Node.js path: ' .. node_path, 3)
  end
end

Utils.Req = function(tools)
  if type(tools) ~= 'table' then tools = { tools } end
  local len = #tools

  local missing_tools = {}
  for _, tool in ipairs(tools) do
    if vim.fn.executable(tool) ~= 1 then table.insert(missing_tools, tool) end
  end

  if #missing_tools > 0 then
    local msg = 'The following tools are required to be installed:\n'
    for k, tool in ipairs(missing_tools) do
      if k == #missing_tools then
        msg = msg .. '\t- ' .. tool
      else
        msg = msg .. '\t- ' .. tool .. '\n'
      end
    end
    Utils.Log(msg, 3)
  end
end

Utils.Build = function(params, cmd)
  local pref = 'Building ' .. params.name
  Utils.Log(pref, 1)

  local obj = vim.system(cmd, { cwd = params.path }):wait()
  local res = obj.code == 0 and (pref .. ' done') or (pref .. ' failed')
  local lvl = obj.code == 0 and 1 or 3

  Utils.Log(res, lvl)
end

Utils.servers = {
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
        typeCheckingMode = 'strict', -- Options: "off", "basic", "strict"
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

Utils.capabilities = {
  textDocument = {
    completion = {
      completionItem = {
        snippetSupport = false,
      },
    },
  },
}

Utils.completion = {
  enabled = function()
    return not vim.tbl_contains({ 'minifiles', 'markdown' }, vim.bo.filetype)
      and vim.bo.buftype ~= 'prompt'
      and vim.b.completion ~= false
  end,
  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = 'mono',
  },
  completion = {
    ghost_text = {
      enabled = false,
    },
    list = {
      selection = {
        preselect = function(ctx) return ctx.mode ~= 'cmdline' end,
        auto_insert = function(ctx) return ctx.mode == 'cmdline' end,
      },
    },
    menu = {
      border = 'rounded',
      scrollbar = false,
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
      window = {
        border = 'rounded',
        scrollbar = false,
      },
    },
  },
  sources = {
    transform_items = function(_, items)
      return vim.tbl_filter(
        function(item) return item.kind ~= require('blink.cmp.types').CompletionItemKind.Snippet end,
        items
      )
    end,
  },
  signature = {
    enabled = true,
    window = { border = 'rounded' },
  },
}

Utils.formatters = {
  notify_on_error = true,
  formatters = { injected = { ignore_errors = true } },
  formatters_by_ft = {
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
    lua = { 'stylua' },
    javascript = { 'prettierd' },
    css = { 'prettierd' },
    scss = { 'prettierd' },
    javascriptreact = { 'prettierd' },
    typescript = { 'prettierd' },
    typescriptreact = { 'prettierd' },
    json = { 'prettierd' },
    jsonc = { 'prettierd' },
    markdown = { 'prettierd', 'injected' },
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
  },
  format_on_save = function()
    if not vim.g.autoformat then return end
    return {
      timeout_ms = 3000,
      async = false,
      quiet = false,
      lsp_format = 'fallback',
    }
  end,
}

Utils.treesitter = {
  highlight = { enable = true },
  indent = { enable = true, disable = { 'yaml' } },
  sync_install = false,
  auto_install = true,
  ensure_installed = {
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
  },
}

Utils.json_decoder = function(data)
  local decode = vim.json.decode
  local strip_comments = require('plenary.json').json_strip_comments
  data = strip_comments(data)
  return decode(data)
end

Utils.fm = {
  mappings = {
    show_help = '?',
    go_in = '',
    go_out = '',
    go_in_plus = '<cr>',
    go_out_plus = '-',
  },
  windows = {
    preview = true,
    width_preview = 80,
  },
}

Utils.clues = {
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },

    -- Registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
  },
  clues = {
    require('mini.clue').gen_clues.builtin_completion(),
    require('mini.clue').gen_clues.g(),
    require('mini.clue').gen_clues.marks(),
    require('mini.clue').gen_clues.registers(),
    require('mini.clue').gen_clues.windows(),
    require('mini.clue').gen_clues.z(),

    { mode = 'n', keys = '<Leader>a', desc = '+Aider' },
    { mode = 'n', keys = '<Leader>am', desc = '+Modes' },

    { mode = 'n', keys = '<Leader>b', desc = '+Buffers' },
    { mode = 'n', keys = '<Leader>d', desc = '+DAP' },
    { mode = 'n', keys = '<Leader>f', desc = '+Files' },
    { mode = 'n', keys = '<Leader>g', desc = '+Git' },
    { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
    { mode = 'n', keys = '<Leader>l', desc = '+Notifications' },
    { mode = 'n', keys = '<Leader>u', desc = '+Toggle' },

    { mode = 'x', keys = '<Leader>a', desc = '+Aider' },
    { mode = 'x', keys = '<Leader>f', desc = '+Files' },
    { mode = 'x', keys = '<Leader>g', desc = '+Git' },
  },
  window = {
    config = {
      width = 'auto',
    },
    delay = 200,
    scroll_down = '<C-f>',
    scroll_up = '<C-b>',
  },
}

Utils.qol = {
  input = { enabled = true },
  notifier = { enabled = true },
  picker = {
    formatters = {
      file = {
        filename_first = true,
      },
    },
    win = {
      input = {
        keys = {
          ['yy'] = 'copy',
          ['<c-y>'] = { 'copy', mode = { 'n', 'i' } },
        },
      },
      list = { keys = { ['yy'] = 'copy' } },
    },
  },
}
