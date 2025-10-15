-- stylua: ignore start

-- Avoid occupying the 'lua' namespace.
-- Since it is shared across all plugins, it might lead to conflicts during
-- require().
local r = function(m) require('user.' .. m) end

-- When entering NojeJS projects that have a local version of Node different
-- from the global one, Neovim usually searches for packages using this local
-- version as reference. We force it to use the global version instead by
-- explicitly setting it on the PATH definition
local path = vim.env.HOME .. '/.local/share/mise/installs/node/24.9.0/bin/'

vim.env.PATH               = path .. ':' .. vim.env.PATH
vim.g.node_host_prog       = path .. 'node'
vim.g.mapleader            = ' '
vim.g.maplocalleader       = ','
vim.o.autoindent           = true
vim.o.autoread             = true
vim.o.autowrite            = true
vim.o.breakindent          = true
vim.o.breakindentopt       = 'list:-1'
vim.o.clipboard            = 'unnamedplus'
vim.o.expandtab            = true
vim.o.formatoptions        = 'rqnl1j'
vim.o.ignorecase           = true
vim.o.incsearch            = true
vim.o.infercase            = true
vim.o.iskeyword            = '@,48-57,_,192-255,-'
vim.o.linebreak            = true
vim.o.mouse                = 'a'
vim.o.mousescroll          = 'ver:3,hor:0'
vim.o.scrolloff            = 8
vim.o.shada                = "'100,<50,s10,:1000,/100,@100,h"
vim.o.shiftround           = true
vim.o.shiftwidth           = 4
vim.o.smartcase            = true
vim.o.smartindent          = true
vim.o.spelloptions         = 'camel'
vim.o.splitbelow           = true
vim.o.splitkeep            = 'screen'
vim.o.splitright           = true
vim.o.swapfile             = false
vim.o.switchbuf            = 'usetab'
vim.o.tabstop              = 4
vim.o.textwidth            = 80
vim.o.timeoutlen           = 1000
vim.o.ttimeoutlen          = 10
vim.o.undofile             = true
vim.o.undolevels           = 10000
vim.o.updatetime           = 300
vim.o.virtualedit          = 'block'
vim.o.cursorline           = true
vim.o.cursorlineopt        = 'screenline,number'
vim.o.laststatus           = 2
vim.o.list                 = true
vim.o.number               = true
vim.o.pumborder            = 'double'
-- vim.o.pumblend             = 10
vim.o.pumheight            = 20
vim.o.relativenumber       = true
vim.o.ruler                = false
vim.o.showcmd              = false
vim.o.showmode             = false
vim.o.signcolumn           = 'yes'
vim.o.shortmess            = 'CFOSWaco'
vim.o.sidescrolloff        = 24
vim.o.smoothscroll         = true
vim.o.termguicolors        = true
vim.o.winborder            = 'double'
vim.o.winminwidth          = 10
vim.o.wrap                 = false
vim.o.writebackup          = false
vim.o.fillchars            = 'foldopen:,foldclose:,fold:╌,foldsep: ,diff:╱,eob:~,horiz:═,horizdown:╦,horizup:╩,vert:║,verthoriz:╬,vertleft:╣,vertright:╠'
vim.opt.listchars          = 'extends:…,nbsp:␣,precedes:…,tab:  ,trail:·'
vim.o.foldlevel            = 10
vim.o.foldmethod           = 'indent'
vim.o.foldnestmax          = 10
vim.o.foldtext             = ''
vim.o.complete             = '.,w,b,kspell'
vim.o.completefuzzycollect = 'keyword,files,whole_line'
vim.o.completeopt          = 'menuone,noselect,fuzzy,nosort'
vim.o.pumheight            = 10
vim.o.pummaxwidth          = 100
vim.o.wildignorecase       = true
vim.o.wildmenu             = true
vim.o.wildmode             = 'noselect:lastused,full'
vim.o.wildoptions          = table.concat({ 'pum', 'fuzzy' }, ',')
-- vim.o.winblend             = 10
vim.o.grepprg              = 'rg -H --no-heading --vimgrep --glob=!.git/*'
vim.o.grepformat           = '%f:%l:%c:%m'

vim.opt.wildignore:append '.DS_Store'
vim.cmd [[set wc=^N]]

vim.cmd 'filetype plugin indent on'
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    pattern = '*grep*',
    callback = function() vim.cmd 'copen' end
})

vim.api.nvim_create_autocmd('FileType', {
    callback = function() vim.cmd 'setlocal formatoptions-=c formatoptions-=o' end
})

vim.api.nvim_create_autocmd('CmdlineChanged', {
    pattern = { ':', '/', '?', '@' },
    callback = function() vim.cmd 'call wildtrigger()' end
})

r 'keymaps'
r 'pack'
r 'plugins'
r 'mini'
r 'lsp'
-- stylua: ignore end
