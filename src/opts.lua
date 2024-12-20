_G.Config = {}

local function isarray(t)
  for i, _ in pairs(t) do
    if type(i) ~= 'number' then return false end
  end

  return true
end

local function merge(dest, src)
  for k, v in pairs(src) do
    local tgt = rawget(dest, k)

    if type(v) == 'table' and type(tgt) == 'table' then
      if isarray(v) and isarray(tgt) then
        dest[k] = vim.list_extend(vim.deepcopy(tgt), v)
      else
        merge(tgt, v)
      end
    else
      dest[k] = vim.deepcopy(v)
    end
  end

  return dest
end

Config.extend_local_opts = function(b, n)
  local base = vim.deepcopy(b or {})
  local new = vim.deepcopy(n or {})

  if isarray(base) and isarray(new) then return vim.list_extend(base, new) end
  return merge(base, new)
end

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.o.autoindent = true
vim.o.autoread = true
vim.o.breakindent = true
vim.o.breakindentopt = 'list:-1'
vim.o.clipboard = 'unnamedplus'
vim.o.cmdheight = 1
vim.o.grepprg = 'rg --vimgrep'
vim.o.colorcolumn = '+1'
vim.o.conceallevel = 0
vim.o.cursorline = true
vim.o.cursorlineopt = 'screenline,number'
vim.o.expandtab = true
vim.o.foldlevel = 99
vim.o.formatoptions = 'rqnl1j'
vim.o.ignorecase = true
vim.o.infercase = true
vim.o.laststatus = 0
vim.o.linebreak = true
vim.o.list = true
vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:2,hor:6'
vim.o.number = true
vim.o.relativenumber = true
vim.o.ruler = false
vim.o.scrolloff = 8
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h"
vim.o.shiftwidth = 2
vim.o.showcmd = false
vim.o.showmode = false
vim.o.sidescrolloff = 8
vim.o.signcolumn = 'yes'
vim.o.smartcase = true
vim.o.smartindent = true
vim.opt.spelllang = { 'en', 'programming' }
vim.o.splitbelow = true
vim.o.splitkeep = 'screen'
vim.o.splitright = true
vim.o.swapfile = false
vim.o.switchbuf = 'usetab'
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.timeoutlen = 200
vim.o.undofile = true
vim.o.virtualedit = 'block'
vim.o.wildignorecase = true
vim.o.wrap = false
vim.o.writebackup = false

vim.opt.completeopt:append('fuzzy')
vim.opt.wildoptions:append('fuzzy')

vim.cmd('filetype plugin indent on')
vim.cmd('packadd cfilter')

if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end
