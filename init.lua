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

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Default nodejs path for nvim
local node_bin = vim.env.HOME .. '/.local/share/mise/installs/node/24.12.0/bin'
vim.env.PATH = node_bin .. ':' .. vim.env.PATH
vim.g.node_host_prog = node_bin .. '/node'

-- stylua: ignore start
vim.o.mouse = 'a'                                   -- Enable mouse in all modes
vim.o.mousescroll = 'ver:1,hor:2'                   -- Make mouse scroll more smoothly
vim.o.undofile = true                               -- Persistent undo
vim.o.laststatus = 0                                -- No statusline
vim.o.clipboard = 'unnamedplus'                     -- Sync with system clipboard
vim.o.swapfile = false                              -- Disable swap
vim.o.breakindent = true                            -- Keep line breaks visually indented
vim.o.linebreak = true                              -- Break lines at word boundaries
vim.o.number = true                                 -- Enable line numbers
vim.o.relativenumber = true                         -- Make line numbers relative
vim.o.signcolumn = 'yes'                            -- Keep signcol always visible
vim.o.splitbelow = true                             -- Prever below splits
vim.o.splitright = true                             -- Prefer right splits
vim.o.winborder = 'single'                          -- Prefer 'single' borders
vim.o.wrap = false                                  -- Don't auto break lines
vim.o.scrolloff = 8                                 -- Vertical cursor margin
vim.o.autoindent = true                             -- Keep indenting of current line when starting a new line 
vim.o.expandtab = true                              -- Convert tabs into spaces
vim.o.ignorecase = true                             -- Ignore case in search patterns
vim.o.incsearch = true                              -- Show pattern matches gradually when typing
vim.o.infercase = true                              -- Smart case guessing algorithm on completion
vim.o.shiftwidth = 4                                -- How many spaces each step of indentation counts for
vim.o.smartcase = true                              -- Override 'ignorecase' if pattern contains upper case chars
vim.o.smartindent = true                            -- Smarter indenting
vim.o.tabstop = 4                                   -- How many spaces a tab count for
vim.o.virtualedit = 'block'                         -- Allow rectangle selection of text
vim.o.completeopt = 'menuone,noselect,fuzzy,nosort' -- Completion options
-- stylua: ignore end

-- Enable all filetype plugins and syntax (if not enabled, for better startup)
vim.cmd 'filetype plugin indent on'
if vim.fn.exists 'syntax_on' ~= 1 then vim.cmd 'syntax enable' end

-- Set diagnostic configurations
vim.diagnostic.config {
  signs = { priority = 9999, severity = { min = 'HINT', max = 'ERROR' } },
  underline = { severity = { min = 'WARN', max = 'ERROR' } },
  virtual_text = { current_line = true, severity = { min = 'ERROR', max = 'ERROR' } },
  virtual_lines = false,
  update_in_insert = false,
}

MiniDeps.add 'sainnhe/gruvbox-material'
MiniDeps.add 'MagicDuck/grug-far.nvim'
MiniDeps.add 'stevearc/conform.nvim'
MiniDeps.add 'tpope/vim-fugitive'
MiniDeps.add 'neovim/nvim-lspconfig'
MiniDeps.add { source = 'nvim-treesitter/nvim-treesitter-textobjects', checkout = 'main' }
MiniDeps.add {
  source = 'nvim-treesitter/nvim-treesitter',
  checkout = 'main',
  hooks = { post_checkout = function() vim.cmd 'TSUpdate' end },
}

-- local build = function(args)
--   local obj = vim.system({ 'cd', './app/', '&&', 'npm install' }, { text = true }):wait()
--   vim.print(vim.inspect(obj))
-- end

MiniDeps.add { source = 'iamcco/markdown-preview.nvim' }

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-highlight-on-yank', {}),
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('crnvl96-on-lspattach', {}),
  callback = function(ev) vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end,
})

