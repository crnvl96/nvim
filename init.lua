local mini_path = vim.fn.stdpath 'data' .. '/site/pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd 'packadd mini.nvim | helptags ALL'
  vim.cmd 'echo "Installed `mini.nvim`" | redraw'
end

require('mini.deps').setup()

vim.cmd [[colorscheme ansi]]

local lsp_dir = vim.fn.stdpath 'config' .. '/lsp'
local excluded_servers = { 'basedpyright', 'pyrefly', 'rubocop' }

local lsp_servers = {}
for _, file in ipairs(vim.fn.glob(lsp_dir .. '/*.lua', true, true)) do
  local server_name = vim.fn.fnamemodify(file, ':t:r')
  if not vim.tbl_contains(excluded_servers, server_name) then
    table.insert(lsp_servers, server_name)
    local chunk = assert(loadfile(file))
    vim.lsp.config(server_name, chunk())
  end
end

vim.lsp.enable(lsp_servers)

local default_nodejs = vim.env.HOME .. '/.local/share/mise/installs/node/23.11.1/bin/'

vim.g.node_host_prog = default_nodejs .. 'node'
vim.env.PATH = default_nodejs .. ':' .. vim.env.PATH

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

vim.o.guicursor = ''
vim.o.scrolloff = 8
vim.o.sidescrolloff = 24
vim.o.wrap = false
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.laststatus = 2
vim.o.linebreak = true
vim.o.ignorecase = true
vim.o.wildignorecase = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.signcolumn = 'yes'
vim.o.virtualedit = 'block'
vim.o.winborder = 'single'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.undofile = true
vim.o.writebackup = false

vim.opt.diffopt = {
  'internal',
  'filler',
  'closeoff',
  'context:4',
  'algorithm:histogram',
  'linematch:60',
  'indent-heuristic',
  'inline:char', -- also accept inline:word
}

vim.keymap.set('x', 'p', 'P')
vim.keymap.set('x', 'Y', 'yg_')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>p', '"+p')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>P', '"+P')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>y', '"+y')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>Y', '"+yg_')
vim.keymap.set({ 'n', 'x', 'o', 'i' }, '<C-s>', '<Esc><Cmd>nohl<CR><Cmd>w<CR><Esc>')
vim.keymap.set('n', 'gc', ':<C-U>let @+ = expand(\'%:.\')<CR>')
vim.keymap.set('n', 'gp', '`[v`]')
vim.keymap.set({ 'n', 'x', 'i', 's' }, '<Esc>', '<Cmd>noh<CR><Esc>')
vim.keymap.set({ 'n', 'x' }, 'j', 'v:count == 0 ? \'gj\' : \'j\'', { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', 'v:count == 0 ? \'gk\' : \'k\'', { expr = true })
vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('crnvl96-restore-cursor', {}),
  callback = function(e)
    pcall(
      vim.api.nvim_win_set_cursor,
      vim.fn.bufwinid(e.buf),
      vim.api.nvim_buf_get_mark(e.buf, [["]])
    )
  end,
})

vim.filetype.add {
  filename = {
    ['.eslintrc.json'] = 'jsonc',
  },
  pattern = {
    ['tsconfig*.json'] = 'jsonc',
    ['.*/%.vscode/.*%.json'] = 'jsonc',
    ['.*'] = function(path, bufnr)
      return vim.bo[bufnr]
          and vim.bo[bufnr].filetype ~= 'bigfile'
          and path
          and vim.fn.getfsize(path) > (1024 * 500) -- 500kb
          and 'bigfile'
        or nil
    end,
  },
}

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('crnvl96-big-file', { clear = true }),
  pattern = 'bigfile',
  callback = function(args)
    vim.schedule(
      function() vim.bo[args.buf].syntax = vim.filetype.match { buf = args.buf } or '' end
    )
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-yank-hl', { clear = true }),
  callback = function() vim.hl.on_yank { higroup = 'Visual', priority = 250 } end,
})

local methods = vim.lsp.protocol.Methods

vim.diagnostic.config {
  virtual_text = true,
  virtual_lines = false,
  float = true,
  signs = false,
}

