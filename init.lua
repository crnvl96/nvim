-- Path where lazy.nvim related files will be stored
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

-- Install lazy.nvim now if it it's already not present
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  -- Close the source repository
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

-- Add the recently cloned into rtp
vim.opt.rtp:prepend(lazypath)

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

vim.o.breakindent = true
vim.o.cursorline = false
vim.o.linebreak = true
vim.o.number = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.ruler = false
vim.o.showmode = false
vim.o.wrap = false
vim.o.signcolumn = 'yes'
vim.o.fillchars = 'eob: '
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.infercase = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.virtualedit = 'block'
vim.o.splitkeep = 'screen'
vim.o.termguicolors = true
vim.o.pumblend = 0
vim.o.winblend = 0
vim.o.clipboard = 'unnamedplus'
vim.o.relativenumber = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.foldlevel = 99
vim.o.swapfile = false
vim.o.autoread = true
vim.o.wildignorecase = true

vim.opt.wildoptions:append('fuzzy')
vim.opt.completeopt:append('fuzzy')

vim.cmd.filetype('plugin', 'indent', 'on')
vim.cmd.packadd('cfilter')

_G.set = vim.keymap.set
_G.au = vim.api.nvim_create_autocmd
_G.group = vim.api.nvim_create_augroup
_G.user = vim.api.nvim_create_user_command
_G.hl = vim.api.nvim_set_hl
_G.bigfile = math.floor(0.5 * 1024 * 1024) -- 0.5 mb

function _G.on_attach(client, buf)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  local function has(method)
    if not method then return true end

    if type(method) == 'table' then
      for _, m in ipairs(method) do
        if has(m) then return true end
      end
      return false
    end

    if client.supports_method(method) then return true end

    return false
  end

  local function lspset(mode, lhs, rhs, opts, method)
    opts = opts or {}
    opts.buffer = buf

    if has(method) then set(mode, lhs, rhs, opts) end
  end

	-- stylua: ignore start
  lspset('n', '<leader>ld', function() require('fzf-lua').lsp_definitions() end, { desc = 'Definition' }, 'textDocument/definition')
  lspset('n', '<leader>lr', function() require('fzf-lua').lsp_references() end, { desc = 'References', nowait = true })
  lspset('n', '<leader>lI', function() require('fzf-lua').lsp_implementations() end, { desc = 'Implementations' })
  lspset('n', '<leader>ly', function() require('fzf-lua').lsp_typedefs() end, { desc = 'Type definition' })
  lspset('n', '<leader>lD', function() require('fzf-lua').lsp_declarations() end, { desc = 'Declaration' })
  lspset('n', '<leader>ls', function() require('fzf-lua').lsp_document_symbols() end, { desc = 'Document symbols' })
  lspset('n', '<leader>lS', function() require('fzf-lua').lsp_live_workspace_symbols() end, { desc = 'Workspace symbols' })
  lspset('n', '<leader>li', function() require('fzf-lua').lsp_incoming_calls() end, { desc = 'Incoming calls' })
  lspset('n', '<leader>lo', function() require('fzf-lua').lsp_outgoing_calls() end, { desc = 'Outgoing calls' })
  lspset('n', '<leader>lL', function() require('fzf-lua').lsp_finder() end, { desc = 'Finder' })
  lspset('n', '<leader>lx', function() require('fzf-lua').lsp_document_diagnostics() end, { desc = 'Document diagnostics' })
  lspset('n', '<leader>lX', function() require('fzf-lua').lsp_workspace_diagnostics() end, { desc = 'Workspace diagnostics' })
  lspset('n', 'K', function() vim.lsp.buf.hover({ border = 'double' }) end, { desc = 'Hover' })
  lspset('n', '<leader>lK', function() vim.lsp.buf.signature_help({ border = 'double' }) end, { desc = 'Signature help' }, 'textDocument/signatureHelp')
  lspset('i', '<C-k>', function() vim.lsp.buf.signature_help({ border = 'double' }) end, { desc = 'Signature help' }, 'textDocument/signatureHelp')
  lspset({ 'n', 'v' }, '<Leader>la', function() require('fzf-lua').lsp_code_actions() end, { desc = 'Code actions' }, 'textDocument/codeAction')
  lspset({ 'n', 'v' }, '<Leader>lc', function() vim.lsp.codelens.run() end, { desc = 'Code lens' }, 'textDocument/codeLens')
  lspset('n', '<Leader>lC', function() vim.lsp.codelens.refresh() end, { desc = 'Display code lens' }, 'textDocument/codeLens')
  lspset('n', '<Leader>ln', function() vim.lsp.buf.rename() end, { desc = 'Rename' })
  lspset('n', 'L', function() vim.diagnostic.open_float() end, { desc = 'Open float' })
end

set('x', 'p', 'p')
set({ 'n', 'v', 'i' }, '<esc>', '<esc><cmd>nohl<cr><esc>')
set('n', '<c-d>', '<c-d>zz')
set('n', '<c-u>', '<c-u>zz')
set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
set({ 'n', 'i', 'x' }, '<c-s>', '<esc><cmd>w<cr><esc>')
set('n', '<c-h>', '<c-w>h')
set('n', '<c-j>', '<c-w>j')
set('n', '<c-k>', '<c-w>k')
set('n', '<c-l>', '<c-w>l')
set('n', '<c-up>', '<cmd>resize +5<cr>')
set('n', '<c-down>', '<cmd>resize -5<cr>')
set('n', '<c-left>', '<cmd>vertical resize -20<cr>')
set('n', '<c-right>', '<cmd>vertical resize +20<cr>')

au('TextYankPost', {
  group = group('crnvl96-highlight-on-yank', { clear = true }),
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
