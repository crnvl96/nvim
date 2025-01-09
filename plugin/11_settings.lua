_G.Config = {}
local H = {}

function Config.extend(b, n)
  local base = vim.deepcopy(b or {})
  local new = vim.deepcopy(n or {})
  if H.is_array(base) and H.is_array(new) then return vim.list_extend(base, new) end
  return H.merge(base, new)
end

function Config.toggle_quickfix()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local quickfix_wins = vim.tbl_filter(function(win_id) return vim.fn.getwininfo(win_id)[1].quickfix == 1 end, wins)
  vim.cmd(#quickfix_wins == 0 and 'copen' or 'cclose')
end

function Config.on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  local set = vim.keymap.set

  local hover = '<Cmd>lua vim.lsp.buf.hover({border="single"})<CR>'
  local sign_help = '<Cmd>lua vim.lsp.buf.signature_help({border="single"})<CR>'
  local open_float = '<Cmd>lua vim.diagnostic.open_float({boder="single"})<CR>'
  local rename = '<Cmd>lua vim.lsp.buf.rename()<CR>'

  set('n', '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'Code action', buffer = bufnr })
  set('n', '<Leader>le', hover, { desc = 'Eval', buffer = bufnr })
  set('n', '<Leader>lh', sign_help, { desc = 'Signature help', buffer = bufnr })
  set('n', '<Leader>lj', '<Cmd>lua vim.diagnostic.goto_next()<CR>', { desc = 'Next diagnostic', buffer = bufnr })
  set('n', '<Leader>lk', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', { desc = 'Previous diagnostic', buffer = bufnr })
  set('n', '<Leader>ll', open_float, { desc = 'Inspect diagnostic', buffer = bufnr })
  set('n', '<Leader>ln', rename, { desc = 'Rename symbol', buffer = bufnr })
  set('n', '<Leader>lx', '<Cmd>lua vim.lsp.diagnostic.setqflist()<CR>', { desc = 'Set quickfix list', buffer = bufnr })
  set('n', '<Leader>lc', '<Cmd>lua vim.lsp.buf.declaration()<CR>', { desc = 'Declaration', buffer = bufnr })
  set('n', '<Leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'Definition', buffer = bufnr })
  set('n', '<Leader>li', '<Cmd>lua vim.lsp.buf.implementation()<CR>', { desc = 'Implementation', buffer = bufnr })
  set('n', '<Leader>lr', '<Cmd>lua vim.lsp.buf.references()<CR>', { desc = 'References', buffer = bufnr })
  set('n', '<Leader>ls', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', { desc = 'Doc symbols', buffer = bufnr })
  set('n', '<Leader>lS', '<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', { desc = 'Workspace symbols', buffer = bufnr })
  set('n', '<Leader>ly', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', { desc = 'Type definition', buffer = bufnr })
end

function Config.build(params, build_cmd)
  vim.notify('Building ' .. params.name, vim.log.levels.INFO)
  local obj = vim.system(build_cmd, { cwd = params.path }):wait()
  if obj.code == 0 then
    vim.notify('Building ' .. params.name .. ' done', vim.log.levels.INFO)
  else
    vim.notify('Building ' .. params.name .. ' failed', vim.log.levels.ERROR)
  end
end

function _G.qftf(info)
  local items
  local ret = {}

  if info.quickfix == 1 then
    items = vim.fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end

  local limit = 62
  local fnameFmt1, fnameFmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
  local validFmt = '%s │%5d:%-3d│%s %s'

  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ''
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = vim.fn.bufname(e.bufnr)
        if fname == '' then
          fname = '[No Name]'
        else
          fname = fname:gsub('^' .. vim.env.HOME, '~')
        end
        -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
        if #fname <= limit then
          fname = fnameFmt1:format(fname)
        else
          fname = fnameFmt2:format(fname:sub(1 - limit))
        end
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
      str = validFmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end

  return ret
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.o.autoindent = true
vim.o.autoread = true
vim.o.breakindent = true
vim.o.breakindentopt = 'list:-1'
vim.o.clipboard = 'unnamedplus'
vim.o.cmdheight = 1
vim.o.colorcolumn = '+1'
vim.o.conceallevel = 0
vim.o.cursorline = true
vim.o.cursorlineopt = 'screenline,number'
vim.o.expandtab = true
vim.o.foldcolumn = '0'
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.formatoptions = 'rqnl1j'
vim.o.grepprg = 'rg --vimgrep'
vim.o.ignorecase = true
vim.o.infercase = true
vim.o.laststatus = 0
vim.o.linebreak = true
vim.o.list = true
vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:2,hor:6'
vim.o.number = true
vim.o.qftf = '{info -> v:lua._G.qftf(info)}'
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
vim.o.splitbelow = true
vim.o.splitkeep = 'screen'
vim.o.splitright = true
vim.o.swapfile = false
vim.o.switchbuf = 'usetab'
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.timeoutlen = 1000
vim.o.undofile = true
vim.o.virtualedit = 'block'
vim.o.wildignorecase = true
vim.o.wrap = false
vim.o.writebackup = false

if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end
vim.cmd('filetype plugin indent on')
vim.cmd('packadd cfilter')

local register_capability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then return end
  Config.on_attach(client, vim.api.nvim_get_current_buf())
  return register_capability(err, res, ctx)
end

vim.diagnostic.config({
  float = { border = 'single' },
  signs = { priority = 9999, severity = { min = 'WARN', max = 'ERROR' } },
  virtual_text = { severity = { min = 'ERROR', max = 'ERROR' } },
  update_in_insert = false,
})

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true })

vim.keymap.set('i', ',', ',<C-g>u')
vim.keymap.set('i', '.', '.<C-g>u')
vim.keymap.set('i', ';', ';<C-g>u')

vim.keymap.set('x', 'p', 'P')

vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', '<C-w>+', '<Cmd>resize +5<CR>', { remap = true })
vim.keymap.set('n', '<C-w>-', '<Cmd>resize -5<CR>', { remap = true })
vim.keymap.set('n', '<C-w><', '<Cmd>vertical resize -20<CR>', { remap = true })
vim.keymap.set('n', '<C-w>>', '<Cmd>vertical resize +20<CR>', { remap = true })

vim.keymap.set('n', '<C-Up>', '<Cmd>resize +5<CR>', { remap = true })
vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>', { remap = true })
vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>', { remap = true })
vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>', { remap = true })

vim.keymap.set({ 'n', 'v', 'i' }, '<Esc>', '<Esc><Cmd>nohl<CR><Esc>')
vim.keymap.set({ 'n', 'i', 'x' }, '<C-s>', '<Esc><Cmd>w<CR><Esc>')

vim.keymap.set('x', '>', '>gv')
vim.keymap.set('x', '<', '<gv')

vim.keymap.set('n', '<Leader>ba', '<Cmd>b#<CR>', { desc = 'Alternate buffer' })
vim.keymap.set('n', '<Leader>bd', '<Cmd>bd<CR>', { desc = 'Delete current buffer' })
vim.keymap.set('n', '<Leader>xt', '<Cmd>lua Config.toggle_quickfix()<CR>', { desc = 'Toggle quickfix list' })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-highlight-on-yank', { clear = true }),
  callback = function() (vim.hl or vim.highlight).on_yank() end,
})

vim.api.nvim_create_autocmd('VimResized', {
  group = vim.api.nvim_create_augroup('crnvl96-resize-splits', { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('crnvl96-auto-last-position', { clear = true }),
  callback = function(e)
    local position = vim.api.nvim_buf_get_mark(e.buf, [["]])
    local winid = vim.fn.bufwinid(e.buf)
    pcall(vim.api.nvim_win_set_cursor, winid, position)
  end,
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = vim.api.nvim_create_augroup('crnvl96-auto-open-qf', { clear = true }),
  pattern = '[^lc]*',
  callback = function() vim.cmd('cwindow') end,
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = vim.api.nvim_create_augroup('crnvl96-auto-open-lc', { clear = true }),
  pattern = 'l*',
  callback = function() vim.cmd('lwindow') end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('crnvl96-on-lsp-attach', { clear = true }),
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end
    Config.on_attach(client, e.buf)
  end,
})

--
-- Helpers
--

--- Checks if a lua table is an array or not
---@param t table
---@return boolean
function H.is_array(t)
  for i, _ in pairs(t) do
    if type(i) ~= 'number' then return false end
  end

  return true
end

function H.merge(dest, src)
  for k, v in pairs(src) do
    local tgt = rawget(dest, k)

    if type(v) == 'table' and type(tgt) == 'table' then
      if H.is_array(v) and H.is_array(tgt) then
        dest[k] = vim.list_extend(vim.deepcopy(tgt), v)
      else
        H.merge(tgt, v)
      end
    else
      dest[k] = vim.deepcopy(v)
    end
  end

  return dest
end