local function on_attach(client, bufnr)
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  local set = function(lhs, rhs, opts, mode)
    opts = vim.tbl_extend('error', opts or {}, { buffer = bufnr })
    mode = mode or 'n'
    return vim.keymap.set(mode, lhs, rhs, opts)
  end

  set('E', vim.diagnostic.open_float)
  set('K', vim.lsp.buf.hover)
  set('ga', vim.lsp.buf.code_action)
  set('gn', vim.lsp.buf.rename)
  set('gd', vim.lsp.buf.definition)
  set('gD', vim.lsp.buf.declaration)
  set('gr', vim.lsp.buf.references, { nowait = true })
  set('gi', vim.lsp.buf.implementation)
  set('gy', vim.lsp.buf.type_definition)
  set('ge', vim.diagnostic.setqflist)
  set('gs', vim.lsp.buf.document_symbol)
  set('gS', vim.lsp.buf.workspace_symbol)
  set('<C-k>', vim.lsp.buf.signature_help, {}, 'i')

  if client:supports_method(methods.textDocument_inlayHint) then
    local toggle = function()
      local enabled = vim.lsp.inlay_hint.is_enabled()
      vim.lsp.inlay_hint.enable(not enabled)
      vim.notify(
        enabled and 'Enabled' or 'Disabled' .. ' inlay hints.',
        vim.log.levels.INFO
      )
    end

    set('g=', toggle)
  end

  if client:supports_method(methods.textDocument_formatting) then
    client.server_capabilities.documentFormattingProvider = true
  end

  if client:supports_method(methods.textDocument_documentColor) then
    vim.lsp.document_color.enable(true, bufnr)
  end

  vim.bo[bufnr].indentexpr = 'v:lua.require\'nvim-treesitter\'.indentexpr()'

  local win = vim.api.nvim_get_current_win()

  if client:supports_method(methods.textDocument_foldingRange) then
    vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
  else
    vim.wo[win][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end
end

local signature = vim.lsp.protocol.Methods.client_registerCapability
local register_capability = vim.lsp.handlers[signature]

vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then return end
  on_attach(client, vim.api.nvim_get_current_buf())
  return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('crnvl96-on-lsp-attach', {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    on_attach(client, args.buf)
  end,
})

MiniDeps.now(function()
  MiniDeps.add { name = 'mini.nvim' }
  MiniDeps.add 'nvim-lua/plenary.nvim'

  local icons = require 'mini.icons'
  icons.setup()
  icons.mock_nvim_web_devicons()

  MiniDeps.add 'neovim/nvim-lspconfig'
  MiniDeps.add 'tpope/vim-fugitive'
  MiniDeps.add 'tpope/vim-rhubarb'
  MiniDeps.add 'tpope/vim-sleuth'
  MiniDeps.add 'mbbill/undotree'
  MiniDeps.add 'christoomey/vim-tmux-navigator'

  vim.keymap.set('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>')
  vim.keymap.set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>')
  vim.keymap.set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>')
  vim.keymap.set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>')
end)

MiniDeps.now(function()
  MiniDeps.add {
    source = 'mason-org/mason.nvim',
    hooks = { post_checkout = function() vim.cmd 'MasonUpdate' end },
  }

  require('mason').setup()

  MiniDeps.later(function()
    local mr = require 'mason-registry'

    mr.refresh(function()
      for _, tool in ipairs {
        -- Formatters
        'stylua',
        'prettier',

        -- Language servers
        'biome',
        'css-lsp', -- cssls
        'eslint-lsp', -- eslint
        'lua-language-server', -- lua_ls
        'pyright',
        'rubocop',
        'ruby-lsp', -- ruby_lsp
        'ruff',
        'stimulus-language-server', -- stimulus_ls
        'typescript-language-server', -- ts_ls

        -- Awaiting for a stable release
        'pyrefly', -- https://github.com/facebook/pyrefly
        'ty', -- https://github.com/astral-sh/ty
      } do
        local p = mr.get_package(tool)
        if not p:is_installed() then p:install() end
      end
    end)
  end)
end)

MiniDeps.now(function()
  MiniDeps.add {
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = { post_checkout = function() vim.cmd 'TSUpdate' end },
  }

  local parsers = {
    'c',
    'lua',
    'prisma',
    'vim',
    'vimdoc',
    'query',
    'markdown',
    'markdown_inline',
    'javascript',
    'typescript',
    'tsx',
    'ruby',
    'python',
  }

  require('nvim-treesitter').install(parsers)

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('crnvl96-treesitter', {}),
    pattern = vim.tbl_deep_extend('force', parsers, { 'codecompanion' }),
    callback = function() vim.treesitter.start() end,
  })
end)

MiniDeps.later(function()
  MiniDeps.add 'MagicDuck/grug-far.nvim'

  require('grug-far').setup {}
end)

