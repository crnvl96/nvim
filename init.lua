local gr = vim.api.nvim_create_augroup('custom-config', {})

local function on_packchanged(name, kinds, callback)
  vim.api.nvim_create_autocmd('PackChanged', {
    group = gr,
    callback = function(e)
      local is_target = e.data.spec.name == name and vim.tbl_contains(kinds, e.data.kind)

      if not is_target then return end

      if not e.data.active then vim.cmd.packadd(name) end

      callback(e)
    end,
  })
end

-- Opts =====

local node_bin = vim.env.HOME .. '/.local/share/mise/installs/node/24/bin'

vim.env.PATH = node_bin .. ':' .. vim.env.PATH
vim.g.node_host_prog = node_bin .. '/node'

-- stylua: ignore start
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader          = ' '
vim.g.maplocalleader     = ','

vim.o.autoindent         = true
vim.o.breakindent        = true
vim.o.clipboard          = 'unnamedplus'
vim.o.cmdheight          = 1
vim.o.completeopt        = 'menu,menuone,popup,fuzzy,noinsert,noselect,nosort'
vim.o.completetimeout    = 100
vim.o.expandtab          = true
vim.o.foldcolumn         = '0'
vim.o.foldlevel          = 10
vim.o.foldlevelstart     = 99
vim.o.foldnestmax        = 10
vim.o.foldtext           = ''
vim.o.ignorecase         = true
vim.o.incsearch          = true
vim.o.infercase          = true
vim.o.laststatus         = 0
vim.o.linebreak          = true
vim.o.mouse              = 'a'
vim.o.mousescroll        = 'ver:1,hor:2'
vim.o.number             = true
vim.o.pumborder          = 'none'
vim.o.pummaxwidth        = 100
vim.o.relativenumber     = true
vim.o.ruler              = false
vim.o.scrolloff          = 8
vim.o.shiftwidth         = 4
vim.o.showcmd            = false
vim.o.signcolumn         = 'yes'
vim.o.smartcase          = true
vim.o.smartindent        = true
vim.o.splitbelow         = true
vim.o.splitright         = true
vim.o.swapfile           = false
vim.o.tabstop            = 4
vim.o.undofile           = true
vim.o.updatetime         = 1000
vim.o.virtualedit        = 'block'
vim.o.wildoptions        = 'pum,tagfile,fuzzy'
vim.o.winborder          = 'single'
vim.o.wrap               = false

vim.cmd('highlight ColorColumn ctermbg=lightgrey guibg=lightgrey')
vim.cmd('filetype plugin indent on')
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

vim.diagnostic.config({
  virtual_lines = false,
  update_in_insert = false,
  signs = {
    priority = 9999,
    severity = {
      min = vim.diagnostic.severity.WARN,
      max = vim.diagnostic.severity.ERROR
    }
  },
  underline = {
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR
    }
  },
  virtual_text = {
    current_line = true,
    severity = {
      min = vim.diagnostic.severity.ERROR,
      max = vim.diagnostic.severity.ERROR
    },
  },
})
-- stylua: ignore end

-- Keymaps =====

local clues = {
  { mode = 'n', keys = '<leader>e', desc = '+Explorer' },
  { mode = 'n', keys = '<leader>f', desc = '+Find' },
  { mode = 'n', keys = '<leader>g', desc = '+Git' },
  { mode = 'n', keys = '<leader>l', desc = '+Lsp' },
  { mode = 'n', keys = '<leader>u', desc = '+Utils' },
  { mode = 'x', keys = '<leader>u', desc = '+Utils' },
}

local set = vim.keymap.set

local nx = { 'n', 'x' }
local nt = { 'n', 't' }
local nix = { 'n', 'i', 'x' }

