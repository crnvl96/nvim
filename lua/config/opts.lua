local function get_quickfix_items(info)
  if info.quickfix == 1 then
    return vim.fn.getqflist({ id = info.id, items = 0 }).items
  else
    return vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
end

local function format_filename(fname, limit)
  if fname == '' then return '[No Name]' end
  fname = fname:gsub('^' .. vim.env.HOME, '~')
  if #fname <= limit then
    return ('%-' .. limit .. 's'):format(fname)
  else
    return ('…%.' .. (limit - 1) .. 's'):format(fname:sub(1 - limit))
  end
end

local function format_location(lnum, col) return (lnum > 99999 and -1 or lnum), (col > 999 and -1 or col) end
local function format_type(qtype) return qtype == '' and '' or ' ' .. qtype:sub(1, 1):upper() end

function _G.qftf(info)
  local items = get_quickfix_items(info)
  local ret = {}
  local limit = 31
  for i = info.start_idx, info.end_idx do
    local entry = items[i]
    local formatted_text
    if entry.valid == 1 then
      local fname = ''
      if entry.bufnr > 0 then fname = format_filename(vim.fn.bufname(entry.bufnr), limit) end
      local lnum, col = format_location(entry.lnum, entry.col)
      local qtype = format_type(entry.type)
      formatted_text = ('%s │%5d:%-3d│%s %s'):format(fname, lnum, col, qtype, entry.text)
    else
      formatted_text = entry.text
    end
    table.insert(ret, formatted_text)
  end
  return ret
end

vim.o.qftf = '{info -> v:lua._G.qftf(info)}'

if vim.fn.executable('rg') == 1 then
  vim.opt.grepprg = "rg --vimgrep --hidden -g '!.git/*'"
  vim.opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
end

if vim.fn.executable('fd') == 1 and vim.fn.executable('fzf') == 1 then
  function _G.fuzzyfindfunc(cmdarg) return vim.fn.systemlist("fd --hidden . | fzf --filter='" .. cmdarg .. "'") end
  vim.opt.findfunc = 'v:lua._G.fuzzyfindfunc'
end

vim.diagnostic.config({
  update_in_insert = true,
  virtual_text = { current_line = true },
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

vim.opt.background = 'dark'
vim.opt.clipboard = 'unnamed'
vim.opt.completeopt = 'menuone,noselect,noinsert'
vim.opt.cursorline = false
vim.opt.diffopt = 'internal,filler,closeoff,algorithm:histogram,linematch:60,indent-heuristic,vertical,context:99'
vim.opt.expandtab = true
vim.opt.fillchars = 'eob: ,fold: ,foldclose:,foldopen:,foldsep: ,msgsep:─'
vim.opt.foldcolumn = '1'
vim.opt.foldlevelstart = 99
vim.opt.foldtext = ''
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-TermCursor'
vim.opt.ignorecase = true
vim.opt.laststatus = 0
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = 'tab:  ,trail:.'
vim.opt.mouse = 'a'
vim.opt.mousescroll = 'ver:3,hor:0'
vim.opt.number = true
vim.opt.pumheight = 15
vim.opt.relativenumber = true
vim.opt.ruler = false
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 4
vim.opt.shortmess:append('Wsa')
vim.opt.showcmd = false
vim.opt.sidescrolloff = 24
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 10
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.virtualedit = 'block'
vim.opt.wildignore:append('.DS_Store')
vim.opt.wildignorecase = true
vim.opt.wildmenu = true
vim.opt.wildmode = 'noselect:longest:lastused,full'
vim.opt.wildoptions:append('fuzzy')
vim.opt.winborder = 'none'
vim.opt.wrap = false
vim.opt.writebackup = false

vim.cmd('packadd cfilter')
vim.cmd('filetype plugin indent on')
