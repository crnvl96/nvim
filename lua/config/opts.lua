vim.g.mapleader = ' ' -- Use <Space> as leader key
vim.g.maplocalleader = ',' -- Use `,` as localleader key
vim.g.whoami = 'crnvl96' -- Default name to use in autocmds
vim.g.bigfile_size = 1024 * 250 -- 250 KB

vim.o.splitbelow = true -- Open new windows below the existing ones
vim.o.splitright = true -- Open new windows to the right the existing ones
vim.o.cursorline = true -- Highlight the current line
vim.o.showcmd = false -- Show current cmd being executed
vim.o.showmode = false -- Show current active mode
vim.o.ruler = false -- Show current cursor position
vim.o.laststatus = 0 -- Show the statusline
vim.o.foldcolumn = '0' -- When and how to draw the foldcolumn. "0": To disable foldcolumn
vim.o.foldenable = false -- When off, all folds are open
vim.o.foldlevel = 99 -- Sets the fold level: Folds with a higher level will be closed
vim.o.foldlevelstart = 99 -- Always starts with no folds closed
vim.o.foldmethod = 'expr' -- 'foldexpr' gives the fold level of a line.
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- Sets treesitter as the fold controller source
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" -- Use conform as formatter tool for `gq`
vim.o.swapfile = false -- Disable swapfile
vim.o.virtualedit = 'block' -- Use `reactangle selection` in visual mode
vim.o.splitkeep = 'screen' -- Remove window scrill in horizontal splits
vim.o.shiftround = true -- Round indent to multiple of 'shiftwidth'
vim.o.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
vim.o.tabstop = 2 -- Sets <Tab> to be equivalent to 2 spaces
vim.o.expandtab = true -- Converts tabs into spaces
vim.o.scrolloff = 8 -- Amount of lines to surround the cursor
vim.o.sidescrolloff = 4 -- Amount of lines to surround the cursor horizontally
vim.o.breakindent = true -- Every wrapped line will continue visually indented
vim.o.smartindent = true
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.infercase = true
vim.o.mouse = 'a'
vim.o.number = true
vim.o.relativenumber = true
vim.o.clipboard = 'unnamedplus'
vim.o.signcolumn = 'yes'
vim.o.fillchars = 'eob: '
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.updatetime = 300
vim.o.timeoutlen = 200
vim.o.backup = false
vim.o.writebackup = false
vim.o.wrap = false
vim.o.wildignorecase = true
vim.o.background = 'dark'

vim.opt.formatoptions:append('l1')
vim.opt.shortmess:append('WcC')
vim.opt.diffopt:append('linematch:60')
vim.opt.wildoptions:append('fuzzy')
vim.opt.path:append('**')
vim.opt.wildignore:append('*/node_modules/*,*/dist/*')
vim.opt.completeopt:append('menuone,noinsert,noselect,popup,fuzzy')

if vim.fn.executable('rg') ~= 0 then vim.o.grepprg = 'rg --vimgrep' end
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

vim.cmd('filetype plugin indent on')
vim.cmd('packadd cfilter')