-- stylua: ignore start
set(nx,  'j',         [[v:count == 0 ? 'gj' : 'j']],                       { expr = true,    desc = 'Go down one visual line' })
set(nx,  'k',         [[v:count == 0 ? 'gk' : 'k']],                       { expr = true,    desc = 'Go up one visual line' })
set(nt,  '<C-Left>',  '<Cmd>vertical resize -20<CR>',                      { noremap = true, desc = 'Decrease window width' })
set(nt,  '<C-Down>',  '<Cmd>resize -5<CR>',                                { noremap = true, desc = 'Decrease window height' })
set(nt,  '<C-Up>',    '<Cmd>resize +5<CR>',                                { noremap = true, desc = 'Increase window height' })
set(nt,  '<C-Right>', '<Cmd>vertical resize +20<CR>',                      { noremap = true, desc = 'Increase window width' })
set(nix, '<Esc>',     '<Esc><Cmd>noh<CR><Esc>',                            { noremap = true, desc = 'Clear hlsearch on <Esc>' })
set(nix, '<C-s>',     '<Esc><Cmd>noh<CR><Cmd>silent! update | redraw<CR>', { noremap = true, desc = 'Save' })
set('n', 'Y',         'yg_',                                               { noremap = true, desc = 'Yank till end of current line' })
set('x', 'p',         'P',                                                 { noremap = true, desc = 'Paste in visual mode without overriding register' })
set('n', '<C-h>',     '<C-w>h',                                            { noremap = true, desc = 'Go to left window' })
set('n', '<C-j>',     '<C-w>j',                                            { noremap = true, desc = 'Go to window below' })
set('n', '<C-k>',     '<C-w>k',                                            { noremap = true, desc = 'Go to window above' })
set('n', '<C-l>',     '<C-w>l',                                            { noremap = true, desc = 'Go to right window' })
set('n', '<C-d>',     '<C-d>zz',                                           { noremap = true, desc = 'Scroll down' })
set('n', '<C-u>',     '<C-u>zz',                                           { noremap = true, desc = 'Scroll up' })
set('c', '<C-f>',     '<Right>',                                           { noremap = true, desc = 'Move cursor to the right char' })
set('c', '<C-b>',     '<Left>',                                            { noremap = true, desc = 'Move cursor to the left char' })
set('c', '<C-a>',     '<Home>',                                            { noremap = true, desc = 'Move cursor to start of line' })
set('c', '<C-e>',     '<End>',                                             { noremap = true, desc = 'Move cursor to end of line' })
set('c', '<C-g>',     '<C-c>',                                             { noremap = true, desc = 'Quit/Exit from cmdline' })
set('c', '<M-h>',     '<C-f>',                                             { noremap = true, desc = 'Access cmdline history' })
set('c', '<M-f>',     '<C-Right>',                                         { noremap = true, desc = 'Move cursor to left word' })
set('c', '<M-b>',     '<C-Left>',                                          { noremap = true, desc = 'Move cursor to right word' })
-- stylua: ignore end

-- Autocmds =====

vim.api.nvim_create_autocmd('TextYankPost', {
  group = gr,
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = gr,
  callback = function()
    if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = gr,
  callback = function(event)
    if event.match:match('^%w%w+:[\\/][\\/]') then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = gr,
  pattern = '[^l]*',
  command = 'cwindow',
})

vim.api.nvim_create_autocmd('VimResized', {
  group = gr,
  callback = function()
    local current_tab = vim.api.nvim_get_current_tabpage()
    vim.cmd('tabdo wincmd =')
    vim.api.nvim_set_current_tabpage(current_tab)
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = gr,
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
  group = gr,
  callback = vim.schedule_wrap(function() vim.cmd.nohlsearch() end),
})

-- Plugins =====

-- Colorscheme =====
vim.pack.add({ 'https://github.com/rose-pine/neovim' })
vim.cmd.colorscheme('rose-pine')

-- Plenary =====
vim.pack.add({ 'https://github.com/nvim-lua/plenary.nvim' })

-- Mini =====

vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

-- Mini.Misc =====
require('mini.misc').setup()

MiniMisc.setup_auto_root()
MiniMisc.setup_restore_cursor()
MiniMisc.setup_termbg_sync()

set('n', '<Leader>ur', '<Cmd>lua MiniMisc.put(MiniMisc.find_root())<CR>', { desc = 'Find current root' })

