pcall(function() vim.loader.enable() end)

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.bigfile = math.floor(1.5 * 1024 * 1024) -- 0.5 mb
vim.g.autoformat = true
vim.g.ts_parsers = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline' }

vim.o.undofile = true
vim.o.writebackup = false
vim.o.showcmd = false
vim.o.mouse = 'a'
vim.o.breakindent = true
vim.o.linebreak = true
vim.o.wrap = false
vim.o.number = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.signcolumn = 'yes'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.infercase = true
vim.o.smartindent = true
vim.o.virtualedit = 'block'
vim.o.splitkeep = 'screen'
vim.o.showmode = false
vim.o.ruler = false
vim.o.cmdheight = 1
vim.o.termguicolors = true
vim.o.clipboard = 'unnamedplus'
vim.o.relativenumber = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.laststatus = 0
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.foldlevel = 99
vim.o.swapfile = false
vim.o.autoread = true
vim.o.wildignorecase = true
vim.o.mousescroll = 'ver:2,hor:6'
vim.o.switchbuf = 'usetab'
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h"
vim.o.colorcolumn = '+1'
vim.o.cursorline = true
vim.o.list = true
vim.o.cursorlineopt = 'screenline,number'
vim.o.breakindentopt = 'list:-1'
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.formatoptions = 'rqnl1j'
vim.o.conceallevel = 2
vim.o.listchars = table.concat({ 'extends:…', 'nbsp:␣', 'precedes:…', 'tab:  ' }, ',')
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

vim.opt.wildoptions:append('fuzzy')
vim.opt.completeopt:append('fuzzy')

vim.cmd.packadd('cfilter')
vim.cmd('filetype plugin indent on')

if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

Au = vim.api.nvim_create_autocmd
Set = vim.keymap.set
User = vim.api.nvim_create_user_command

--- Creates a new augroup with some defaults, such as the name prefix and
--- some opts already set
---
---@param name string
---@param opts? table
---@return nil
function Group(name, opts)
  opts = vim.tbl_deep_extend('keep', { clear = true }, opts or {})
  return vim.api.nvim_create_augroup('crnvl96-' .. name, opts)
end

--- Checks if a plugin is installed
---
---@param plugin string
---@return boolean
function Has(plugin) return require('lazy.core.config').spec.plugins[plugin] ~= nil end

--- Check if a plugin is already loaded on current instance
---
---@param name string
---@return boolean
function IsLoaded(name)
  local plugin = require('lazy.core.config').plugins[name]
  return plugin and plugin._.loaded
end

---Executes some login when a plugin is loaded in current instance
---
---@param name string
---@param fn function
---@return nil
function OnLoad(name, fn)
  if IsLoaded(name) then
    fn()
  else
    Au('User', {
      pattern = 'LazyLoad',
      group = Group('lazy-util-on-load'),
      callback = function(event)
        if event.data == name then
          fn()
          return true
        end
      end,
    })
  end
end

--- Emit a notification based on `snacks.notify`, with fallback to
--- nvim builtin notification system
---
---@param msg string
---@param lvl 'warn'|'error'|'info'
---@return  nil
local function EmitNotify(msg, lvl)
  if Has('snacks.nvim') and IsLoaded('snacks.nvim') then
    Snacks.notify[lvl](msg)
  else
    vim.notify(msg, vim.log.levels[string.upper(lvl)])
  end
end

---@param msg string
---@return nil
Warn = function(msg) EmitNotify(msg, 'warn') end

---@param msg string
---@return nil
Error = function(msg) EmitNotify(msg, 'error') end

---@param msg string
---@return nil
Info = function(msg) EmitNotify(msg, 'info') end

--- This function chechs if a required global variable is present in neovim `(vim.g[var])`
---
---@param name string
---@return nil
function HasGlobalVar(name)
  if vim.g[name] == nil then Error(('The variable `vim.g.%s` must be set!'):format(name)) end
end

--- This function simply chechs if an external tool (such as `git`, or `prettier`, or any other) is installed in the system.
---
--- Useful because some plugins have such requirements
---
---@param name string
---@return nil
function HasExecutable(name)
  if vim.fn.executable(name) ~= 1 then Error(name .. ' is not installed in the system.') end
end

--- Check if a determined file exists at projec root.
---
--- For example, at web projects (typescript/javascript) tipically have a package.json, or similar, at its root
--- so this function checks if such file exists.
---
---@param ctx { buf: number }
---@param list string[]
---@return string?
function MatchAtRoot(ctx, list) return vim.fs.root(ctx.buf, list) end

--- Check if the current buffer is of a certain filetype
---
---@param ctx { buf: number }
---@param list string[]
---@return boolean
function MatchFileType(ctx, list) return vim.tbl_contains(list, vim.bo[ctx.buf].filetype) end

---@param group string
---@param opts table
function SetHL(group, opts) return vim.api.nvim_set_hl(0, group, opts) end

---@param name string
---@param opts table
function ExtendHL(name, opts)
  local current_def = vim.api.nvim_get_hl_by_name(name, true)
  local new_def = vim.tbl_extend('force', {}, current_def, opts)

  SetHL(name, new_def)
