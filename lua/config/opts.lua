vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

vim.o.backup = false
vim.o.swapfile = false
vim.o.mouse = 'a'
vim.o.guicursor = ''
vim.o.switchbuf = 'usetab'
vim.o.writebackup = false
vim.o.undofile = true
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.cursorline = true
vim.o.laststatus = 2
vim.o.linebreak = true
vim.o.number = true
vim.o.autoread = true
vim.o.relativenumber = true
vim.o.ruler = false
vim.o.showmode = false
vim.o.showtabline = 0
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.cmdheight = 1
vim.o.scrolloff = 8
vim.o.cursorlineopt = 'screenline,number'
vim.o.breakindentopt = 'list:-1'
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.formatoptions = 'rqnl1j'
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.infercase = true
vim.o.shiftwidth = 2
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.virtualedit = 'block'
vim.o.timeoutlen = 1000
vim.o.signcolumn = 'yes'
vim.o.foldmethod = 'indent'
vim.o.foldlevel = 1
vim.o.foldnestmax = 10
vim.o.foldlevelstart = 99
vim.o.foldtext = ''
vim.o.splitkeep = 'screen'
vim.o.shortmess = 'aoOWFcSC'

vim.opt.completeopt:append('fuzzy')
vim.opt.diffopt:append('linematch:60')

if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end
if vim.fn.executable('rg') ~= 0 then vim.o.grepprg = 'rg --vimgrep' end

vim.cmd('filetype plugin indent on')
vim.cmd('packadd cfilter')

vim.diagnostic.config({ signs = false })

vim.filetype.add({
    pattern = {
        ['.*'] = {
            function(path, buf)
                return vim.bo[buf]
                        and vim.bo[buf].filetype ~= 'bigfile'
                        and path
                        and vim.fn.getfsize(path) > 1024 * 250
                        and 'bigfile'
                    or nil
            end,
        },
    },
})