-- Mini.Extra =====
require('mini.extra').setup()

-- Mini.Ai =====
require('mini.ai').setup({
  search_method = 'cover',
  custom_textobjects = {
    g = MiniExtra.gen_ai_spec.buffer(),
    f = require('mini.ai').gen_spec.treesitter({
      a = '@function.outer',
      i = '@function.inner',
    }),
    t = {
      '<([%p%w]-)%f[^<%w][^<>]->.-</%1>',
      '^<.->().*()</[^/]->$',
    },
  },
})

-- Mini.Align =====
require('mini.align').setup()

-- Mini.Cmdline =====
require('mini.cmdline').setup()

-- Mini.Move =====
require('mini.move').setup()

-- Mini.SplitJoin =====
require('mini.splitjoin').setup()

-- Mini.Surround =====
require('mini.surround').setup()

-- Mini.Bracketed =====
require('mini.bracketed').setup({ indent = { suffix = '', options = {} } })

-- Mini.Hipatterns =====
require('mini.hipatterns').setup({
  highlighters = {
    hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
  },
})

-- Mini.Indentscope =====
require('mini.indentscope').setup({
  options = {
    try_as_border = true,
  },
})

-- Mini.Keymap =====
require('mini.keymap').setup()

MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
MiniKeymap.map_multistep('i', '<BS>', { 'minipairs_bs' })
MiniKeymap.map_multistep('i', '<Tab>', { 'minisnippets_next', 'minisnippets_expand', 'pmenu_next' })
MiniKeymap.map_multistep('i', '<S-Tab>', { 'minisnippets_prev', 'pmenu_prev' })

-- Mini.Pick =====
require('mini.pick').setup({
  source = { show = require('mini.pick').default_show },
  window = { prompt_prefix = ' ' },
})

-- stylua: ignore start
set('n', '<Leader>fb', '<Cmd>Pick buffers<CR>',                                       { desc = 'Buffers' })
set('n', '<Leader>fc', '<Cmd>Pick commands<CR>',                                      { desc = 'Commands' })
set('n', '<Leader>fd', '<Cmd>Pick diagnostic<CR>',                                    { desc = 'Diagnostics' })
set('n', '<Leader>fe', '<Cmd>Pick explorer<CR>',                                      { desc = 'Explorer' })
set('n', '<Leader>ff', '<Cmd>Pick files<CR>',                                         { desc = 'Find Files' })
set('n', '<Leader>fg', '<Cmd>Pick grep_live<CR>',                                     { desc = 'Grep live' })
set('n', '<Leader>fh', "<Cmd>Pick help default_split='vertical'<CR>",                 { desc = 'Help files' })
set('n', '<Leader>fH', '<Cmd>Pick hl_groups<CR>',                                     { desc = 'Highlights' })
set('n', '<Leader>fk', '<Cmd>Pick keymaps<CR>',                                       { desc = 'Keymaps' })
set('n', '<Leader>fl', "<Cmd>Pick buf_lines scope='current' preserve_order=true<CR>", { desc = 'Lines' })
set('n', '<Leader>fm', '<Cmd>Pick manpages<CR>',                                      { desc = 'Search manpages' })
set('n', '<Leader>fo', '<Cmd>Pick visit_paths preserve_order=true<CR>',               { desc = 'Oldfiles' })
set('n', '<Leader>fq', "<Cmd>Pick list scope='quickfix'<CR>",                         { desc = 'Quickfix' })
set('n', '<Leader>fr', '<Cmd>Pick resume<CR>',                                        { desc = 'Resume last picker' })
set('n', '<Leader>fu', '<Cmd>Pick git_hunks<CR>',                                     { desc = 'Git hunks' })
set('n', '<Leader>fU', '<Cmd>Pick git_hunks scope="staged"<CR>',                      { desc = 'Git hunks' })
-- stylua: ignore end

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

-- Mini.Jump2d =====
require('mini.jump2d').setup({
  spotter = require('mini.jump2d').gen_spotter.pattern('[^%s%p]+'),
  view = { dim = true, n_steps_ahead = 2 },
})

