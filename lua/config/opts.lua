vim.g.diagnostic_icons = {
    ERROR = ' ',
    WARN = ' ',
    HINT = ' ',
    INFO = ' ',
}

vim.g.palette = {
    base00 = '#181818',
    base01 = '#282828',
    base02 = '#383838',
    base03 = '#585858',
    base04 = '#b8b8b8',
    base05 = '#d8d8d8',
    base06 = '#e8e8e8',
    base07 = '#f8f8f8',
    base08 = '#ab4642',
    base09 = '#dc9656',
    base0A = '#f7ca88',
    base0B = '#a1b56c',
    base0C = '#86c1b9',
    base0D = '#7cafc2',
    base0E = '#ba8baf',
    base0F = '#a16946',
}

vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.whoami = 'crnvl96'
vim.g.bigfile_size = 1024 * 250
vim.g.relative_nr = true

vim.o.guicursor = ''
vim.o.autoread = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.cursorline = true
vim.o.showcmd = false
vim.o.showmode = false
vim.o.ruler = false
vim.o.laststatus = 0
vim.o.foldcolumn = '0'
vim.o.foldenable = false
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.o.swapfile = false
vim.o.virtualedit = 'block'
vim.o.splitkeep = 'screen'
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.scrolloff = 8
vim.o.sidescrolloff = 4
vim.o.breakindent = true
vim.o.smartindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.mouse = 'a'
vim.o.number = true
vim.o.relativenumber = vim.g.relative_nr
vim.o.clipboard = 'unnamedplus'
vim.o.signcolumn = 'yes'
vim.o.fillchars = 'eob: '
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.updatetime = 300
vim.o.timeoutlen = 1000
vim.o.backup = false
vim.o.writebackup = false
vim.o.wrap = false
vim.o.linebreak = true
vim.o.wildignorecase = true
vim.o.background = 'dark'
-- vim.o.background = 'light'
vim.o.statusline = "%{repeat('─',winwidth('.'))}"

vim.opt.diffopt:append('linematch:60')
vim.opt.wildoptions:append('fuzzy')
vim.opt.path:append('**')
vim.opt.wildignore:append('*/node_modules/*,*/dist/*')

if vim.fn.executable('rg') ~= 0 then vim.o.grepprg = 'rg --vimgrep' end

vim.cmd('packadd cfilter')
