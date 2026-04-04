local M = {}

M.set = vim.keymap.set

vim.cmd.packadd([[nvim.difftool]])
vim.cmd.packadd([[nvim.undotree]])
vim.cmd.packadd([[cfilter]])

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_spellfile_plugin = 1

local nx = { 'n', 'x' }
local nxo = { 'n', 'x', 'o' }
local nt = { 'n', 't' }
local nix = { 'n', 'i', 'x' }

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

vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/christoomey/vim-tmux-navigator',
  'https://codeberg.org/andyg/leap.nvim',
  'https://github.com/tpope/vim-sleuth',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/mikavilpas/yazi.nvim',
  'https://github.com/stevearc/conform.nvim',
})

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

vim.api.nvim_create_autocmd('TextYankPost', {
  group = M.gr,
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd({ 'InsertEnter', 'CmdlineEnter' }, {
  group = M.gr,
  callback = vim.schedule_wrap(function() vim.cmd.nohlsearch() end),
})

vim.api.nvim_create_autocmd('BufReadPre', {
  group = M.gr,
  callback = function(e)
    vim.api.nvim_create_autocmd('FileType', {
      buffer = e.buf,
      once = true,
      callback = function()
        if vim.bo.buftype ~= '' then return end

        if vim.tbl_contains({ 'gitcommit', 'gitrebase' }, vim.bo.filetype) then return end

        local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
        if cursor_line > 1 then return end

        local mark_line = vim.api.nvim_buf_get_mark(0, [["]])[1]
        local n_lines = vim.api.nvim_buf_line_count(0)
        if not (1 <= mark_line and mark_line <= n_lines) then return end

        vim.cmd([[normal! g`"zv]])
        vim.cmd([[normal! zz]])
      end,
    })
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = M.gr,
  callback = function(e)
    local bufnr = e.buf
    local filetype = vim.bo[bufnr].ft
    local types = { 'help', 'checkhealth', 'vim', 'fugitive', '' }
    for _, b in ipairs(types) do
      if filetype == b then
        vim.keymap.set('n', 'q', function() vim.api.nvim_command('close') end, { buffer = true })
      end
    end
  end,
})

vim.cmd([[colorscheme miniwinter]])

require('mini.misc').setup()

require('mini.colors')
  .get_colorscheme()
  :add_transparency({
    float = true,
    statuscolumn = true,
  })
  :apply()

require('mini.extra').setup()
require('mini.cmdline').setup()

require('yazi').setup({
  floating_window_scaling_factor = 0.8,
  open_for_directories = true,
  keymaps = { show_help = '`' },
})

require('mini.pick').setup()
require('leap').opts.safe_labels = ''

require('mini.completion').setup({
  lsp_completion = {
    source_func = 'omnifunc',
    auto_setup = false,
    process_items = function(items, base)
      local default = require('mini.completion').default_process_items
      return default(items, base, { kind_priority = { Text = -1, Snippet = -1 } })
    end,
  },
})

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  group = M.gr,
  callback = function()
    vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })
    local servers = vim
      .iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
      :map(function(file) return vim.fn.fnamemodify(file, ':t:r') end)
      :totable()
    vim.lsp.enable(servers)
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = M.gr,
  callback = function(e)
    vim.bo[e.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end
  end,
})

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
    json = { 'oxfmt', lsp_format = 'prefer', name = 'oxfmt', timeout_ms = 1000 },
    jsonc = { 'oxfmt', lsp_format = 'prefer', name = 'oxfmt', timeout_ms = 1000 },
    jsonc5 = { 'oxfmt', lsp_format = 'prefer', name = 'oxfmt', timeout_ms = 1000 },
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
M.set('n', '<Leader>uf', function() autoformat = not autoformat end, { desc = 'Toggle autoformat' })
M.set(nxo, 's', '<Plug>(leap)')
M.set('n', 'S', '<Plug>(leap-from-window)')
M.set('n', '<Leader>gc', '<Cmd>Git commit<CR>', { desc = 'Git commit' })
M.set('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>', { noremap = true, desc = 'Go to left window' })
M.set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>', { noremap = true, desc = 'Go to window below' })
M.set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>', { noremap = true, desc = 'Go to window above' })
M.set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>', { noremap = true, desc = 'Go to right window' })
M.set('n', '<Leader>er', '<Cmd>Yazi toggle<CR>', { desc = 'Yazi (Resume)' })
M.set('n', '<Leader>ef', '<Cmd>Yazi<CR>', { desc = 'Yazi' })
M.set('n', '<Leader>ew', '<Cmd>Yazi cwd<CR>', { desc = 'Yazi (CWD)' })
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
M.set('n', 'E', '<Cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'Open Current Diagnostic' })
M.set('n', 'gre', '<Cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'vim.diagnostic.open_float()' })
M.set('n', 'grx', '<Cmd>lua vim.diagnostic.setqflist()<CR>', { desc = 'vim.diagnostic.setqflist()' })
M.set('n', 'grd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'vim.lsp.buf.definition()' })