-- Mini.Completion =====
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

vim.api.nvim_create_autocmd('LspAttach', {
  group = gr,
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

-- Mini.Files =====
require('mini.files').setup({
  content = { prefix = function() end },
  mappings = {
    go_in = '',
    go_in_plus = '<CR>',
    go_out = '',
    go_out_plus = '-',
  },
  windows = {
    max_number = 1,
    preview = false,
    width_focus = math.floor(vim.o.columns * 1),
    width_nofocus = math.floor(vim.o.columns * 0.59),
    width_preview = math.floor(vim.o.columns * 0.59),
  },
})

set('n', '<Leader>ef', function() MiniFiles.open(vim.api.nvim_buf_get_name(0), false) end, { desc = 'Explorer' })

local filter_show = function() return true end
local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, '.') end

local show_dotfiles = true
local show_preview = false

local toggle_dotfiles = function()
  show_dotfiles = not show_dotfiles
  local new_filter = show_dotfiles and filter_show or filter_hide
  MiniFiles.refresh({ content = { filter = new_filter } })
end

local toggle_preview = function()
  show_preview = not show_preview
  MiniFiles.refresh({
    windows = {
      max_number = show_preview and 2 or 1,
      preview = show_preview and true or false,
      width_focus = math.floor(vim.o.columns * (show_preview and 0.39 or 1)),
    },
  })
end

vim.api.nvim_create_autocmd('User', {
  group = gr,
  pattern = 'MiniFilesBufferCreate',
  callback = function(e)
    local buf_id = e.data.buf_id
    vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id })
    vim.keymap.set('n', 'gp', toggle_preview, { buffer = buf_id })
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesExplorerClose',
  group = gr,
  callback = function()
    show_dotfiles = true
    show_preview = false
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesExplorerOpen',
  group = gr,
  callback = function()
    MiniFiles.set_bookmark('_', vim.fn.getcwd(), { desc = 'Working directory' })
    MiniFiles.set_bookmark('@', vim.env.HOME .. '/Developer', { desc = 'Projects' })
    MiniFiles.set_bookmark('.', vim.env.HOME, { desc = 'Home directory' })
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesWindowUpdate',
  group = gr,
  callback = function(e)
    local config = vim.api.nvim_win_get_config(e.data.win_id)
    config.height = vim.o.lines
    vim.api.nvim_win_set_config(e.data.win_id, config)
  end,
})

-- Mini.Clue =====
require('mini.clue').setup({
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
    clues,
    require('mini.clue').gen_clues.builtin_completion(),
    require('mini.clue').gen_clues.g(),
    require('mini.clue').gen_clues.marks(),
    require('mini.clue').gen_clues.registers(),
    require('mini.clue').gen_clues.square_brackets(),
    require('mini.clue').gen_clues.windows(),
    require('mini.clue').gen_clues.z(),
  },
  window = {
    delay = 500,
    scroll_down = '<C-f>',
    scroll_up = '<C-b>',
    config = { width = 'auto' },
  },
})

-- Lazygit =====
vim.pack.add({ 'https://github.com/kdheepak/lazygit.nvim' })
set('n', '<Leader>gg', '<Cmd>LazyGit<CR>', { desc = 'LazyGit' })

-- SchemaStore =====
vim.pack.add({ 'https://github.com/b0o/SchemaStore.nvim' })

-- Sleuth =====
vim.pack.add({ 'https://github.com/tpope/vim-sleuth' })

-- TS-Autotag =====
vim.pack.add({ 'https://github.com/windwp/nvim-ts-autotag' })
require('nvim-ts-autotag').setup()

-- TS-Comments =====
vim.pack.add({ 'https://github.com/folke/ts-comments.nvim' })

require('ts-comments').setup({
  lang = {
    typst = { '// %s', '/* %s */' },
  },
})

-- Image =====
vim.pack.add({
  'https://github.com/3rd/image.nvim',
  'https://github.com/3rd/diagram.nvim',
})

require('image').setup()

