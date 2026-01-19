local mini_path = vim.fn.stdpath 'data' .. '/site/pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
  vim.cmd 'echo "Installing `mini.nvim`" | redraw'

  local origin = 'https://github.com/nvim-mini/mini.nvim'
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', origin, mini_path }

  vim.fn.system(clone_cmd)
  vim.cmd 'packadd mini.nvim | helptags ALL'
  vim.cmd 'echo "Installed `mini.nvim`" | redraw'
end

require('mini.deps').setup()

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local node_bin = vim.env.HOME .. '/.local/share/mise/installs/node/24.12.0/bin'
local map = function(mode, lhs, rhs, opts) vim.keymap.set(mode, lhs, rhs, opts) end
local nmap = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { desc = desc }) end
local nmap_leader = function(suffix, rhs, desc) vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc }) end
local xmap_leader = function(suffix, rhs, desc) vim.keymap.set('x', '<Leader>' .. suffix, rhs, { desc = desc }) end

MiniDeps.later(
  function()
    vim.diagnostic.config {
      signs = { priority = 9999, severity = { min = 'HINT', max = 'ERROR' } },
      underline = { severity = { min = 'HINT', max = 'ERROR' } },
      virtual_text = { current_line = true, severity = { min = 'ERROR', max = 'ERROR' } },
      virtual_lines = false,
      update_in_insert = false,
    }
  end
)

vim.env.PATH = node_bin .. ':' .. vim.env.PATH

vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.node_host_prog = node_bin .. '/node'

vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:1,hor:2'
vim.o.undofile = true
vim.o.clipboard = 'unnamedplus'
vim.o.swapfile = false
vim.o.breakindent = true
vim.o.cursorline = true
vim.o.linebreak = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.winborder = 'single'
vim.o.wrap = false
vim.o.scrolloff = 8
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.infercase = true
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.virtualedit = 'block'
vim.o.completeopt = 'menuone,noselect,fuzzy,nosort'

vim.cmd 'filetype plugin indent on'
vim.cmd.colorscheme 'minisummer'
if vim.fn.exists 'syntax_on' ~= 1 then vim.cmd 'syntax enable' end

