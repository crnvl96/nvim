local node_version_cmd = "mise ls --cd ~ | grep '^node' | grep '22\\.' | head -n 1 | awk '{print $2}'"
local version = vim.fn.system(node_version_cmd):gsub('\n', '')
local home = os.getenv('HOME')

--- Get a specific nodejs binary path
---@param v string the nodejs version
local function node_bin(v) return home .. '/.local/share/mise/installs/node/' .. v .. '/bin/' end

if version == '' then
  vim.notify('Could not determine Node.js version', vim.log.levels.WARN)
else
  local bin = node_bin(version)
  vim.g.node_host_prog = bin .. 'node'
  vim.env.PATH = bin .. ':' .. vim.env.PATH
end

--- Dynamically decide if we're into a quickfix or a location list, and return the respective items
---@param info {quickfix:integer,winid:integer,id:integer,start_idx:integer,end_idx:integer} Information about the current active list
local function get_quickfix_items(info)
  if info.quickfix == 1 then
    return vim.fn.getqflist({ id = info.id, items = 0 }).items
  else
    return vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
end

--- Format the filename that will be shown on our custom qf list
---@param fname string file name
---@param limit integer max length allowed for a filename
local function format_filename(fname, limit)
  if fname == '' then return '[No Name]' end
  fname = fname:gsub('^' .. vim.env.HOME, '~')
  if #fname <= limit then
    return ('%-' .. limit .. 's'):format(fname)
  else
    return ('…%.' .. (limit - 1) .. 's'):format(fname:sub(1 - limit))
  end
end

--- Set the line number and column that will be exhibited together with the list item
---@param lnum integer line number
---@param col integer column
local function format_location(lnum, col) return (lnum > 99999 and -1 or lnum), (col > 999 and -1 or col) end

--- Set the kind of the item to render on the list
---@param qtype string item type
local function format_type(qtype) return qtype == '' and '' or ' ' .. qtype:sub(1, 1):upper() end

--- Specifies a function to be used to get the text to display in the quickfix and location list windows
---@param info {quickfix:integer,winid:integer,id:integer,start_idx:integer,end_idx:integer} Information about the current active list
function _G.qftf(info)
  local items = get_quickfix_items(info)
  local ret = {}
  local limit = 62
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

--- Dynamically expand a cmdline trigger to a mapped command
---@param trigger string the command trigger
---@param cmd string the command to be executed
local function expand_trigger(trigger, cmd)
  local cmdtype = vim.fn.getcmdtype()
  local is_cmd = cmdtype == ':'

  local cmdline = vim.fn.getcmdline()
  local is_trigger = cmdline == trigger

  if is_cmd and is_trigger then
    return cmd
  else
    return trigger
  end
end

---@brief
--- About `:h 'formatoptions'`
--- r: Automatically insert the current comment leader after hitting <Enter> in Insert mode.
--- q: Allow formatting of comments with "gq".
--- l: Long lines are not broken in insert mode: When a line was longer than 'textwidth' when
---    the insert command started, Vim does not automatically format it.
--- 1: Don't break a line after a one-letter word.  It's broken before it instead (if possible).
--- j: Where it makes sense, remove a comment leader when joining lines.

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.markdown_folding = 1
vim.opt.autoindent = true
vim.opt.backup = false
vim.opt.breakindent = true
vim.opt.clipboard = 'unnamed'
vim.opt.cmdheight = 1
vim.opt.completeopt = 'menuone,noselect'
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.diffopt = 'internal,filler,closeoff,algorithm:histogram,linematch:60,indent-heuristic,vertical,context:99'
vim.opt.expandtab = true
vim.opt.fillchars =
  'eob: ,fold:╌,horiz:═,horizdown:╦,horizup:╩,vert:║,verthoriz:╬,vertleft:╣,vertright:╠'
vim.opt.foldcolumn = '0'
vim.opt.foldlevel = 1
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = 'indent'
vim.opt.foldnestmax = 10
vim.opt.foldtext = ''
vim.opt.formatoptions = 'rql1j'
vim.opt.guicursor = ''
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.infercase = true
vim.opt.laststatus = 0
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = 'extends:…,nbsp:␣,precedes:…,tab:  '
vim.opt.mouse = 'a'
vim.opt.mousescroll = 'ver:3,hor:0'
vim.opt.number = true
vim.opt.pumheight = 10
vim.opt.qftf = '{info -> v:lua._G.qftf(info)}'
vim.opt.relativenumber = true
vim.opt.ruler = false
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 4
vim.opt.shortmess = 'FOSWaco'
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.sidescrolloff = 24
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.spelloptions = 'camel'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.switchbuf = 'usetab'
vim.opt.tabstop = 4
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 10
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.virtualedit = 'block'
vim.opt.wildignore:append('.DS_Store')
vim.opt.wildignorecase = true
vim.opt.wildmenu = true
vim.opt.wrap = false
vim.opt.wrap = false
vim.opt.writebackup = false

vim.cmd('filetype plugin indent on')
vim.cmd('packadd cfilter')

if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

if vim.fn.executable('rg') == 1 then
  vim.opt.grepprg = "rg --vimgrep --hidden -g '!.git/*'"
  vim.opt.grepformat = '%f:%l:%c:%m'
end

if vim.fn.has('nvim-0.9') == 1 then
  vim.opt.shortmess = 'CFOSWaco'
  vim.opt.splitkeep = 'screen'
end

if vim.fn.has('nvim-0.10') == 1 then
  vim.opt.foldtext = ''
  vim.opt.termguicolors = true
end

if vim.fn.has('nvim-0.11') == 1 then
  vim.opt.completeopt = 'menuone,noselect,fuzzy,nosort'
  vim.opt.winborder = 'double'
