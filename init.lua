local M = {}

M.set = vim.keymap.set

vim.cmd.packadd([[nvim.difftool]])
vim.cmd.packadd([[nvim.undotree]])
vim.cmd.packadd([[cfilter]])

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_spellfile_plugin = 1

--
-- Pre-Setup
--
M.gr = vim.api.nvim_create_augroup('custom-config', {})

function M.on_packchanged(name, kinds, callback)
  vim.api.nvim_create_autocmd('PackChanged', {
    group = M.gr,
    callback = function(e)
      local is_target = e.data.spec.name == name and vim.tbl_contains(kinds, e.data.kind)
      if not is_target then return end
      if not e.data.active then vim.cmd.packadd(name) end
      callback(e)
    end,
  })
end

vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

local misc = require('mini.misc')
misc.setup()
misc.setup_auto_root()
misc.setup_restore_cursor()
misc.setup_termbg_sync()

vim.cmd([[colorscheme miniwinter]])
require('mini.colors').setup()
MiniColors.get_colorscheme()
  :add_transparency({
    float = true,
    statuscolumn = true,
  })
  :apply()

M.now = function(f) misc.safely('now', f) end
M.later = function(f) misc.safely('later', f) end
M.now_if_args = vim.fn.argc(-1) > 0 and M.now or M.later

