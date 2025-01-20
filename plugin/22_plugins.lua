require('mini.colors')
  .get_colorscheme()
  :add_transparency({
    float = true,
  })
  :apply()

Add('folke/snacks.nvim')

Utils.Req('zoxide')
Utils.Req('lazydocker')
Utils.Req('lazygit')

require('snacks').setup({
  bigfile = { size = 1 * 1024 * 1024 },
  quickfile = { exclude = { 'latex' } },
  indent = { enabled = false },
  input = { enabled = true },
  notifier = { enabled = true },
  picker = {
    formatters = {
      file = {
        filename_first = true,
      },
    },
  },
  scratch = { ft = function() return 'markdown' end },
  scope = { enabled = true },
  statuscolumn = { enabled = true },
})

_G.dd = function(...) Snacks.debug.inspect(...) end
_G.bt = function() Snacks.debug.backtrace() end
vim.print = _G.dd

Utils.Req('tree-sitter')

Add({
  source = 'nvim-treesitter/nvim-treesitter',
  hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})

require('nvim-treesitter.configs').setup({
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
})

require('mini.icons').setup()
require('mini.doc').setup()
require('mini.align').setup()

require('mini.diff').setup({
  view = {
    style = 'sign',
  },
})

Add('nvim-lua/plenary.nvim')
Add('lambdalisue/vim-suda')
Add('tpope/vim-fugitive')
Add('hat0uma/csvview.nvim')

require('csvview').setup()

Add('andymass/vim-matchup')
Add('mfussenegger/nvim-lint')

Utils.Req('ruff')
Utils.Req('prettierd')
Utils.Req('stylua')

Add('stevearc/conform.nvim')

vim.g.autoformat = true

require('conform').setup({
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
})

Add('milanglacier/yarepl.nvim')

Utils.Req('aider')

require('yarepl').formatter.trim_empty_lines = require('yarepl').formatter.factory({
  when_multi_lines = {
    trim_empty_lines = false,
    remove_leading_spaces = false,
  },
})

require('yarepl.extensions.aider').setup({
  aider_args = {
    '--vim',
    '--dark-mode',
    '--dry-run',
    '--multiline',
    '--haiku',
    '--watch-files',
    '--no-auto-commits',
    '--no-auto-lint',
    '--no-auto-test',
    '--env-file',
    vim.fn.stdpath('config') .. '/.env',
  },
  wincmd = 'vertical 50 split',
})

require('yarepl').setup({
  wincmd = 'vertical 50 split',
  metas = {
    python = { cmd = { 'uv', 'run', 'python' }, formatter = require('yarepl').formatter.trim_empty_lines },
    aider = require('yarepl.extensions.aider').create_aider_meta(),
  },
})

Add('saghen/blink.compat')

Add({
  source = 'Saghen/blink.cmp',
  hooks = {
    post_install = function(params)
      Later(function() Utils.Build(params, { 'cargo', 'build', '--release' }) end)
    end,
    post_checkout = function(params)
      Later(function() Utils.Build(params, { 'cargo', 'build', '--release' }) end)
    end,
  },
})

require('blink.compat').setup()

require('blink.cmp').setup({
  enabled = function()
    return not vim.tbl_contains({ 'minifiles', 'markdown' }, vim.bo.filetype)
      and vim.bo.buftype ~= 'prompt'
      and vim.b.completion ~= false
  end,
  appearance = { use_nvim_cmp_as_default = false, nerd_font_variant = 'mono' },
  completion = {
    ghost_text = { enabled = false },
    list = {
      selection = {
        preselect = function(ctx) return ctx.mode ~= 'cmdline' end,
        auto_insert = function(ctx) return ctx.mode == 'cmdline' end,
      },
    },
    menu = { border = 'rounded', scrollbar = false },
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
})

Add('neovim/nvim-lspconfig')

local ok = pcall(require, 'blink.cmp')

if not ok then
  Utils.Log('blink.cmp must be installed to have access to full capabilities.', 3)
  return vim.lsp.protocol.make_client_capabilities()
end

local capabilities =
  require('blink.cmp').get_lsp_capabilities(vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false,
        },
      },
    },
  }))

for server, config in pairs({
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
}) do
  config = config or {}
  local opts = { capabilities = capabilities }
  config = vim.tbl_deep_extend('force', config, opts)
  require('lspconfig')[server].setup(config)
end

Add('theHamsta/nvim-dap-virtual-text')
Add('mfussenegger/nvim-dap-python')
Add('mfussenegger/nvim-dap')
Add('igorlfs/nvim-dap-view')

vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

require('dap-view').setup()
require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })

require('dap.ext.vscode').json_decode = function(data)
  local decode = vim.json.decode
  local strip_comments = require('plenary.json').json_strip_comments
  data = strip_comments(data)

  return decode(data)
end

require('dap-python').setup('uv')

require('mini.files').setup({
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
})

require('mini.clue').setup({
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

    { mode = 'n', keys = '<Leader>b', desc = '+Buffers' },
    { mode = 'n', keys = '<Leader>c', desc = '+Code' },
    { mode = 'n', keys = '<Leader>d', desc = '+DAP' },
    { mode = 'n', keys = '<Leader>f', desc = '+Files' },
    { mode = 'n', keys = '<Leader>g', desc = '+Git' },
    { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
    { mode = 'n', keys = '<Leader>u', desc = '+Toggle' },

    { mode = 'x', keys = '<Leader>c', desc = '+Code' },
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
})