-- stylua: ignore
local languages = {
  -- note: parsers for c, lua, vim, vimdoc, query and markdown are already included in neovim
  'bash', 'css', 'diff', 'go', 'html',
  'javascript', 'json', 'python', 'regex',
  'toml', 'tsx', 'typescript', 'yaml',
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

vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_better_performance = 1

vim.cmd.colorscheme 'gruvbox-material'

require('mini.extra').setup()
require('mini.comment').setup()
require('mini.move').setup()
require('mini.cmdline').setup()
require('mini.align').setup()
require('mini.keymap').setup()
require('mini.misc').setup()
require('mini.colors').setup()
require('mini.pick').setup()
require('mini.visits').setup()
require('grug-far').setup()

MiniMisc.setup_auto_root()
MiniMisc.setup_restore_cursor()

MiniColors.get_colorscheme()
  :add_transparency({
    general = true,
    float = true,
    statuscolumn = true,
    statusline = true,
    tabline = true,
    winbar = true,
  })
  :apply()

require('mini.jump2d').setup {
  spotter = require('mini.jump2d').gen_spotter.pattern '[^%s%p]+',
  labels = 'fjdkslah',
  view = { dim = true, n_steps_ahead = 2 },
  mappings = { start_jumping = '' },
}

require('mini.ai').setup {
  custom_textobjects = {
    g = MiniExtra.gen_ai_spec.buffer(),
    f = require('mini.ai').gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
    c = require('mini.ai').gen_spec.treesitter { a = '@comment.outer', i = '@comment.inner' },
    o = require('mini.ai').gen_spec.treesitter { a = '@conditional.outer', i = '@conditional.inner' },
    l = require('mini.ai').gen_spec.treesitter { a = '@loop.outer', i = '@loop.inner' },
  },
  search_method = 'cover',
}

require('mini.hipatterns').setup {
  highlighters = {
    fixme = MiniExtra.gen_highlighter.words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
    hack = MiniExtra.gen_highlighter.words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
    todo = MiniExtra.gen_highlighter.words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
    note = MiniExtra.gen_highlighter.words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
    hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
  },
}

require('mini.clue').setup {
  clues = {
    { mode = 'n', keys = '<Leader>e', desc = '+Explore/Edit' },
    { mode = 'n', keys = '<Leader>f', desc = '+Find' },
    { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
    { mode = 'x', keys = '<Leader>l', desc = '+LSP' },
    require('mini.clue').gen_clues.builtin_completion(),
    require('mini.clue').gen_clues.g(),
    require('mini.clue').gen_clues.marks(),
    require('mini.clue').gen_clues.registers(),
    require('mini.clue').gen_clues.windows { submode_resize = true },
    require('mini.clue').gen_clues.z(),
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

require('mini.completion').setup {
  lsp_completion = {
    source_func = 'omnifunc',
    auto_setup = false,
    process_items = function(items, base)
      return MiniCompletion.default_process_items(items, base, { kind_priority = { Text = -1, Snippet = -1 } })
    end,
  },
}

vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })
vim.lsp.enable { 'lua_ls', 'pyright', 'ruff' }

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

require('conform').setup {
  notify_on_error = false,
  notify_no_formatters = false,
  default_format_opts = {
    lsp_format = 'fallback',
    timeout_ms = 1000,
  },
  formatters = {
    stylua = { require_cwd = true },
  },
  formatters_by_ft = {
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
    python = { 'ruff_organize_imports', 'ruff_fix', 'ruff_format' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier', timeout_ms = 1500 },
    lua = { 'stylua' },
  },
  format_on_save = function()
    if not vim.g.autoformat then return nil end
    return {}
  end,
}

vim.g.autoformat = true

MiniKeymap.map_combo({ 'i', 'c', 'x', 's' }, 'jk', '<BS><BS><Esc><Cmd>noh<CR><Esc>')
MiniKeymap.map_combo({ 'i', 'c', 'x', 's' }, 'kj', '<BS><BS><Esc><Cmd>noh<CR><Esc>')
MiniKeymap.map_combo('n', 'jk', '<Esc><Cmd>noh<CR><Esc>')
MiniKeymap.map_combo('n', 'kj', '<Esc><Cmd>noh<CR><Esc>')
MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
MiniKeymap.map_multistep('i', '<C-n>', { 'pmenu_next' })
MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
MiniKeymap.map_multistep('i', '<C-p>', { 'pmenu_prev' })
MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept' })

vim.keymap.set({ 'i', 'c', 'x', 's', 'n', 'o' }, '<C-x>', ':')
vim.keymap.set({ 'i', 'c', 'x', 's', 'n', 'o' }, '<C-s>', '<Esc><Cmd>noh<CR><Cmd>w!<CR><Esc>')
vim.keymap.set({ 'i', 'c', 'x', 's', 'n', 'o' }, '<Esc>', '<Esc><Cmd>noh<CR><Esc>', { noremap = true })
vim.keymap.set('v', 'p', 'P')
vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Focus on left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Focus on below window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Focus on above window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Focus on right window' })
vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-Up>', '<Cmd>resize +5<CR>')
vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center' })
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', '*', '*zz')
vim.keymap.set('n', '#', '#zz')
vim.keymap.set('n', 'g*', 'g*zz')
vim.keymap.set('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
vim.keymap.set('n', 'E', '<Cmd>lua vim.diagnostic.open_float()<CR>')
vim.keymap.set('i', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
vim.keymap.set('n', '<leader>ed', '<Cmd>lua MiniFiles.open()<CR>', { desc = 'Directory' })
vim.keymap.set('n', '<leader>ef', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', { desc = 'File' })
vim.keymap.set('n', '<leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'Actions' })
vim.keymap.set('n', '<leader>ld', '<Cmd>Pick lsp scope="definition"<CR>', { desc = 'Source definition' })
vim.keymap.set('n', '<leader>lf', '<Cmd>lua require("conform").format({lsp_fallback=true})<CR>', { desc = 'Format' })
vim.keymap.set('n', '<leader>lf', '<Cmd>lua require("conform").format({lsp_fallback=true})<CR>', { desc = 'Format' })
vim.keymap.set('n', '<leader>li', '<Cmd>Pick lsp scope="implementation"<CR>', { desc = 'Implementation' })
vim.keymap.set('n', '<leader>ln', '<Cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'Rename' })
vim.keymap.set('n', '<leader>lr', '<Cmd>Pick lsp scope="references"<CR>', { desc = 'References' })
vim.keymap.set('n', '<leader>lS', '<Cmd>Pick lsp scope="workspace_symbol"<CR>', { desc = 'Symbols workspace' })
vim.keymap.set('n', '<leader>ly', '<CmdPick lsp scope="type_definition"<CR>', { desc = 'Type definition' })
vim.keymap.set('n', '<leader>ls', '<Cmd>Pick lsp scope="document_symbol"<CR>', { desc = 'Symbols document' })
vim.keymap.set('n', '<leader>lX', '<Cmd>Pick diagnostic scope="all"<CR>', { desc = 'Diagnostic workspace' })
vim.keymap.set('n', '<leader>lx', '<Cmd>Pick diagnostic scope="current"<CR>', { desc = 'Diagnostic buffer' })
vim.keymap.set('n', '<leader>fH', '<Cmd>Pick hl_groups<CR>', { desc = 'Highlight groups' })
vim.keymap.set('n', '<leader>fb', '<Cmd>Pick buffers<CR>', { desc = 'Buffers' })
vim.keymap.set('n', '<leader>ff', '<Cmd>Pick files<CR>', { desc = 'Files' })
vim.keymap.set('n', '<leader>fg', '<Cmd>Pick grep_live<CR>', { desc = 'Grep live' })
vim.keymap.set('n', '<leader>fh', '<Cmd>Pick help<CR>', { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fl', '<Cmd>Pick buf_lines scope="current"<CR>', { desc = 'Lines (buf)' })
vim.keymap.set('n', '<leader>fo', '<Cmd>Pick oldfiles<CR>', { desc = 'Oldfiles' })
vim.keymap.set('n', '<leader>fr', '<Cmd>Pick resume<CR>', { desc = 'Resume' })
vim.keymap.set('n', '<leader>fv', '<Cmd>Pick visit_paths<CR>', { desc = 'Visits' })
vim.keymap.set('n', '<leader>gS', '<Cmd>Pick git_hunks scope="staged"<CR>', { desc = 'Status (staged)' })
vim.keymap.set('n', '<leader>gb', '<Cmd>Pick git_branches<CR>', { desc = 'Branches' })
vim.keymap.set('n', '<leader>gc', '<Cmd>Pick git_commits<CR>', { desc = 'Commits' })
vim.keymap.set('n', '<leader>gs', '<Cmd>Pick git_hunks<CR>', { desc = 'Status' })
vim.keymap.set('n', [[\f]], function() vim.g.autoformat = not vim.g.autoformat end, { desc = 'Toggle Autofmt' })
vim.keymap.set({ 'n', 'x', 'o' }, 's', function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end)