require('diagram').setup({
  integrations = {
    require('diagram.integrations.markdown'),
    require('diagram.integrations.neorg'),
  },
  renderer_options = {
    mermaid = {
      theme = 'forest',
    },
  },
})

-- Treesitter =====
on_packchanged('nvim-treesitter', { 'update' }, function(e)
  MiniMisc.log_add('Updating parsers', { name = e.data.spec.name, path = e.data.path })
  vim.cmd('TSUpdate')
  MiniMisc.log_add('Parsers updates', { name = e.data.spec.name, path = e.data.path })
end)

vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
})

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
  group = gr,
  pattern = pat,
  callback = function(ev) vim.treesitter.start(ev.buf) end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = gr,
  pattern = pat,
  callback = function()
    vim.cmd('setlocal formatoptions-=c formatoptions-=o')

    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'
  end,
})

-- Markdown-Preview =====
on_packchanged('markdown-preview.nvim', { 'install', 'update' }, function(e)
  MiniMisc.log_add('Building dependencies', { name = e.data.spec.name, path = e.data.path })
  local stdout = vim.system({ 'npm', 'install' }, { text = true, cwd = e.data.path .. '/app' }):wait()
  if stdout.code ~= 0 then
    MiniMisc.log_add('Error during dependencies build', { name = e.data.spec.name, path = e.data.path })
  else
    MiniMisc.log_add('Dependencies built', { name = e.data.spec.name, path = e.data.path })
  end
end)

vim.pack.add({ 'https://github.com/iamcco/markdown-preview.nvim' })

-- Mermaid =====
vim.pack.add({ 'https://github.com/kevalin/mermaid.nvim' })

require('mermaid').setup({
  preview = {
    renderer = 'mermaid.js',
  },
})

-- Typst =====
vim.pack.add({ 'https://github.com/chomosuke/typst-preview.nvim' })

require('typst-preview').setup({
  dependencies_bin = { ['tinymist'] = 'tinymist', ['websocat'] = nil },
})

-- Img-Clip =====
vim.pack.add({ 'https://github.com/HakonHarnes/img-clip.nvim' })
require('img-clip').setup({ default = { dir_path = 'static/img' } })

-- Conform =====
vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })

local autoformat = true

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

set('n', '<Leader>uf', function() autoformat = not autoformat end, { desc = 'Toggle autoformat' })

-- LspConfig =====
vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })

-- stylua: ignore
vim.lsp.enable({
  'biome',   'eslint',   'gopls',  'lua_ls', 'oxfmt', 'oxlint',
  'rubocop', 'ruby_lsp', 'ruff',   'tinymist',
  'tsgo',    'ty',       'jsonls', 'yamlls',
  -- 'pyright', 'harper_ls' 'tailwindcss',
})

-- stylua: ignore start
set('n', 'E',     '<Cmd>lua vim.diagnostic.open_float()<CR>',  { desc = 'Open Current Diagnostic' })
set('n', 'K',     '<Cmd>lua vim.lsp.buf.hover()<CR>',          { desc = 'Inspect Current Symbol' })
set('i', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', { desc = 'Show Signature Help' })
set('n', 'g.',    "<Cmd>lua vim.diagnostic.setqflist()<CR>",   { desc = 'Diagnostics' })
set('n', 'gd',    "<Cmd>lua vim.lsp.buf.definition()<CR>",     { desc = 'Definitions' })
-- stylua: ignore end

-- Code-Diff =====
vim.pack.add({ 'https://github.com/esmuellert/codediff.nvim' })

require('codediff').setup({
  diff = {
    layout = 'inline',
    compute_moves = true,
    jump_to_first_change = true,
  },
  explorer = { width = 30 },
})

set('n', '<Leader>gd', '<Cmd>CodeDiff<CR>', { desc = 'Toggle git diff' })

-- Grug-far =====
vim.pack.add({ 'https://github.com/MagicDuck/grug-far.nvim' })

require('grug-far').setup({
  folding = { enabled = false },
  resultLocation = { showNumberLabel = false },
})

set('n', '<Leader>us', function() require('grug-far').open({ transient = true }) end, { desc = 'Grugfar' })
