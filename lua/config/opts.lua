vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.whoami = 'crnvl96'
vim.g.bigfile_size = 1024 * 250

vim.o.autoread = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.cursorline = true
vim.o.guicursor = ''
vim.o.showcmd = false
vim.o.showmode = false
vim.o.ruler = false
vim.o.laststatus = 0
vim.o.foldcolumn = '0'
vim.o.foldenable = false
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
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
vim.o.relativenumber = true
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
vim.o.statusline = "%{repeat('─',winwidth('.'))}"
vim.o.signcolumn = 'number'

vim.opt.diffopt:append('linematch:60')
vim.opt.wildoptions:append('fuzzy')
vim.opt.path:append('**')
vim.opt.wildignore:append('*/node_modules/*,*/dist/*')
vim.opt.completeopt:append('menuone,noinsert,noselect,popup,fuzzy')

if vim.fn.executable('rg') ~= 0 then vim.o.grepprg = 'rg --vimgrep' end

vim.cmd('packadd cfilter')