--
-- Opts, Keymaps & Autocommands
--
M.now(function()
  local node_bin = vim.env.HOME .. '/.local/share/mise/installs/node/24/bin'
  vim.env.PATH = node_bin .. ':' .. vim.env.PATH
  vim.g.node_host_prog = node_bin .. '/node'

  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','

  vim.o.autoindent = true
  vim.o.breakindent = true
  vim.o.clipboard = 'unnamedplus'
  vim.o.cmdheight = 1
  vim.o.completeopt = 'menu,menuone,popup,fuzzy,noinsert,noselect,nosort'
  vim.o.completetimeout = 100
  vim.o.expandtab = true
  vim.o.foldcolumn = '0'
  vim.o.foldlevel = 10
  vim.o.foldlevelstart = 99
  vim.o.foldnestmax = 10
  vim.o.foldtext = ''
  vim.o.ignorecase = true
  vim.o.incsearch = true
  vim.o.infercase = true
  vim.o.laststatus = 0
  vim.o.linebreak = true
  vim.o.mouse = 'a'
  vim.o.mousescroll = 'ver:1,hor:2'
  vim.o.number = true
  vim.o.pumborder = 'none'
  vim.o.pummaxwidth = 100
  vim.o.relativenumber = true
  vim.o.ruler = false
  vim.o.scrolloff = 8
  vim.o.shiftwidth = 4
  vim.o.switchbuf = 'usetab'
  vim.o.showcmd = false
  vim.o.signcolumn = 'yes'
  vim.o.smartcase = true
  vim.o.smartindent = true
  vim.o.splitbelow = true
  vim.o.splitright = true
  vim.o.swapfile = false
  vim.o.tabstop = 4
  vim.o.undofile = true
  vim.o.updatetime = 1000
  vim.o.virtualedit = 'block'
  vim.o.wildoptions = 'pum,tagfile,fuzzy'
  vim.o.winborder = 'single'
  vim.o.wrap = false

  vim.cmd('highlight ColorColumn ctermbg=lightgrey guibg=lightgrey')
  vim.cmd('filetype plugin indent on')
  if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

  M.later(function()
    local config = vim.diagnostic.config
    config({
      virtual_lines = false,
      update_in_insert = false,
      signs = {
        priority = 9999,
        severity = {
          min = vim.diagnostic.severity.WARN,
          max = vim.diagnostic.severity.ERROR,
        },
      },
      underline = {
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
      },
      virtual_text = {
        current_line = true,
        severity = {
          min = vim.diagnostic.severity.ERROR,
          max = vim.diagnostic.severity.ERROR,
        },
      },
    })
  end)

  local nx = { 'n', 'x' }
  local nt = { 'n', 't' }
  local nix = { 'n', 'i', 'x' }

  M.set(nx, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true, desc = 'Go down one visual line' })
  M.set(nx, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true, desc = 'Go up one visual line' })
  M.set(nt, '<C-Left>', '<Cmd>vertical resize -20<CR>', { noremap = true, desc = 'Decrease window width' })
  M.set(nt, '<C-Down>', '<Cmd>resize -5<CR>', { noremap = true, desc = 'Decrease window height' })
  M.set(nt, '<C-Up>', '<Cmd>resize +5<CR>', { noremap = true, desc = 'Increase window height' })
  M.set(nt, '<C-Right>', '<Cmd>vertical resize +20<CR>', { noremap = true, desc = 'Increase window width' })
  M.set(nix, '<Esc>', '<Esc><Cmd>noh<CR><Esc>', { noremap = true, desc = 'Clear hlsearch on <Esc>' })
  M.set('n', 'Y', 'yg_', { noremap = true, desc = 'Yank till end of current line' })
  M.set('x', 'p', 'P', { noremap = true, desc = 'Paste in visual mode without overriding register' })
  M.set('x', '>', '>gv', { desc = 'Indent' })
  M.set('x', '<', '<gv', { desc = 'Deindent' })
  M.set('n', '<C-h>', '<C-w>h', { noremap = true, desc = 'Go to left window' })
  M.set('n', '<C-j>', '<C-w>j', { noremap = true, desc = 'Go to window below' })
  M.set('n', '<C-k>', '<C-w>k', { noremap = true, desc = 'Go to window above' })
  M.set('n', '<C-l>', '<C-w>l', { noremap = true, desc = 'Go to right window' })
  M.set('n', '<C-d>', '<C-d>zz', { noremap = true, desc = 'Scroll down' })
  M.set('n', '<C-u>', '<C-u>zz', { noremap = true, desc = 'Scroll up' })
  M.set('c', '<C-f>', '<Right>', { noremap = true, desc = 'Move cursor to the right char' })
  M.set('c', '<C-b>', '<Left>', { noremap = true, desc = 'Move cursor to the left char' })
  M.set('c', '<C-a>', '<Home>', { noremap = true, desc = 'Move cursor to start of line' })
  M.set('c', '<C-e>', '<End>', { noremap = true, desc = 'Move cursor to end of line' })
  M.set('c', '<C-g>', '<C-c>', { noremap = true, desc = 'Quit/Exit from cmdline' })
  M.set('c', '<M-h>', '<C-f>', { noremap = true, desc = 'Access cmdline history' })
  M.set('c', '<M-f>', '<C-Right>', { noremap = true, desc = 'Move cursor to left word' })
  M.set('c', '<M-b>', '<C-Left>', { noremap = true, desc = 'Move cursor to right word' })

  M.later(function()
    M.clues = {
      { mode = 'n', keys = '<leader>e', desc = '+Explorer' },
      { mode = 'n', keys = '<leader>f', desc = '+find' },
      { mode = 'n', keys = '<leader>u', desc = '+utils' },
    }

    local clue = require('mini.clue')

    clue.setup({
      triggers = {
        { mode = 'n', keys = '\\' },
        { mode = 'i', keys = '<C-x>' },
        { mode = 'n', keys = '<C-w>' },
        { mode = { 'n', 'x' }, keys = '<Leader>' },
        { mode = { 'n', 'x' }, keys = '[' },
        { mode = { 'n', 'x' }, keys = ']' },
        { mode = { 'n', 'x' }, keys = 'g' },
        { mode = { 'n', 'x' }, keys = "'" },
        { mode = { 'n', 'x' }, keys = '`' },
        { mode = { 'n', 'x' }, keys = '"' },
        { mode = { 'i', 'c' }, keys = '<C-r>' },
        { mode = { 'n', 'x' }, keys = 'z' },
      },
      clues = {
        M.clues,
        clue.gen_clues.builtin_completion(),
        clue.gen_clues.g(),
        clue.gen_clues.marks(),
        clue.gen_clues.registers(),
        clue.gen_clues.square_brackets(),
        clue.gen_clues.windows(),
        clue.gen_clues.z(),
      },
      window = {
        delay = 500,
        scroll_down = '<C-f>',
        scroll_up = '<C-b>',
        config = { width = 'auto' },
      },
    })
  end)

  vim.api.nvim_create_autocmd('TextYankPost', {
    group = M.gr,
    callback = function() vim.highlight.on_yank() end,
  })

  vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    group = M.gr,
    callback = function()
      if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
    end,
  })

  vim.api.nvim_create_autocmd('BufWritePre', {
    group = M.gr,
    callback = function(event)
      if event.match:match('^%w%w+:[\\/][\\/]') then return end
      local file = vim.uv.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
  })

  vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    group = M.gr,
    pattern = '[^l]*',
    command = 'cwindow',
  })

  vim.api.nvim_create_autocmd('VimResized', {
    group = M.gr,
    callback = function()
      local current_tab = vim.api.nvim_get_current_tabpage()
      vim.cmd('tabdo wincmd =')
      vim.api.nvim_set_current_tabpage(current_tab)
    end,
  })

  vim.api.nvim_create_autocmd('BufEnter', {
    group = M.gr,
    callback = function(e)
      local bufnr = e.buf
      local filetype = vim.bo[bufnr].ft
      local types = { 'help', 'checkhealth', 'vim', '' }
      for _, b in ipairs(types) do
        if filetype == b then
          vim.keymap.set('n', 'q', function() vim.api.nvim_command('close') end, { buffer = true })
        end
      end
    end,
  })

  vim.api.nvim_create_autocmd({ 'InsertEnter', 'CmdlineEnter' }, {
    group = M.gr,
    callback = vim.schedule_wrap(function() vim.cmd.nohlsearch() end),
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = M.gr,
    callback = function(e)
      vim.bo[e.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

      local client = vim.lsp.get_client_by_id(e.data.client_id)
      if not client then return end

      if client.name == 'gopls' then
        -- workaround for gopls not supporting semanticTokensProvider
        -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
        if not client.server_capabilities.semanticTokensProvider then
          local semantic = client.config.capabilities.textDocument.semanticTokens
          if not semantic then return end
          client.server_capabilities.semanticTokensProvider = {
            full = true,
            legend = {
              tokenTypes = semantic.tokenTypes,
              tokenModifiers = semantic.tokenModifiers,
            },
            range = true,
          }
        end
      end
    end,
  })
end)