map({ 'i', 'c', 'x', 's', 'n', 'o' }, '<C-x>', ':')
map({ 'i', 'c', 'x', 's', 'n', 'o' }, '<C-s>', '<Esc><Cmd>noh<CR><Cmd>w!<CR><Esc>')
map({ 'i', 'c', 'x', 's', 'n', 'o' }, '<Esc>', '<Esc><Cmd>noh<CR><Esc>', { noremap = true })
map('v', 'p', 'P')
map({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
map({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
map('n', '<C-h>', '<C-w>h', { desc = 'Focus on left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Focus on below window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Focus on above window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Focus on right window' })
map('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
map('n', '<C-Down>', '<Cmd>resize -5<CR>')
map('n', '<C-Up>', '<Cmd>resize +5<CR>')
map('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
nmap('<C-d>', '<C-d>zz', 'Scroll down and center')
nmap('<C-u>', '<C-u>zz', 'Scroll up and center')
nmap('n', 'nzz', '')
nmap('N', 'Nzz', '')
nmap('*', '*zz', '')
nmap('#', '#zz', '')
nmap('g*', 'g*zz', '')

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-highlight-after-yank', {}),
  callback = function() vim.highlight.on_yank() end,
})

later(
  function()
    require('mini.colors')
      .get_colorscheme()
      :add_transparency({
        general = true,
        float = true,
        statuscolumn = true,
        statusline = true,
        tabline = true,
        winbar = true,
      })
      :apply()
  end
)

later(function() require('mini.extra').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.trailspace').setup() end)
later(function() require('mini.move').setup() end)
later(function() require('mini.splitjoin').setup() end)
later(function() require('mini.align').setup() end)
later(function() require('mini.move').setup() end)

later(function()
  require('mini.pick').setup()

  nmap_leader("f'", '<Cmd>Pick resume<CR>', 'Resume')
  nmap_leader('fb', '<Cmd>Pick buffers<CR>', 'Buffers')
  nmap_leader('ff', '<Cmd>Pick files<CR>', 'Files')
  nmap_leader('fg', '<Cmd>Pick grep_live<CR>', 'Grep live')
  nmap_leader('fh', '<Cmd>Pick help<CR>', 'Help tags')
  nmap_leader('fH', '<Cmd>Pick hl_groups<CR>', 'Highlight groups')
  nmap_leader('fl', '<Cmd>Pick buf_lines scope="current"<CR>', 'Lines (buf)')
  nmap_leader('fo', '<Cmd>Pick oldfiles<CR>', 'Oldfiles')
end)

later(function()
  local jump2d = require 'mini.jump2d'

  jump2d.setup {
    spotter = jump2d.gen_spotter.pattern '[^%s%p]+',
    labels = 'fjdkslah',
    view = { dim = true, n_steps_ahead = 2 },
    mappings = { start_jumping = '' },
  }

  map({ 'n', 'x', 'o' }, 's', function() MiniJump2d.start(MiniJump2d.builtin_opts.query) end)
end)

now(function()
  require('mini.misc').setup()

  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
end)

later(function()
  local ai = require 'mini.ai'

  ai.setup {
    custom_textobjects = {
      g = MiniExtra.gen_ai_spec.buffer(),
      f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
    },
    search_method = 'cover',
  }
end)

later(function()
  local hipatterns = require 'mini.hipatterns'
  local hi_words = MiniExtra.gen_highlighter.words

  hipatterns.setup {
    highlighters = {
      fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
      hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
      todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
      note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  }
end)

later(function()
  local miniclue = require 'mini.clue'

  miniclue.setup {
    clues = {
      { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
      { mode = 'n', keys = '<Leader>e', desc = '+Explore/Edit' },
      { mode = 'n', keys = '<Leader>f', desc = '+Find' },
      { mode = 'n', keys = '<Leader>g', desc = '+Git' },
      { mode = 'n', keys = '<Leader>l', desc = '+Language' },
      { mode = 'n', keys = '<Leader>h', desc = '+Misc' },
      { mode = 'x', keys = '<Leader>g', desc = '+Git' },
      { mode = 'x', keys = '<Leader>l', desc = '+Language' },
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows { submode_resize = true },
      miniclue.gen_clues.z(),
    },
    triggers = {
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = '<Localleader>' },
      { mode = 'x', keys = '<Localleader>' },
      { mode = 'n', keys = '\\' },
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' },
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },
    window = {
      config = { width = 'auto' },
      delay = 500,
      scroll_down = '<C-d>',
      scroll_up = '<C-u>',
    },
  }
end)

later(function()
  require('mini.completion').setup {
    delay = {
      completion = 10 ^ 7,
      info = 10 ^ 7,
      signature = 10 ^ 7,
    },
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = function(items, base)
        return MiniCompletion.default_process_items(items, base, { kind_priority = { Text = -1, Snippet = -1 } })
      end,
    },
  }

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('crnvl96-on-lspattach', {}),
    callback = function(ev) vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end,
  })

  vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })
end)

later(function()
  require('mini.files').setup {
    mappings = {
      go_in = '',
      go_in_plus = '<CR>',
      go_out = '',
      go_out_plus = '-',
    },
    windows = {
      preview = true,
      width_focus = 50,
      width_nofocus = 15,
      width_preview = 80,
    },
  }

  nmap_leader('ed', '<Cmd>lua MiniFiles.open()<CR>', 'Directory')
  nmap_leader('ef', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', 'File directory')
end)

later(function()
  require('mini.keymap').setup()

  MiniKeymap.map_combo({ 'i', 'c', 'x', 's' }, 'jk', '<BS><BS><Esc><Cmd>noh<CR><Esc>')
  MiniKeymap.map_combo({ 'i', 'c', 'x', 's' }, 'kj', '<BS><BS><Esc><Cmd>noh<CR><Esc>')

  MiniKeymap.map_combo('n', 'jk', '<Esc><Cmd>noh<CR><Esc>')
  MiniKeymap.map_combo('n', 'kj', '<Esc><Cmd>noh<CR><Esc>')

  MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
  MiniKeymap.map_multistep('i', '<C-n>', { 'pmenu_next' })
  MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
  MiniKeymap.map_multistep('i', '<C-p>', { 'pmenu_prev' })
  MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept' })
end)

later(function()
  add 'tpope/vim-fugitive'

  nmap_leader('gg', ':Git<space>', 'Git')
end)

now(function()
  add {
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = { post_checkout = function() vim.cmd 'TSUpdate' end },
  }

  add {
    source = 'nvim-treesitter/nvim-treesitter-textobjects',
    checkout = 'main',
  }

  local languages = {
    -- note: parsers for c, lua, vim, vimdoc, query and markdown are already included in neovim
    'bash',
    'css',
    'diff',
    'go',
    'html',
    'javascript',
    'json',
    'lisp',
    'python',
    'regex',
    'toml',
    'tsx',
    'typescript',
    'yaml',
  }

  local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0 end
  local to_install = vim.tbl_filter(isnt_installed, languages)

  if #to_install > 0 then require('nvim-treesitter').install(to_install) end

  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('crnvl96-nvim-treesitter', {}),
    pattern = filetypes,
    callback = function(ev) vim.treesitter.start(ev.buf) end,
  })
end)

