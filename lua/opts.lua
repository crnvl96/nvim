local path = vim.env.HOME .. '/.local/share/mise/installs/node/24.9.0/bin/'
vim.env.PATH = path .. ':' .. vim.env.PATH

vim.g.node_host_prog = path .. 'node'
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.markdown_folding = 1
vim.g.markdown_recommended_style = 0

vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.backup = false
vim.opt.breakindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.cmdheight = 1
vim.opt.completeopt = table.concat({ 'menuone', 'noselect', 'noinsert' }, ',')
vim.opt.conceallevel = 2
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.diffopt = table.concat({
    'internal',
    'filler',
    'closeoff',
    'algorithm:histogram',
    'linematch:60',
    'indent-heuristic',
    'vertical',
    'context:99',
}, ',')
vim.opt.expandtab = true
vim.opt.fillchars = {
    foldopen = '',
    foldclose = '',
    fold = ' ',
    foldsep = ' ',
    diff = '╱',
    eob = ' ',
    horiz = '═',
    horizdown = '╦',
    horizup = '╩',
    vert = '║',
    verthoriz = '╬',
    vertleft = '╣',
    vertright = '╠',
}
vim.opt.foldcolumn = '0'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = 'indent'
vim.opt.foldnestmax = 10
vim.opt.formatoptions = 'jcroqlnt'
vim.opt.ignorecase = true
vim.opt.inccommand = 'nosplit'
vim.opt.incsearch = true
vim.opt.infercase = true
vim.opt.jumpoptions = 'view'
vim.opt.laststatus = 0
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = { extends = '…', nbsp = '␣', precedes = '…', tab = '  ', trail = '·' }
vim.opt.mouse = 'a'
vim.opt.mousescroll = 'ver:6,hor:0'
vim.opt.number = true
vim.opt.pumblend = 10
vim.opt.pumheight = 10
vim.opt.pumheight = 10
vim.opt.relativenumber = true
vim.opt.ruler = false
vim.opt.scrolloff = 8
vim.opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.sidescrolloff = 24
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smoothscroll = true
vim.opt.spelllang = { 'en' }
vim.opt.spelloptions = 'camel'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.switchbuf = 'usetab'
vim.opt.tabstop = 4
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 10
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 300
vim.opt.virtualedit = 'block'
vim.opt.wildignore:append '.DS_Store'
vim.opt.wildignorecase = true
vim.opt.wildmenu = true
vim.o.wildmode = 'noselect:lastused'
vim.opt.winminwidth = 5
vim.opt.wrap = false
vim.opt.writebackup = false

if vim.fn.has 'nvim-0.9' == 1 then
    vim.opt.shortmess = 'CFOSWIaco'
    vim.opt.splitkeep = 'screen'
end

if vim.fn.has 'nvim-0.10' == 1 then
    vim.opt.foldtext = ''
    vim.opt.termguicolors = true
end

if vim.fn.executable 'rg' == 1 then
    vim.opt.grepprg = table.concat({ 'rg', '--vimgrep', '--hidden', '-g', "'.git/*'" }, ' ')
    vim.opt.grepformat = '%f:%l:%c:%m'
end

if vim.fn.has 'nvim-0.11' == 1 then
    vim.opt.completeopt = table.concat({ 'menuone', 'noselect', 'fuzzy', 'nosort' }, ',')
    vim.opt.winborder = 'double'
end

if vim.fn.has 'nvim-0.12' == 1 then
    vim.opt.completefuzzycollect = table.concat({ 'keyword', 'files', 'whole_line' }, ',')
    vim.opt.pummaxwidth = 100
    vim.opt.wildoptions = table.concat({ 'pum', 'fuzzy' }, ',')
end

vim.cmd 'filetype plugin indent on'
vim.cmd 'packadd cfilter'

if vim.fn.exists 'syntax_on' ~= 1 then vim.cmd 'syntax enable' end
if vim.fn.has 'nvim-0.12' == 1 then require('vim._extui').enable { enable = true } end

vim.diagnostic.config {
    update_in_insert = false,
    virtual_lines = false,
    underline = { severity = { min = vim.diagnostic.severity.HINT, max = vim.diagnostic.severity.ERROR } },
    signs = {
        priority = 9999,
        severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.ERROR },
    },
    virtual_text = {
        current_line = true,
        severity = { min = vim.diagnostic.severity.ERROR, max = vim.diagnostic.severity.ERROR },
    },
}
