local node_bin = vim.env.HOME .. '/.local/share/mise/installs/node/24/bin'

vim.env.PATH = node_bin .. ':' .. vim.env.PATH
vim.g.node_host_prog = node_bin .. '/node'

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.o.autoindent = true
vim.o.breakindent = true
vim.o.clipboard = 'unnamedplus'
vim.o.cmdheight = 1
vim.o.completeopt = 'menu,menuone,popup,fuzzy,noinsert,noselect,nosort'
vim.o.completetimeout = 100
vim.o.expandtab = true
vim.o.foldcolumn = '0'
vim.o.foldlevel = 10
vim.o.foldlevelstart = 99
vim.o.foldnestmax = 10
vim.o.foldtext = ''
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.infercase = true
vim.o.laststatus = 2
vim.o.linebreak = true
vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:1,hor:2'
vim.o.number = true
vim.o.pumborder = 'none'
vim.o.pummaxwidth = 100
vim.o.relativenumber = true
vim.o.ruler = false
vim.o.scrolloff = 8
vim.o.shiftwidth = 4
vim.o.showcmd = false
vim.o.signcolumn = 'yes'
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.undofile = true
vim.o.updatetime = 1000
vim.o.virtualedit = 'block'
vim.o.wildoptions = 'pum,tagfile,fuzzy'
vim.o.winborder = 'single'
vim.o.wrap = false

vim.cmd('highlight ColorColumn ctermbg=lightgrey guibg=lightgrey')
vim.cmd('filetype plugin indent on')

if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

if vim.fn.executable('rg') then
  function _G.FindFuncRG(cmdarg)
    local fnames = vim.fn.systemlist('rg --files --hidden --color=never --glob="!.git"')
    return #cmdarg == 0 and fnames or vim.fn.matchfuzzy(fnames, cmdarg)
  end

  vim.o.grepprg = 'rg --vimgrep --no-heading --hidden --smart-case'
  vim.o.grepformat = '%f:%l:%c:%m'
  vim.o.findfunc = 'v:lua.FindFuncRG'
end