now(function()
  add 'neovim/nvim-lspconfig'

  vim.lsp.enable {
    'clangd',
    'eslint',
    'lua_ls',
    'pyright',
    'ruff',
    'gopls',
    'ts_ls',
  }

  map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
  map('n', 'E', '<Cmd>lua vim.diagnostic.open_float()<CR>')
  map('i', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')

  nmap_leader('la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', 'Actions')
  nmap_leader('ld', '<Cmd>Pick lsp scope="definition"<CR>', 'Source definition')
  nmap_leader('lf', '<Cmd>lua require("conform").format({lsp_fallback=true})<CR>', 'Format')
  xmap_leader('lf', '<Cmd>lua require("conform").format({lsp_fallback=true})<CR>', 'Format selection')
  nmap_leader('li', '<Cmd>Pick lsp scope="implementation"<CR>', 'Implementation')
  nmap_leader('ln', '<Cmd>lua vim.lsp.buf.rename()<CR>', 'Rename')
  nmap_leader('lr', '<Cmd>Pick lsp scope="references"<CR>', 'References')
  nmap_leader('lS', '<Cmd>Pick lsp scope="workspace_symbol"<CR>', 'Symbols workspace')
  nmap_leader('ly', '<CmdPick lsp scope="type_definition"<CR>', 'Type definition')
  nmap_leader('ls', '<Cmd>Pick lsp scope="document_symbol"<CR>', 'Symbols document')
  nmap_leader('lX', '<Cmd>Pick diagnostic scope="all"<CR>', 'Diagnostic workspace')
  nmap_leader('lx', '<Cmd>Pick diagnostic scope="current"<CR>', 'Diagnostic buffer')
end)

later(function()
  add 'MagicDuck/grug-far.nvim'

  require('grug-far').setup()
end)

later(function()
  add 'stevearc/conform.nvim'

  vim.g.autoformat = true

  require('conform').setup {
    notify_on_error = false,
    notify_no_formatters = false,
    default_format_opts = {
      lsp_format = 'fallback',
      timeout_ms = 1000,
    },
    formatters = {
      stylua = { require_cwd = true },
      prettier = { require_cwd = false },
      injected = { ignore_errors = true },
    },
    formatters_by_ft = {
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      c = { 'clang-format' },
      go = { 'gofumpt' },
      python = { 'ruff_organize_imports', 'ruff_fix', 'ruff_format' },
      json = { 'prettier' },
      jsonc = { 'prettier' },
      lua = { 'stylua' },
      markdown = { 'prettier', 'injected', timeout_ms = 1500 },
      css = { 'prettier' },
      scss = { 'prettier' },
      yaml = { 'prettier' },
      ['_'] = { 'trim_whitespace', 'trim_newlines' },
    },
    format_on_save = function()
      if not vim.g.autoformat then return nil end
      return {}
    end,
  }

  vim.keymap.set(
    'n',
    [[\f]],
    function() vim.g.autoformat = not vim.g.autoformat end,
    { desc = "Toggle 'vim.g.autoformat'" }
  )
end)
