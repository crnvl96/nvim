local node_bin = vim.env.HOME .. '/.local/share/mise/installs/node/24/bin'

vim.env.PATH = node_bin .. ':' .. vim.env.PATH
vim.g.node_host_prog = node_bin .. '/node'

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.o.autoindent = true
vim.o.breakindent = true
vim.o.clipboard = 'unnamedplus'
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.infercase = true
vim.o.linebreak = true
vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:1,hor:2'
vim.o.number = true
vim.o.pummaxwidth = 100
vim.o.relativenumber = true
vim.o.ruler = false
vim.o.scrolloff = 8
vim.o.shiftwidth = 4
vim.o.switchbuf = 'usetab'
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
vim.o.winborder = 'single'
vim.o.wrap = false
vim.o.wildoptions = 'pum,fuzzy'
vim.o.wildmode = 'noselect,full'
vim.o.completeopt = 'menu,menuone,noinsert,noselect,popup,fuzzy'
vim.o.cmdheight = 1

if vim.fn.executable('rg') == 1 then
  vim.opt.grepprg = 'rg --vimgrep --hidden'
  vim.opt.grepformat = '%f:%l:%c:%m,%f'

  function _G.RgFindFiles(cmdarg)
    local fnames = vim.fn.systemlist('rg --files --hidden --color=never --glob="!.git"')
    if #cmdarg == 0 then
      return fnames
    else
      return vim.fn.matchfuzzy(fnames, cmdarg)
    end
  end

  vim.o.findfunc = 'v:lua.RgFindFiles'
end