--
-- Specific modules and utilities
--

M.now_if_args(function()
  require('mini.icons').setup()
  M.later(MiniIcons.tweak_lsp_kind)
  M.later(MiniIcons.mock_nvim_web_devicons)

  vim.pack.add({
    'https://github.com/christoomey/vim-tmux-navigator',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/b0o/SchemaStore.nvim',
    'https://codeberg.org/andyg/leap.nvim',
    'https://github.com/tpope/vim-sleuth',
  })

  require('mini.extra').setup()
  require('mini.git').setup()
  require('mini.diff').setup()
  require('mini.cmdline').setup()

  require('leap').opts.preview = function(ch0, ch1, ch2)
    return not (ch1:match('%s') or (ch0:match('%a') and ch1:match('%a') and ch2:match('%a')))
  end

  local clever = require('leap.user').with_traversal_keys
  local nxo = { 'n', 'x', 'o' }
  local opts_fwd = { ['repeat'] = true, opts = clever('<cr>', '<bs>') }
  local opts_backward = { ['repeat'] = true, opts = clever('<bs>', '<cr>'), backward = true }
  M.set(nxo, '<cr>', function() require('leap').leap(opts_fwd) end)
  M.set(nxo, '<bs>', function() require('leap').leap(opts_backward) end)
  M.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
  M.set('n', 'S', '<Plug>(leap-from-window)')

  M.set('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>', { noremap = true, desc = 'Go to left window' })
  M.set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>', { noremap = true, desc = 'Go to window below' })
  M.set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>', { noremap = true, desc = 'Go to window above' })
  M.set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>', { noremap = true, desc = 'Go to right window' })
end)

--
-- Treesitter and Utilities
--
M.now_if_args(function()
  M.on_packchanged('nvim-treesitter', { 'update' }, function(e)
    MiniMisc.log_add('Updating parsers', { name = e.data.spec.name, path = e.data.path })
    vim.cmd('TSUpdate')
    MiniMisc.log_add('Parsers updates', { name = e.data.spec.name, path = e.data.path })
  end)

  vim.pack.add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    'https://github.com/windwp/nvim-ts-autotag',
    'https://github.com/folke/ts-comments.nvim',
  })

  require('nvim-ts-autotag').setup()
  require('ts-comments').setup({ lang = { typst = { '// %s', '/* %s */' } } })

  -- stylua: ignore
  local parsers = {
    -- NOTE: parsers for c, lua, vim, vimdoc, query and markdown are already included in neovim
    'bash',      'c',       'css',   'diff',     'dockerfile', 'git_config', 'git_rebase', 'gitattributes', 'gitcommit',
    'gitignore', 'go',      'gomod', 'gosum',    'gowork',     'html',       'javascript', 'json',          'json5',
    'jsx',       'mermaid', 'lua',   'markdown', 'python',     'regex',      'ruby',       'toml',          'tsx', 'typescript', 'typst',
    'vim',       'vimdoc',  'yaml',  'jsdoc',
  }

  require('nvim-treesitter').install(vim
    .iter(parsers)
    :filter(function(parser)
      local result = vim.api.nvim_get_runtime_file('parser/' .. parser .. '.*', false)
      return #result == 0
    end)
    :flatten()
    :totable())

  local pat = vim
    .iter(parsers)
    :map(function(lang)
      local fts = vim.treesitter.language.get_filetypes(lang)
      return fts
    end)
    :flatten()
    :totable()

  vim.api.nvim_create_autocmd('FileType', {
    group = M.gr,
    pattern = pat,
    callback = function(ev) vim.treesitter.start(ev.buf) end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = M.gr,
    pattern = pat,
    callback = function()
      vim.cmd('setlocal formatoptions-=c formatoptions-=o')
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldmethod = 'expr'
    end,
  })
