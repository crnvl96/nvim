-- https://docs.libuv.org/en/v1.x/index.html
--
-- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/lua/nvim-treesitter/parsers.lua
-- https://github.com/nvim-treesitter/nvim-treesitter/tree/main/runtime/queries
--
-- https://github.com/romus204/tree-sitter-manager.nvim
--
-- https://github.com/arborist-ts/registry/blob/main/parsers.toml

local Config = {}
_G.Config = Config

---Debounce func on trailing edge.
---@generic F: function
---@param func F
---@param delay_ms number
---@return F
Config.debounce = function(func, delay_ms)
  ---@type uv.uv_timer_t?
  local timer = nil
  ---@type boolean?
  local running = nil
  return function(...)
    if not running then timer = assert(vim.uv.new_timer()) end
    local argv = { ... }
    assert(timer):start(delay_ms, 0, function()
      assert(timer):stop()
      running = nil
      func(unpack(argv, 1, table.maxn(argv)))
    end)
  end
end

--- Toggle diagnostic for current buffer
---@return string String indicator for new state. Similar to what |:set| `{option}?` shows.
Config.toggle_diagnostic = function()
  local buf_id = vim.api.nvim_get_current_buf()
  local is_enabled = vim.diagnostic.is_enabled({ bufnr = buf_id })
  vim.diagnostic.enable(not is_enabled, { bufnr = buf_id })
  local new_buf_state = not is_enabled
  return new_buf_state and '  diagnostic' or 'nodiagnostic'
end

Config.gr = vim.api.nvim_create_augroup('custom-config', {})

Config.set = vim.keymap.set
Config.on_packchanged = function(name, kinds, callback)
  vim.api.nvim_create_autocmd('PackChanged', {
    group = Config.gr,
    callback = function(e)
      local is_target = e.data.spec.name == name and vim.tbl_contains(kinds, e.data.kind)
      if not is_target then return end
      if not e.data.active then vim.cmd.packadd(name) end
      callback(e)
    end,
  })
end

vim.cmd([[packadd nvim.difftool]])
vim.cmd([[packadd nvim.undotree]])
vim.cmd([[packadd cfilter]])
vim.cmd([[colorscheme ansi]])

vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('vim._core.ui2').enable({
  enable = true,
  msg = {
    targets = 'msg',
    cmd = { height = 0.5 },
    dialog = { height = 0.5 },
    msg = { height = 0.5, timeout = 4000 },
    pager = { height = 1 },
  },
})

local nx = { 'n', 'x' }
local nt = { 'n', 't' }
local nix = { 'n', 'i', 'x' }
local node_bin = vim.env.HOME .. '/.local/share/mise/installs/node/24/bin'

vim.pack.add({
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/christoomey/vim-tmux-navigator',
  'https://github.com/tpope/vim-sleuth',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/kevalin/mermaid.nvim',
  'https://github.com/justinmk/vim-dirvish',
  'https://github.com/justinmk/vim-sneak',
})

vim.cmd([[
let g:sneak#label = 1
let g:sneak#s_next = 0
let g:sneak#use_ic_scs = 1
let g:sneak#target_labels = ";sftunq/SFGHLTUNRMQZ?0"

let g:dirvish_mode = ':sort ,^.*[\/],'
]])

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
vim.o.cmdheight = 1
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

if vim.fn.executable('rg') == 1 then
  vim.opt.grepprg = 'rg --vimgrep'
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

