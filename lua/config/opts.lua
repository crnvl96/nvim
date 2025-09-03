vim.diagnostic.config({
  update_in_insert = true,
  virtual_text = {
    current_line = true,
  },
  virtual_lines = false,
  float = { source = true },
  signs = true,
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.o.background = 'dark'
vim.o.completeopt = 'menuone,noselect,noinsert'
vim.o.cursorline = false
vim.o.expandtab = true
vim.o.foldcolumn = '1'
vim.o.foldlevelstart = 99
vim.o.foldtext = ''
vim.o.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-TermCursor'
vim.o.ignorecase = true
vim.o.laststatus = 2
vim.o.linebreak = true
vim.o.list = true
vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:3,hor:0'
vim.o.number = true
vim.o.pumheight = 15
vim.o.relativenumber = true
vim.o.clipboard = 'unnamed'
vim.o.ruler = false
vim.o.scrolloff = 8
vim.o.shiftwidth = 4
vim.o.showcmd = false
vim.o.sidescrolloff = 24
vim.o.signcolumn = 'yes'
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.timeoutlen = 1000
vim.o.ttimeoutlen = 10
vim.o.undofile = true
vim.o.updatetime = 300
vim.o.virtualedit = 'block'
vim.o.wildignorecase = true
vim.o.wildmode = 'noselect:longest:lastused,full'
vim.o.wildmenu = true
vim.o.winborder = 'rounded'
vim.o.wrap = false
vim.o.writebackup = false

vim.cmd('packadd cfilter')
vim.cmd('filetype plugin indent on')

vim.o.wildmode = 'noselect:lastused,full'

vim.o.diffopt =
  'internal,filler,closeoff,context:4,algorithm:histogram,linematch:60,indent-heuristic,vertical,context:99'
vim.o.listchars = 'tab:  ,trail:.'
vim.o.fillchars = 'eob: ,fold: ,foldclose:,foldopen:,foldsep: ,msgsep:─'
vim.o.wildignore = vim.o.wildignore .. ',.DS_Store'
vim.o.wildoptions = vim.o.wildoptions .. ',fuzzy'
vim.o.shortmess = vim.o.shortmess .. 'Wsa'