end)

--
-- Find, Replace & Navigate
--
M.now_if_args(function()
  vim.pack.add({
    'https://github.com/MagicDuck/grug-far.nvim',
    'https://github.com/mikavilpas/yazi.nvim',
  })

  require('yazi').setup({
    floating_window_scaling_factor = 0.8,
    open_for_directories = true,
    keymaps = { show_help = '`' },
  })

  M.set('n', '<Leader>er', '<Cmd>Yazi toggle<CR>', { desc = 'Yazi (Resume)' })
  M.set('n', '<Leader>ef', '<Cmd>Yazi<CR>', { desc = 'Yazi' })
  M.set('n', '<Leader>ew', '<Cmd>Yazi cwd<CR>', { desc = 'Yazi (CWD)' })

  require('grug-far').setup({ disableBufferLineNumbers = false })
  M.set('n', '<Leader>us', function() require('grug-far').open({ transient = true }) end, { desc = 'GrugFar' })

  require('mini.pick').setup()
  M.set('n', '<Leader>f,', '<Cmd>Pick list scope="quickfix"<CR>', { desc = 'Quickfix list' })
  M.set('n', '<Leader>fb', '<Cmd>Pick buffers<CR>', { desc = 'Buffers' })
  M.set('n', '<Leader>fc', '<Cmd>Pick commands<CR>', { desc = 'Commands' })
  M.set('n', '<Leader>fd', '<Cmd>Pick diagnostic<CR>', { desc = 'Diagnostics' })
  M.set('n', '<Leader>fe', '<Cmd>Pick explorer<CR>', { desc = 'Explorer' })
  M.set('n', '<Leader>ff', '<Cmd>Pick files<CR>', { desc = 'Find Files' })
  M.set('n', '<Leader>fg', '<Cmd>Pick grep_live<CR>', { desc = 'Grep live' })
  M.set('n', '<Leader>fh', "<Cmd>Pick help default_split='vertical'<CR>", { desc = 'Help files' })
  M.set('n', '<Leader>fH', '<Cmd>Pick hl_groups<CR>', { desc = 'Highlights' })
  M.set('n', '<Leader>fk', '<Cmd>Pick keymaps<CR>', { desc = 'Keymaps' })
  M.set('n', '<Leader>fl', "<Cmd>Pick buf_lines scope='current' preserve_order=true<CR>", { desc = 'Lines' })
  M.set('n', '<Leader>fm', '<Cmd>Pick manpages<CR>', { desc = 'Search manpages' })
  M.set('n', '<Leader>fo', '<Cmd>Pick visit_paths preserve_order=true<CR>', { desc = 'Oldfiles' })
  M.set('n', '<Leader>fq', "<Cmd>Pick list scope='quickfix'<CR>", { desc = 'Quickfix' })
  M.set('n', '<Leader>fr', '<Cmd>Pick resume<CR>', { desc = 'Resume last picker' })
  M.set('n', '<Leader>fu', '<Cmd>Pick git_hunks<CR>', { desc = 'Git hunks' })
  M.set('n', '<Leader>fU', '<Cmd>Pick git_hunks scope="staged"<CR>', { desc = 'Git hunks' })

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(items, opts, on_choice)
    return MiniPick.ui_select(items, opts, on_choice, {
      window = {
        config = {
          relative = 'cursor',
          anchor = 'NW',
          row = 0,
          col = 0,
          width = 80,
          height = 15,
        },
      },
    })
  end
end)

