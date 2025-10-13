-- stylua: ignore start

-- Setup a default path for Neovim to look for NodeJS packages
-- If we have our global version of Node setup to v24, but we enter in 
-- a project which local version is set to v18, when looking for packages like 
-- eslint or prettier, neovim would usually use the local version as 
-- reference. This settings ensure that it will instead use the global version 
-- as reference for finding such packages
local path   = vim.env.HOME .. '/.local/share/mise/installs/node/24.9.0/bin/'
vim.env.PATH = path .. ':' .. vim.env.PATH
vim.g.node_host_prog = path .. 'node'

vim.g.mapleader        = ' '                              -- Set <leader> to <space>
vim.g.maplocalleader   = ','                              -- Set <localleader> to ,
vim.opt.autoindent     = true                             -- Use indent of the current line when starting a new line
vim.opt.mouse          = 'a'                              -- Enable mouse support in all modes
vim.opt.mousescroll    = 'ver:3,hor:0'                    -- Make mouse scroll more smooth
vim.opt.switchbuf      = 'usetab'                         -- Jump to the first open window that contains the specified buffer
vim.opt.undofile       = true                             -- Enable persistent undo
vim.opt.shada          = "'100,<50,s10,:1000,/100,@100,h" -- Limit shada (shared data) file (for startup)
vim.opt.autoread       = true
vim.opt.autowrite      = true
vim.opt.breakindent    = true
vim.opt.clipboard      = 'unnamedplus'
vim.opt.cursorline     = true
vim.opt.expandtab      = true
vim.opt.formatoptions  = 'tcqjw21p'
vim.opt.ignorecase     = true
vim.opt.incsearch      = true
vim.opt.infercase      = true
vim.opt.laststatus     = 2
vim.opt.linebreak      = true
vim.opt.list           = true
vim.opt.number         = true
vim.opt.pumborder      = 'double'
vim.opt.relativenumber = true
vim.opt.ruler          = false
vim.opt.scrolloff      = 8
vim.opt.shiftround     = true
vim.opt.shiftwidth     = 4
vim.opt.shortmess      = 'aCFoOtT'
vim.opt.showcmd        = false
vim.opt.showmode       = false
vim.opt.sidescrolloff  = 24
vim.opt.signcolumn     = 'yes'
vim.opt.smartcase      = true
vim.opt.smartindent    = true
vim.opt.smoothscroll   = true
vim.opt.splitbelow     = true
vim.opt.splitkeep      = 'screen'
vim.opt.splitright     = true
vim.opt.swapfile       = false
vim.opt.tabstop        = 4
vim.opt.termguicolors  = true
vim.opt.textwidth      = 80
vim.opt.timeoutlen     = 1000
vim.opt.ttimeoutlen    = 10
vim.opt.undolevels     = 10000
vim.opt.updatetime     = 300
vim.opt.virtualedit    = 'block'
vim.opt.winborder      = 'double'
vim.opt.winminwidth    = 5
vim.opt.wrap           = false
vim.opt.writebackup    = false

-- Enable all filetype plugins 
vim.cmd 'filetype plugin indent on'

-- Enable syntax (only if not enabled, for better startup)
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

require 'keymaps'
require 'pack'
require 'treesitter'
require 'mini'
require 'complete'
require 'lsp'
require 'ui'
require 'filemanager'
require 'grep'
require 'find'
require 'formatter'
-- stylua: ignore end