vim.api.nvim_create_autocmd('TextYankPost', {
  group = Config.gr,
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd({ 'InsertEnter', 'CmdlineEnter' }, {
  group = Config.gr,
  callback = vim.schedule_wrap(function() vim.cmd.nohlsearch() end),
})

vim.api.nvim_create_autocmd('BufReadPre', {
  group = Config.gr,
  callback = function(e)
    vim.api.nvim_create_autocmd('FileType', {
      group = Config.gr,
      buffer = e.buf,
      once = true,
      callback = function()
        if vim.bo.buftype ~= '' then return end
        if vim.tbl_contains({ 'gitcommit', 'gitrebase' }, vim.bo.filetype) then return end
        local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
        if cursor_line > 1 then return end
        local mark_line = vim.api.nvim_buf_get_mark(0, [["]])[1]
        local n_lines = vim.api.nvim_buf_line_count(0)
        if not (1 <= mark_line and mark_line <= n_lines) then return end
        vim.cmd([[normal! g`"zv]])
        vim.cmd([[normal! zz]])
      end,
    })
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = Config.gr,
  callback = function(e)
    local bufnr = e.buf
    local filetype = vim.bo[bufnr].ft
    local types = { 'help', 'checkhealth', 'vim', 'fugitive', '' }
    for _, b in ipairs(types) do
      if filetype == b then
        vim.keymap.set('n', 'q', function() vim.api.nvim_command('close') end, { buffer = true })
      end
    end
  end,
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = Config.gr,
  pattern = '[^l]*',
  command = 'cwindow',
})

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  group = Config.gr,
  callback = function()
    local servers = vim
      .iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
      :map(function(file) return vim.fn.fnamemodify(file, ':t:r') end)
      :totable()
    vim.lsp.enable(servers)
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = Config.gr,
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end

    ---@param lhs string
    ---@param rhs string|function
    ---@param opts string|table
    ---@param mode? string|string[]
    local function keymap(lhs, rhs, opts, mode)
      opts = type(opts) == 'string' and { desc = opts }
        or vim.tbl_extend('error', opts --[[@as table]], { buffer = e.buf })
      mode = mode or 'n'
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    ---@param keys string
    local function feedkeys(keys)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
    end

    local function pumvisible() return tonumber(vim.fn.pumvisible()) ~= 0 end

    if client:supports_method('textDocument/completion') then
      client.server_capabilities.completionProvider.triggerCharacters =
        vim.iter(vim.gsplit('a,e,i,o,u,A,E,I,O,U,.,:,-,_', ',')):totable()

      vim.lsp.completion.enable(true, client.id, e.buf, { autotrigger = true })

      keymap('<cr>', function() return pumvisible() and '<C-y>' or '<cr>' end, { expr = true }, 'i')

      keymap('<C-n>', function()
        if pumvisible() then
          feedkeys('<C-n>')
        else
          if next(vim.lsp.get_clients({ bufnr = 0 })) then
            vim.lsp.completion.get()
          else
            if vim.bo.omnifunc == '' then
              feedkeys('<C-x><C-n>')
            else
              feedkeys('<C-x><C-o>')
            end
          end
        end
      end, 'Trigger/select next completion', 'i')
    end

    keymap('<Tab>', function()
      if pumvisible() then
        feedkeys('<C-n>')
      else
        feedkeys('<Tab>')
      end
    end, {}, { 'i', 's' })

    keymap('<S-Tab>', function()
      if pumvisible() then
        feedkeys('<C-p>')
      else
        feedkeys('<S-Tab>')
      end
    end, {}, { 'i', 's' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = Config.gr,
  pattern = vim
    .iter(vim.api.nvim_get_runtime_file('parser/*.so', true))
    :map(function(file) return vim.fn.fnamemodify(file, ':t:r') end)
    :map(function(file) return vim.treesitter.language.get_filetypes(file) end)
    :flatten()
    :totable(),
  callback = function(e)
    local ft = vim.bo[e.buf].filetype
    if vim.treesitter.language.add(ft) then vim.treesitter.start(e.buf) end
  end,
})

vim.api.nvim_create_autocmd('CmdlineChanged', {
  group = Config.gr,
  callback = Config.debounce(
    vim.schedule_wrap(function()
      local function should_enable_autocomplete()
        local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]
        local cmdline_type = vim.fn.getcmdtype()
        -- return cmdline_type == '/' or cmdline_type == '?' or (cmdline_type == ':' and cmdline_cmd and #cmdline_cmd >= 2)
        return cmdline_type == '/'
          or cmdline_type == '?'
          or cmdline_type == '!'
          or (
            cmdline_type == ':'
            and (
              cmdline_cmd == 'find'
              or cmdline_cmd == 'fin'
              or cmdline_cmd == 'help'
              or cmdline_cmd == 'h'
              or cmdline_cmd == 'buffer'
              or cmdline_cmd == 'b'
            )
          )
      end
      if should_enable_autocomplete() then vim.fn.wildtrigger() end
    end),
    500
  ),
})

require('mini.extra').setup()
require('mini.align').setup()
require('mini.misc').setup()
require('mini.splitjoin').setup()
require('mermaid').setup()

require('mini.ai').setup({
  search_method = 'cover',
  custom_textobjects = {
    g = MiniExtra.gen_ai_spec.buffer(),
    f = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
  },
})

Config.set(nx, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true, desc = 'Go down one visual line' })
Config.set(nx, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true, desc = 'Go up one visual line' })
Config.set(nt, '<C-Left>', '<Cmd>vertical resize -20<CR>', { noremap = true, desc = 'Decrease window width' })
Config.set(nt, '<C-Down>', '<Cmd>resize -5<CR>', { noremap = true, desc = 'Decrease window height' })
Config.set(nt, '<C-Up>', '<Cmd>resize +5<CR>', { noremap = true, desc = 'Increase window height' })
Config.set(nt, '<C-Right>', '<Cmd>vertical resize +20<CR>', { noremap = true, desc = 'Increase window width' })
Config.set(nix, '<Esc>', '<Esc><Cmd>noh<CR><Esc>', { noremap = true, desc = 'Clear hlsearch on <Esc>' })
Config.set('n', 'Y', 'yg_', { noremap = true, desc = 'Yank till end of current line' })
Config.set('x', 'p', 'P', { noremap = true, desc = 'Paste in visual mode without overriding register' })
Config.set('x', '>', '>gv', { desc = 'Indent' })
Config.set('x', '<', '<gv', { desc = 'Deindent' })
Config.set('n', '<C-h>', '<C-w>h', { noremap = true, desc = 'Go to left window' })
Config.set('n', '<C-j>', '<C-w>j', { noremap = true, desc = 'Go to window below' })
Config.set('n', '<C-k>', '<C-w>k', { noremap = true, desc = 'Go to window above' })
Config.set('n', '<C-l>', '<C-w>l', { noremap = true, desc = 'Go to right window' })
Config.set('n', '<C-d>', '<C-d>zz', { noremap = true, desc = 'Scroll down' })
Config.set('n', '<C-u>', '<C-u>zz', { noremap = true, desc = 'Scroll up' })
Config.set('c', '<C-f>', '<Right>', { noremap = true, desc = 'Move cursor to the right char' })
Config.set('c', '<C-b>', '<Left>', { noremap = true, desc = 'Move cursor to the left char' })
Config.set('c', '<C-a>', '<Home>', { noremap = true, desc = 'Move cursor to start of line' })
Config.set('c', '<C-e>', '<End>', { noremap = true, desc = 'Move cursor to end of line' })
Config.set('c', '<C-g>', '<C-c>', { noremap = true, desc = 'Quit/Exit from cmdline' })
Config.set('c', '<M-h>', '<C-f>', { noremap = true, desc = 'Access cmdline history' })
Config.set('c', '<M-f>', '<C-Right>', { noremap = true, desc = 'Move cursor to left word' })
Config.set('c', '<M-b>', '<C-Left>', { noremap = true, desc = 'Move cursor to right word' })
Config.set('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>', { noremap = true, desc = 'Go to left window' })
Config.set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>', { noremap = true, desc = 'Go to window below' })
Config.set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>', { noremap = true, desc = 'Go to window above' })
Config.set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>', { noremap = true, desc = 'Go to right window' })
Config.set('n', 'E', '<Cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'Open Current Diagnostic' })
Config.set('n', 'grd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'vim.lsp.buf.definition()' })
Config.set('n', 'grD', '<Cmd>lua vim.diagnostic.setqflist()<CR>', { desc = 'vim.diagnostic.setqflist()' })
Config.set('n', '<leader>ef', '<Cmd>Dirvish<CR>', { desc = 'File explorer' })
Config.set('n', '<leader>ff', ':find<space>', { desc = 'Fuzzy find' })
Config.set('n', '<leader>fg', ':sil<space>grep<space>', { desc = 'Fuzzy find file' })
Config.set('n', '<leader>fh', ':help<space>', { desc = 'Fuzzy find file' })
Config.set('n', '<leader>fl', function()
  local file = vim.fn.getreg('%')
  local left = vim.api.nvim_replace_termcodes('<Left>', true, false, true)
  vim.api.nvim_feedkeys(':sil grep  -g=' .. file .. string.rep(left, 4 + #file), 'n', false)
end, { desc = 'Grep current file' })
Config.set('n', '<Leader>uc', '<Cmd>setlocal cursorline! cursorline?<CR>', { desc = "Toggle 'cursorline'" })
Config.set('n', '<Leader>uC', '<Cmd>setlocal cursorcolumn! cursorcolumn?<CR>', { desc = "Toggle 'cursorcolumn'" })
Config.set('n', '<Leader>ud', '<Cmd>lua print(M.toggle_diagnostic())<CR>', { desc = 'Toggle diagnostic' })
Config.set('n', '<Leader>uf', '<Cmd>lua print("No formatter configured for this ft")<CR>', { desc = 'Format file' })
Config.set('n', '<Leader>uF', '<Cmd>lua print("No formatter configured for this ft")<CR>', { desc = 'Format project' })
Config.set('n', '<Leader>ui', '<Cmd>setlocal ignorecase! ignorecase?<CR>', { desc = "Toggle 'ignorecase'" })
Config.set('n', '<Leader>ul', '<Cmd>setlocal list! list?<CR>', { desc = "Toggle 'list'" })
Config.set('n', '<Leader>un', '<Cmd>setlocal number! number?<CR>', { desc = "Toggle 'number'" })
Config.set('n', '<Leader>ur', '<Cmd>setlocal relativenumber! relativenumber?<CR>', { desc = "Toggle 'relativenumber'" })
Config.set('n', '<Leader>us', '<Cmd>setlocal spell! spell?<CR>', { desc = "Toggle 'spell'" })
Config.set('n', '<Leader>uw', '<Cmd>setlocal wrap! wrap?<CR>', { desc = "Toggle 'wrap'" })