end

if vim.fn.has('nvim-0.12') == 1 then
  require('vim._extui').enable({
    enable = true,
    msg = {
      ---@type 'cmd'|'msg' Where to place regular messages, either in the
      ---cmdline or in a separate ephemeral message window.
      target = 'msg',
      timeout = 4000,
    },
  })

  vim.keymap.set('c', '<C-n>', [[cmdcomplete_info().pum_visible ? "\<C-n>" : "\<Tab>"]], { expr = true })
  vim.keymap.set('c', '<C-p>', [[cmdcomplete_info().pum_visible ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
  vim.keymap.set('c', '<Down>', '<C-u><Down>')
  vim.keymap.set('c', '<Up>', '<C-u><Up>')
  vim.opt.completefuzzycollect = 'keyword,files,whole_line'
  vim.opt.pummaxwidth = 100
  vim.opt.wildoptions = 'pum,fuzzy'

  vim.api.nvim_create_autocmd({ 'CmdlineChanged', 'CmdlineLeave' }, {
    pattern = { '*' },
    callback = function(ev)
      if ev.event == 'CmdlineChanged' then
        vim.opt.wildmode = 'noselect:lastused,full'
        -- vim.fn.wildtrigger()
      end

      if ev.event == 'CmdlineLeave' then vim.opt.wildmode = 'full' end
    end,
  })

  local function findcmd()
    local cmd = {}

    if vim.fn.executable('fd') == 1 then
      cmd = {
        'fd',
        '.',
        '--path-separator',
        '/',
        '--type',
        'f',
        '--hidden',
        '--follow',
        '--exclude',
        '.git',
      }
    elseif vim.fn.executable('fdfind') == 1 then
      cmd = {
        'fdfind',
        '.',
        '--path-separator',
        '/',
        '--type',
        'f',
        '--hidden',
        '--follow',
        '--exclude',
        '.git',
      }
    elseif vim.fn.executable('rg') == 1 then
      cmd = {
        'rg',
        '--path-separator',
        '/',
        '--files',
        '--hidden',
        '--glob',
        '!.git',
      }
    end

    return cmd
  end

  local fnames = {} ---@type string[]
  local handle ---@type vim.SystemObj?
  local needs_refresh = true

  local function refresh()
    if handle ~= nil or not needs_refresh then return end
    needs_refresh = false
    fnames = {}
    local prev

    handle = vim.system(findcmd(), {
      stdout = function(err, data)
        assert(not err, err)
        if not data then return end
        if prev then data = prev .. data end
        if data[#data] == '\n' then
          vim.list_extend(fnames, vim.split(data, '\n', { trimempty = true }))
        else
          local parts = vim.split(data, '\n', { trimempty = true })
          prev = parts[#parts]
          parts[#parts] = nil
          vim.list_extend(fnames, parts)
        end
      end,
    }, function(obj)
      if obj.code ~= 0 then print('Command failed') end
      handle = nil
    end)

    vim.api.nvim_create_autocmd('CmdlineLeave', {
      once = true,
      callback = function()
        needs_refresh = true
        if handle then
          handle:wait(0)
          handle = nil
        end
      end,
    })
  end

  local function fd_findfunc(cmdarg, _)
    if #cmdarg == 0 then
      refresh()
      vim.wait(200, function() return #fnames > 0 end)
      return fnames
    else
      return vim.fn.matchfuzzy(fnames, cmdarg, { matchseq = 1, limit = 100 })
    end
  end

  if vim.fn.executable('fd') == 1 then
    function _G.Fd_findfunc(cmdarg, _cmdcomplete) return fd_findfunc(cmdarg, _cmdcomplete) end
    vim.o.findfunc = 'v:lua.Fd_findfunc'
  end

  vim.keymap.set('n', '<leader>f', ':find<space>')
  vim.keymap.set('n', '<leader>g', ':sil<space>grep!<space>')
  vim.keymap.set('c', '<c-v>', '<home><s-right><c-w>vs<end>')
  vim.keymap.set('c', '<c-s>', '<home><s-right><c-w>sp<end>')
end

vim.api.nvim_create_autocmd('FileType', { command = 'setlocal formatoptions-=c formatoptions-=o' })
vim.api.nvim_create_autocmd('QuickFixCmdPost', { pattern = '*grep*', command = 'cwindow' })
vim.api.nvim_create_autocmd('TextYankPost', { callback = function() (vim.hl or vim.highlight).on_yank() end })
vim.api.nvim_create_autocmd('TermOpen', { command = 'setlocal listchars= nonumber norelativenumber' })
vim.api.nvim_create_autocmd('VimResized', { command = 'tabdo wincmd =' })

vim.keymap.set({ 'n', 'x' }, 'Y', 'yg_')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>p', '"+p')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>P', '"+P')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>y', '"+y')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>Y', '"+yg_')
vim.keymap.set({ 'n', 'x', 'i', 's' }, '<Esc>', '<Cmd>noh<CR><Esc>')
vim.keymap.set({ 'n', 'i', 'x' }, '<C-S>', '<Esc><Cmd>silent! update | redraw<CR>')
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-Up>', '<Cmd>resize +5<CR>')
vim.keymap.set('x', 'p', 'P')
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')
vim.keymap.set({ 'n', 't' }, '<C-Left>', '<Cmd>vertical resize -20<CR>')
vim.keymap.set({ 'n', 't' }, '<C-Right>', '<Cmd>vertical resize +20<CR>')
vim.keymap.set('ca', 'f', function() return expand_trigger('f', 'find<space>') end, { expr = true })
vim.keymap.set('ca', 'g', function() return expand_trigger('g', 'sil<space>grep!') end, { expr = true })

vim.cmd('colorscheme ham')