--
-- Writing and Documenttion
--
M.now_if_args(function()
  M.on_packchanged('markdown-preview.nvim', { 'install', 'update' }, function(e)
    MiniMisc.log_add('Building dependencies', { name = e.data.spec.name, path = e.data.path })
    local stdout = vim.system({ 'npm', 'install' }, { text = true, cwd = e.data.path .. '/app' }):wait()
    if stdout.code ~= 0 then
      MiniMisc.log_add('Error during dependencies build', { name = e.data.spec.name, path = e.data.path })
    else
      MiniMisc.log_add('Dependencies built', { name = e.data.spec.name, path = e.data.path })
    end
  end)

  vim.pack.add({
    'https://github.com/iamcco/markdown-preview.nvim',
    'https://github.com/kevalin/mermaid.nvim',
    'https://github.com/chomosuke/typst-preview.nvim',
    'https://github.com/HakonHarnes/img-clip.nvim',
  })

  require('mermaid').setup({
    preview = {
      renderer = 'mermaid.js',
    },
  })

  require('typst-preview').setup({
    dependencies_bin = {
      ['tinymist'] = 'tinymist',
      ['websocat'] = nil,
    },
  })

  require('img-clip').setup({
    default = { dir_path = 'static/img' },
  })
end)

--
-- Completion LSP and Formatting
--
M.now_if_args(function()
  vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })

  require('mini.completion').setup({
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = function(items, base)
        local default = MiniCompletion.default_process_items
        return default(items, base, { kind_priority = { Text = -1, Snippet = -1 } })
      end,
    },
  })

  vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })

  -- stylua: ignore
  vim.lsp.enable({
    'biome',   'eslint',   'gopls',  'lua_ls', 'oxfmt', 'oxlint',
    'rubocop', 'ruby_lsp', 'ruff',   'tinymist',
    'tsgo',    'ty',       'jsonls', 'yamlls',
    -- 'pyright', 'harper_ls' 'tailwindcss',
  })

  M.set('n', 'E', '<Cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'Open Current Diagnostic' })
  M.set('n', 'gre', '<Cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'vim.diagnostic.open_float()' })
  M.set('n', 'grx', '<Cmd>lua vim.diagnostic.setqflist()<CR>', { desc = 'vim.diagnostic.setqflist()' })
  M.set('n', 'grd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'vim.lsp.buf.definition()' })

  local autoformat = true

  vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })

  require('conform').setup({
    notify_on_error = false,
    notify_no_formatters = false,
    default_format_opts = {
      lsp_format = 'fallback',
      timeout_ms = 1000,
    },
    formatters = {
      stylua = { require_cwd = true },
      prettier = { require_cwd = false },
      oxfmt = { require_cwd = false },
    },
    formatters_by_ft = {
      javascript = { 'oxfmt', lsp_format = 'prefer', timeout_ms = 1000 },
      typescript = { 'oxfmt', lsp_format = 'prefer', timeout_ms = 1000 },
      javascriptreact = { 'oxfmt', lsp_format = 'prefer', timeout_ms = 1000 },
      typescriptreact = { 'oxfmt', lsp_format = 'prefer', timeout_ms = 1000 },
      typst = { 'typstyle', lsp_format = 'prefer', timeout_ms = 1000 },
      go = { 'gofumpt', lsp_format = 'prefer', timeout_ms = 1000 },
      json = {
        'oxfmt',
        lsp_format = 'prefer',
        name = 'oxfmt',
        timeout_ms = 1000,
      },
      jsonc = {
        'oxfmt',
        lsp_format = 'prefer',
        name = 'oxfmt',
        timeout_ms = 1000,
      },
      jsonc5 = {
        'oxfmt',
        lsp_format = 'prefer',
        name = 'oxfmt',
        timeout_ms = 1000,
      },
      css = { 'oxfmt' },
      yaml = { 'oxfmt' },
      markdown = { 'oxfmt', 'injected' },
      python = { 'ruff_organize_imports', 'ruff_fix', 'ruff_format' },
      lua = { 'stylua' },
      ruby = { 'rubocop' },
      ['_'] = { 'trim_whitespace', 'trim_newline' },
    },
    format_on_save = function()
      if not autoformat then return nil end
      return {}
    end,
  })

  M.set('n', '<Leader>uf', function() autoformat = not autoformat end, { desc = 'Toggle autoformat' })
end)
