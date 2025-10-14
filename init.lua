_G.Config = {}

local r = function(m) require('user.' .. m) end
local gr = vim.api.nvim_create_augroup('custom-config', {})

_G.Config.new_autocmd = function(event, pattern, callback)
    local opts = { group = gr, pattern = pattern, callback = callback }
    vim.api.nvim_create_autocmd(event, opts)
end

local path = vim.env.HOME .. '/.local/share/mise/installs/node/24.9.0/bin/'
vim.env.PATH = path .. ':' .. vim.env.PATH

vim.g.node_host_prog = path .. 'node'
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.o.autoindent = true
vim.o.iskeyword = '@,48-57,_,192-255,-' -- Treat dash as `word` textobject part
vim.o.autoread = true
vim.o.autowrite = true
vim.o.breakindent = true
vim.o.breakindentopt = 'list:-1'
vim.o.colorcolumn = '+1'
vim.o.clipboard = 'unnamedplus'
vim.o.cursorline = true
vim.o.cursorlineopt = 'screenline,number'
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.infercase = true
vim.o.linebreak = true
vim.o.list = true
vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:3,hor:0'
vim.o.number = true
vim.o.laststatus = 2
vim.o.relativenumber = true
vim.o.ruler = false
vim.o.scrolloff = 8
vim.o.shiftround = true
vim.o.shiftwidth = 4
vim.o.showcmd = false
vim.o.showmode = false
vim.o.sidescrolloff = 24
vim.o.signcolumn = 'yes'
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.smoothscroll = true
vim.o.splitbelow = true
vim.o.splitkeep = 'screen'
vim.o.splitright = true
vim.o.swapfile = false
vim.o.switchbuf = 'usetab'
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.timeoutlen = 1000
vim.o.ttimeoutlen = 10
vim.o.undofile = true
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h"
vim.o.undolevels = 10000
vim.o.updatetime = 300
vim.o.virtualedit = 'block'
vim.o.winborder = 'double'
vim.o.winminwidth = 5
vim.o.wrap = false
vim.o.writebackup = false
vim.o.shortmess = 'CFOSWaco'
vim.o.textwidth = 80
vim.o.formatoptions = 'rqnl1j'
vim.o.spelloptions = 'camel'
vim.o.pumborder = 'double'

-- Pattern for a start of numbered list (used in `gw`). This reads as
-- "Start of list item is: at least one special character (digit, -, +, *)
-- possibly followed by punctuation (. or `)`) followed by at least one space".
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
local f = function() vim.cmd 'setlocal formatoptions-=c formatoptions-=o' end
_G.Config.new_autocmd('FileType', nil, f)

vim.cmd 'filetype plugin indent on'

r 'keymaps'
r 'pack'
r 'treesitter'
r 'mini'
r 'complete'
r 'lsp'
r 'ui'
r 'picker'
r 'formatter'