MiniDeps.later(function()
  -- more information about the Ruby on Rails integration with mcp servers can be found at:
  --  - https://mariochavez.io/desarrollo/rails/ai-tools/development-workflow/2025/06/03/rails-mcp-server-enhanced-documentation-access/
  --  - https://github.com/maquina-app/nvim-mcp-server

  local function build_mcp(params)
    vim.notify('Building mcphub.nvim', vim.log.levels.INFO)

    local obj = vim
      .system(
        { 'npm', 'install', '-g', 'mcp-hub@latest', 'mcp-remote' },
        { cwd = params.path }
      )
      :wait()

    if obj.code == 0 then
      vim.notify('Building mcphub.nvim done', vim.log.levels.INFO)
    else
      vim.notify('Building mcphub.nvim failed', vim.log.levels.ERROR)
    end
  end

  MiniDeps.add {
    source = 'ravitemer/mcphub.nvim',
    hooks = {
      post_install = build_mcp,
      post_checkout = build_mcp,
    },
  }

  MiniDeps.add 'olimorris/codecompanion.nvim'

  require('mcphub').setup {
    config = vim.fn.expand '~/.config/nvim/mcp-servers.json',
  }

  require('codecompanion').setup {
    extensions = {
      mcphub = {
        callback = 'mcphub.extensions.codecompanion',
        opts = {
          show_result_in_chat = true,
          make_vars = true,
          make_slash_commands = true,
        },
      },
    },
    strategies = {
      chat = {
        adapter = require('ai.llms.openai').name,
        keymaps = { completion = { modes = { i = '<C-n>' } } },
        slash_commands = {
          file = { opts = { provider = 'fzf_lua' } },
          buffer = { opts = { provider = 'fzf_lua' } },
        },
      },
    },
    adapters = {
      openai = require('ai.llms.openai').adapter,
      anthropic = require('ai.llms.anthropic').adapter,
      gemini = require('ai.llms.gemini').adapter,
      deepseek = require('ai.llms.deepseek').adapter,
      xai = require('ai.llms.xai').adapter,
      venice = require('ai.llms.venice').adapter,
    },
  }

  vim.keymap.set({ 'n', 'v' }, '<Leader>ca', '<cmd>CodeCompanionActions<cr>')
  vim.keymap.set({ 'n', 'v' }, '<Leader>cc', '<cmd>CodeCompanionChat Toggle<cr>')
  vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>')
end)

MiniDeps.later(function()
  MiniDeps.add 'stevearc/conform.nvim'

  vim.o.formatexpr = 'v:lua.require\'conform\'.formatexpr()'
  vim.g.conform = true

  local function get_root_dir(root_files, bufnr)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    return vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1])
  end

  require('conform').setup {
    notify_on_error = true,
    formatters = {
      injected = {
        ignore_errors = true,
      },
    },
    formatters_by_ft = {
      ['_'] = { 'trim_whitespace', 'trim_newlines' },
      css = { 'prettier' },
      javascript = function(bufnr)
        local biome_root_files = { 'biome.json', 'biome.jsonc' }

        if get_root_dir(biome_root_files, bufnr) then
          return { 'biome', 'biome-check', 'biome-organize-imports' }
        else
          return { 'prettier' }
        end
      end,
      javascriptreact = function(bufnr)
        local biome_root_files = { 'biome.json', 'biome.jsonc' }

        if get_root_dir(biome_root_files, bufnr) then
          return { 'biome', 'biome-check', 'biome-organize-imports' }
        else
          return { 'prettier' }
        end
      end,
      json = { 'prettier' },
      lua = { 'stylua' },
      markdown = { 'prettier', 'injected' },
      python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
      ruby = { 'rubocop' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
    },
    format_on_save = function()
      return vim.g.conform and { timeout_ms = 3000, lsp_format = 'fallback' }
    end,
  }
end)

MiniDeps.later(function()
  MiniDeps.add 'mfussenegger/nvim-lint'

  local lint = require 'lint'

  lint.linters_by_ft = {}

  vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave', 'TextChanged' }, {
    group = vim.api.nvim_create_augroup('crnvl96-try-lint', {}),
    callback = function() lint.try_lint() end,
  })
end)

MiniDeps.later(function()
  MiniDeps.add 'mfussenegger/nvim-dap'
  MiniDeps.add 'mfussenegger/nvim-dap-python'

  local widgets = require 'dap.ui.widgets'
  local frames = function() widgets.sidebar(widgets.frames).open() end
  local scopes = function() widgets.sidebar(widgets.scopes).open() end

  require('dap-python').setup 'uv'
  require('dap-python').test_runner = 'pytest'

  vim.keymap.set('n', '<leader>dpm', require('dap-python').test_method)
  vim.keymap.set('n', '<leader>dpc', require('dap-python').test_class)
  vim.keymap.set('n', '<leader>dps', require('dap-python').debug_selection)

  vim.keymap.set('n', '<leader>db', require('dap').toggle_breakpoint)
  vim.keymap.set('n', '<leader>dc', require('dap').continue)
  vim.keymap.set('n', '<leader>dt', require('dap').terminate)
  vim.keymap.set('n', '<Leader>dr', require('dap').repl.toggle)
  vim.keymap.set({ 'n', 'v' }, '<Leader>dh', require('dap.ui.widgets').hover)
  vim.keymap.set('n', '<Leader>df', frames)
  vim.keymap.set('n', '<Leader>ds', scopes)
end)

