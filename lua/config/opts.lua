-- Set <Space> as the mapleader
vim.g.mapleader = ' '

-- Set "," (comma) as the localleader
-- The localleader is mostly used for plugins (a good example is grug-far.nvim)
vim.g.maplocalleader = ','

-- Enable persistend undo across nvim sessions
vim.o.undofile = true

-- Don't make any kind of backups when writing a file
vim.o.writebackup = false

-- Don't show in the statusline the command being currently executed
vim.o.showcmd = false

-- Enable mouse in all nvim modes
vim.o.mouse = 'a'

-- Every wrapped line will continue visually indented
vim.o.breakindent = true

-- Don't "cut" words when breaking lines
vim.o.linebreak = true

-- Don't wrap long lines by default
vim.o.wrap = false

-- Show line numbers
vim.o.number = true

-- Open new windows to the right of current ones
vim.o.splitbelow = true

-- Open new windows below the current ones
vim.o.splitright = true

-- Keep cursor as "block" on insert mode
vim.o.guicursor = ''

-- Always maintain the signcolumn on
vim.o.signcolumn = 'yes'

-- Ignore case on search patterns
vim.o.ignorecase = true

-- We consider letter cases only if the searched pattern has a upper case
vim.o.smartcase = true

-- Smarter case inference
vim.o.infercase = true

-- Smarter indentation
vim.o.smartindent = true

-- Perform visual selection as a block with <c-v>
vim.o.virtualedit = 'block'

-- Reduce screen movement on window split
vim.o.splitkeep = 'screen'

-- Don't show current mode
vim.o.showmode = false

-- Don't show ruler
vim.o.ruler = false

-- Just to gain some more vertical space
vim.o.cmdheight = 1

-- Enable termgui colors
vim.o.termguicolors = true

-- Sync clipboard with the "+" register
vim.o.clipboard = 'unnamedplus'

-- Enable relative line numbers
vim.o.relativenumber = true

-- Fix indenttion at two spaces
vim.o.shiftwidth = 2

-- Makes Tabs count as two spaces
vim.o.tabstop = 2

-- Don't show the statusline
vim.o.laststatus = 0

-- Keep this values as a gap between cursor and vertical edged of the screen
vim.o.scrolloff = 8

-- Keep this values as a gap between cursor and horizontal edged of the screen
vim.o.sidescrolloff = 8

-- Enter windows with all folds opened
vim.o.foldlevel = 99

-- Disable swapfile
vim.o.swapfile = false

-- Update vim if opened file contents have been changed outside of it
vim.o.autoread = true

-- Ignore case on menu completion for filenames and directories
vim.o.wildignorecase = true

-- Fuzzy find file names and directories
vim.opt.wildoptions:append('fuzzy')

-- Fuzzy find on completion
vim.opt.completeopt:append('fuzzy')

-- Customize mouse scroll
vim.o.mousescroll = 'ver:2,hor:6'

-- Use already opened buffers when switching
vim.o.switchbuf = 'usetab'

-- Limit what is stored in ShaDa file
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h"

-- Draw colored column one step to the right of desired maximum width
vim.o.colorcolumn = '+1'

-- Enable highlighting of the current line
vim.o.cursorline = true

-- Disable certain messages from |ins-completion-menu|
vim.o.shortmess = 'aoOWFcSC'

vim.o.fillchars = table.concat({
  'eob: ',
  'fold:╌',
  'horiz:═',
  'horizdown:╦',
  'horizup:╩',
  'vert:║',
  'verthoriz:╬',
  'vertleft:╣',
  'vertright:╠',
}, ',')

vim.o.listchars = table.concat({ 'extends:…', 'nbsp:␣', 'precedes:…', 'tab:  ' }, ',')

-- Show cursor line only screen line when wrapped
vim.o.cursorlineopt = 'screenline,number'

-- Add padding for lists when 'wrap' is on
vim.o.breakindentopt = 'list:-1'

-- Use auto indent
vim.o.autoindent = true

-- Convert tabs to spaces
vim.o.expandtab = true

-- Improve comment editing
vim.o.formatoptions = 'rqnl1j'

-- Conceal
vim.o.conceallevel = 2