end

---@param client table
---@param buf number
---@return nil
function OnAttach(client, buf)
  -- Lsp keymaps are handle by fzf-lua
  if not Has('fzf-lua') then
    Error('You need to install fzf-lua, which is a dependency for the `on_attach` wrapper')
    return
  end

  -- Formatting and Range formatting are both handled by `conform.nvim` plugin
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  ---@param method? string | table
  ---@return boolean
  local function supports(method)
    if not method then return true end

    if type(method) == 'table' then
      for _, m in ipairs(method) do
        if supports(m) then return true end
      end

      return false
    end

    return client.supports_method(method) and true or false
  end

  ---@param mode string
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts { desc: string, nowait?: boolean, buffer?:number }
  ---@param method? string|table
  ---@return nil
  local function lspset(mode, lhs, rhs, opts, method)
    opts = opts or {}
    opts.buffer = buf

    if supports(method) then Set(mode, lhs, rhs, opts) end
  end

  local function sign_help() vim.lsp.buf.signature_help({ border = 'double' }) end

  lspset('i', '<c-k>', sign_help, { desc = 'signature help' }, 'textDocument/signatureHelp')
  lspset('n', 'K', function() vim.lsp.buf.hover({ border = 'double' }) end, { desc = 'hover' })
  lspset('n', 'L', function() vim.diagnostic.open_float({ border = 'double' }) end, { desc = 'open float' })
  lspset('n', '<leader>ld', '<cmd>FzfLua lsp_definitions<cr>', { desc = 'definition' }, 'textDocument/definition')
  lspset('n', '<leader>lr', '<cmd>FzfLua lsp_references<cr>', { desc = 'references', nowait = true })
  lspset('n', '<leader>lI', '<cmd>FzfLua lsp_implementations<cr>', { desc = 'implementations' })
  lspset('n', '<leader>ly', '<cmd>FzfLua lsp_typedefs<cr>', { desc = 'type definition' })
  lspset('n', '<leader>lD', '<cmd>FzfLua lsp_declarations<cr>', { desc = 'declaration' })
  lspset('n', '<leader>ls', '<cmd>FzfLua lsp_document_symbols<cr>', { desc = 'document symbols' })
  lspset('n', '<leader>lS', '<cmd>FzfLua lsp_live_workspace_symbols<cr>', { desc = 'workspace symbols' })
  lspset('n', '<leader>li', '<cmd>FzfLua lsp_incoming_calls<cr>', { desc = 'incoming calls' })
  lspset('n', '<leader>lo', '<cmd>FzfLua lsp_outgoing_calls<cr>', { desc = 'outgoing calls' })
  lspset('n', '<leader>lx', '<cmd>FzfLua lsp_document_diagnostics<cr>', { desc = 'document diagnostics' })
  lspset('n', '<leader>lX', '<cmd>FzfLua lsp_workspace_diagnostics<cr>', { desc = 'workspace diagnostics' })
  lspset('n', '<leader>lK', vim.lsp.buf.signature_help, { desc = 'signature help' }, 'textDocument/signatureHelp')
  lspset('n', '<leader>lC', vim.lsp.codelens.refresh, { desc = 'display code lens' }, 'textDocument/codeLens')
  lspset('n', '<leader>ln', vim.lsp.buf.rename, { desc = 'rename' })
  lspset('n', '<leader>lc', vim.lsp.codelens.run, { desc = 'code lens' }, 'textDocument/codeLens')
  lspset('v', '<leader>lc', vim.lsp.codelens.run, { desc = 'code lens' }, 'textDocument/codeLens')
  lspset('n', '<leader>la', '<cmd>FzfLua lsp_code_actions<cr>', { desc = 'actions' }, 'textDocument/codeAction')
  lspset('v', '<leader>la', '<cmd>FzfLua lsp_code_actions<cr>', { desc = 'actions' }, 'textDocument/codeAction')
end

Set('x', 'p', 'P')
Set({ 'n', 'v', 'i' }, '<esc>', '<esc><cmd>nohl<cr><esc>')
Set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
Set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
Set({ 'n', 'i', 'x' }, '<c-s>', '<esc><cmd>w<cr><esc>')
Set('n', '<c-h>', '<c-w>h')
Set('n', '<c-j>', '<c-w>j')
Set('n', '<c-k>', '<c-w>k')
Set('n', '<c-l>', '<c-w>l')
Set('n', '<c-up>', '<cmd>resize +5<cr>')
Set('n', '<c-down>', '<cmd>resize -5<cr>')
Set('n', '<c-left>', '<cmd>vertical resize -20<cr>')
Set('n', '<c-right>', '<cmd>vertical resize +20<cr>')
Set('v', '>', '>gv')
Set('v', '<', '<gv')

Au('TextYankPost', {
  group = Group('highlight-on-yank'),
  callback = function() (vim.hl or vim.highlight).on_yank() end,
})

require('lazy').setup({
  defaults = {
    lazy = true,
    version = false,
  },
  spec = {
    { import = 'plugins' },
  },
  change_detection = {
    enabled = false,
  },
  performance = {
    rtp = {
      reset = true,
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