MiniDeps.later(function()
  local function build_blink(params)
    vim.notify('Building blink.cmp', vim.log.levels.INFO)

    local obj = vim
      .system({ 'cargo', 'build', '--release' }, { cwd = params.path })
      :wait()

    if obj.code == 0 then
      vim.notify('Building blink.cmp done', vim.log.levels.INFO)
    else
      vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
    end
  end

  MiniDeps.add {
    source = 'Saghen/blink.cmp',
    hooks = {
      post_install = build_blink,
      post_checkout = build_blink,
    },
  }

  require('blink.cmp').setup {
    cmdline = {
      keymap = { preset = 'inherit' },
      completion = { menu = { auto_show = true } },
    },
  }
end)

MiniDeps.later(function()
  MiniDeps.add 'ibhagwan/fzf-lua'

  require('fzf-lua').setup {
    fzf_opts = {
      ['--cycle'] = '',
    },
    winopts = {
      preview = {
        vertical = 'down:45%',
        horizontal = 'right:60%',
        layout = 'flex',
        flip_columns = 150,
      },
    },
    keymap = {
      fzf = {
        ['ctrl-q'] = 'select-all+accept',
        ['ctrl-r'] = 'toggle+down',
        ['ctrl-e'] = 'toggle+up',
        ['ctrl-a'] = 'select-all',
        ['ctrl-o'] = 'toggle-all',
        ['ctrl-u'] = 'half-page-up',
        ['ctrl-d'] = 'half-page-down',
        ['ctrl-x'] = 'jump',
        ['ctrl-f'] = 'preview-page-down',
        ['ctrl-b'] = 'preview-page-up',
      },
      builtin = {
        ['<c-f>'] = 'preview-page-down',
        ['<c-b>'] = 'preview-page-up',
      },
    },
  }

  require('fzf-lua').register_ui_select()

  vim.keymap.set(
    'n',
    '<Leader>f',
    function()
      require('fzf-lua').files {
        fd_opts = [[--color=never --hidden --type f --type l --exclude .git --exclude __init__.py]],
      }
    end
  )
  vim.keymap.set('n', '<Leader>l', function() require('fzf-lua').blines() end)
  vim.keymap.set('n', '<Leader>g', function() require('fzf-lua').live_grep() end)
  vim.keymap.set('x', '<Leader>g', function() require('fzf-lua').grep_visual() end)
  vim.keymap.set('n', '<Leader>b', function() require('fzf-lua').buffers() end)
  vim.keymap.set('n', '<Leader>\'', function() require('fzf-lua').resume() end)
  vim.keymap.set('n', '<Leader>x', function() require('fzf-lua').quickfix() end)
end)

MiniDeps.later(function()
  local minifiles = require 'mini.files'

  local function map_split(bufnr, lhs, direction)
    local function rhs()
      local window = minifiles.get_explorer_state().target_window

      if window == nil or minifiles.get_fs_entry().fs_type == 'directory' then
        return
      end

      local new_target_window
      vim.api.nvim_win_call(window, function()
        vim.cmd(direction .. ' split')
        new_target_window = vim.api.nvim_get_current_win()
      end)

      minifiles.set_target_window(new_target_window)
      minifiles.go_in { close_on_file = true }
    end

    vim.keymap.set(
      'n',
      lhs,
      rhs,
      { buffer = bufnr, desc = 'Split ' .. string.sub(direction, 12) }
    )
  end

  minifiles.setup {
    mappings = {
      show_help = '?',
      go_in_plus = '<CR>',
      go_out_plus = '-',
      go_in = '',
      go_out = '',
    },
  }

  vim.keymap.set('n', '-', function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local path = vim.fn.fnamemodify(bufname, ':p')
    if path and vim.uv.fs_stat(path) then minifiles.open(bufname, false) end
  end)

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    group = vim.api.nvim_create_augroup('crnvl96-minifiles', {}),
    callback = function(e)
      local bufnr = e.data.buf_id
      map_split(bufnr, '<C-w>s', 'belowright horizontal')
      map_split(bufnr, '<C-w>v', 'belowright vertical')
    end,
  })
end)
