local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({
  path = {
    package = path_package,
  },
})

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '
  vim.o.mouse = 'a'
  vim.o.clipboard = 'unnamedplus'
  vim.o.undofile = true
  vim.o.number = true
  vim.o.showmode = false
  vim.o.ruler = false
  vim.o.showcmd = false
  vim.o.laststatus = 0
  vim.o.relativenumber = true
  vim.o.signcolumn = 'yes'
  vim.o.splitbelow = true
  vim.o.splitright = true
  vim.o.wrap = false
  vim.o.shiftwidth = 2
  vim.o.tabstop = 2
  vim.o.ignorecase = true
  vim.o.incsearch = true
  vim.o.smartcase = true
  vim.o.scrolloff = 8
  vim.o.sidescrolloff = 8
  vim.o.virtualedit = 'block'
  vim.o.foldlevel = 99
  vim.opt.completeopt:append('fuzzy')
end)

now(function()
  vim.keymap.set('x', 'p', 'P', {
    silent = true,
  })

  vim.keymap.set('n', '<C-Right>', '20<C-w>>', {
    silent = true,
  })

  vim.keymap.set('n', '<C-Left>', '20<C-w><', {
    silent = true,
  })

  vim.keymap.set('n', '<C-Up>', '5<C-w>+', {
    silent = true,
  })

  vim.keymap.set('n', '<C-Down>', '5<C-w>-', {
    silent = true,
  })

  vim.keymap.set('n', '<C-d>', '<C-d>zz', {
    silent = true,
  })

  vim.keymap.set('n', '<C-u>', '<C-u>zz', {
    silent = true,
  })
end)

now(function() vim.cmd.colorscheme('minigrey') end)

now(function() require('mini.extra').setup() end)

later(function() add('tpope/vim-fugitive') end)

now(function()
  local icons = require('mini.icons')

  icons.setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
    end,
  })

  icons.mock_nvim_web_devicons()

  later(icons.tweak_lsp_kind)
end)

now(function()
  local completion = require('mini.completion')

  completion.setup({
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = function(items, base)
        items = vim.tbl_filter(function(x) return x.kind ~= 1 and x.kind ~= 15 end, items)
        return completion.default_process_items(items, base)
      end,
    },
    window = {
      info = { border = 'double' },
      signature = { border = 'double' },
    },
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('crnvl96/on_lsp_attach', {}),
    callback = function(e) vim.bo[e.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end,
  })

  if vim.fn.has('nvim-0.11') == 1 then vim.opt.completeopt:append('fuzzy') end
end)

now(function()
  add({
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
    eslint = { settings = { format = false } },
    vtsls = {},
    lua_ls = {
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = vim.split(package.path, ';'),
          },
          diagnostics = {
            globals = { 'vim' },
            disable = { 'need-check-nil' },
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
end)

now(function()
  add({
    source = 'stevearc/conform.nvim',
    depends = {
      { source = 'williamboman/mason.nvim' },
    },
  })

  local conform = require('conform')

  local get_first_formatter = function(buffer, ...)
    for i = 1, select('#', ...) do
      local formatter = select(i, ...)
      if conform.get_formatter_info(formatter, buffer).available then return formatter end
    end

    return select(1, ...)
  end

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

  conform.setup({
    notify_on_error = false,
    formatters_by_ft = {
      markdown = function(buf) return { get_first_formatter(buf, 'prettierd', 'prettier'), 'injected' } end,
      json = { 'prettierd', 'prettier', stop_after_first = true },
      jsonc = { 'prettierd', 'prettier', stop_after_first = true },
      json5 = { 'prettierd', 'prettier', stop_after_first = true },
      lua = { 'stylua' },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    },
    formatters = {
      injected = {
        options = {
          ignore_errors = true,
        },
      },
    },
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = 'fallback',
    },
  })
end)

later(function()
  local pick = require('mini.pick')

  pick.setup({ window = { config = { border = 'double' } } })
  vim.ui.select = pick.ui_select

  vim.keymap.set('n', '<Leader>ff', '<Cmd>Pick files<CR>', {
    desc = 'Files',
    silent = true,
  })

  vim.keymap.set('n', '<Leader>fg', '<Cmd>Pick grep_live<CR>', {
    desc = 'Grep live',
    silent = true,
  })

  vim.keymap.set('n', '<Leader>fl', '<Cmd>Pick buf_lines scope="current"<CR>', {
    desc = 'Grep live',
    silent = true,
  })

  vim.keymap.set('n', '<Leader>fh', '<Cmd>Pick help<CR>', {
    desc = 'Help',
    silent = true,
  })

  vim.keymap.set('n', '<Leader>ld', '<Cmd>Pick lsp scope="definition"<CR>', {
    desc = 'Lsp definitions',
    silent = true,
  })

  vim.keymap.set('n', '<Leader>lr', '<Cmd>Pick lsp scope="references"<CR>', {
    desc = 'Lsp references',
    silent = true,
  })

  vim.keymap.set('n', '<Leader>ly', '<Cmd>Pick lsp scope="type_definition"<CR>', {
    desc = 'Lsp type definition',
    silent = true,
  })

  vim.keymap.set('n', '<Leader>li', '<Cmd>Pick lsp scope="implementation"<CR>', {
    desc = 'Lsp implementation',
    silent = true,
  })

  vim.keymap.set({ 'n', 'x' }, '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', {
    desc = 'Lsp code actions',
    silent = true,
  })
end)

later(function()
  local files = require('mini.files')

  files.setup({
    windows = {
      preview = true,
    },
    mappings = {
      go_in = '',
      go_in_plus = '<CR>',
      go_out = '',
      go_out_plus = '-',
    },
  })

  vim.api.nvim_create_autocmd('User', {
    group = vim.api.nvim_create_augroup('crnvl96/mini_files', {}),
    pattern = 'MiniFilesWindowOpen',
    callback = function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'double' }) end,
  })

  vim.keymap.set('n', '-', '<Cmd>lua MiniFiles.open()<CR>', {
    desc = 'File explorer',
    silent = true,
  })
end)
