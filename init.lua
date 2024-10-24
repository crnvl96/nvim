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
vim.o.cmdheight = 0

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

-- Disable the statusline
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

-- This single line essentially tells Neovim to:
-- - Detect file types automatically
-- - Load corresponding plugins
-- - Apply language-specific indentation rules
vim.cmd.filetype('plugin', 'indent', 'on')

-- Loads Cfilter plugin
vim.cmd.packadd('cfilter')

-- Some aliases for functions that have big names
_G.set = vim.keymap.set
_G.au = vim.api.nvim_create_autocmd
_G.group = vim.api.nvim_create_augroup
_G.user = vim.api.nvim_create_user_command
_G.hl = vim.api.nvim_set_hl

-- Constants used throughout the configuration repo
_G.bigfile = math.floor(0.5 * 1024 * 1024) -- 0.5 mb

function _G.on_attach(client, buf)
  -- Formatting and Range formatting are both handled by `conform.nvim` plugin
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  -- Function to chech if a LSP method if enabled for the current language server
  local function has(method)
    -- If we pass no method, we don't care about this function, and
    -- can directly return `true`
    if not method then return true end

    -- Recursively calls itself for each method on the table
    --
    -- When the arguments passed is a table, we want to ensure that
    -- at least one of the methods present there are valid.
    if type(method) == 'table' then
      for _, m in ipairs(method) do
        if has(m) then return true end
      end

      return false
    end

    return client.supports_method(method) and true or false
  end

  local function lspset(mode, lhs, rhs, opts, method)
    opts = opts or {}
    opts.buffer = buf

    if has(method) then set(mode, lhs, rhs, opts) end
  end

	-- stylua: ignore start
	-- 
	-- These keymaps will only be set if the respective methods (last argument)
	-- are available for the current lsp server
  lspset('i', '<C-k>', function() vim.lsp.buf.signature_help() end, { desc = 'Signature help' }, 'textDocument/signatureHelp')
  lspset('n', 'K', function() vim.lsp.buf.hover() end, { desc = 'Hover' })
  lspset('n', 'L', function() vim.diagnostic.open_float() end, { desc = 'Open float' })

  lspset('n', '<leader>ld', function() require('fzf-lua').lsp_definitions() end, { desc = 'Definition' }, 'textDocument/definition')
  lspset('n', '<leader>lr', function() require('fzf-lua').lsp_references() end, { desc = 'References', nowait = true })
  lspset('n', '<leader>lI', function() require('fzf-lua').lsp_implementations() end, { desc = 'Implementations' })
  lspset('n', '<leader>ly', function() require('fzf-lua').lsp_typedefs() end, { desc = 'Type definition' })
  lspset('n', '<leader>lD', function() require('fzf-lua').lsp_declarations() end, { desc = 'Declaration' })
  lspset('n', '<leader>ls', function() require('fzf-lua').lsp_document_symbols() end, { desc = 'Document symbols' })
  lspset('n', '<leader>lS', function() require('fzf-lua').lsp_live_workspace_symbols() end, { desc = 'Workspace symbols' })
  lspset('n', '<leader>li', function() require('fzf-lua').lsp_incoming_calls() end, { desc = 'Incoming calls' })
  lspset('n', '<leader>lo', function() require('fzf-lua').lsp_outgoing_calls() end, { desc = 'Outgoing calls' })
  lspset('n', '<leader>lx', function() require('fzf-lua').lsp_document_diagnostics() end, { desc = 'Document diagnostics' })
  lspset('n', '<leader>lX', function() require('fzf-lua').lsp_workspace_diagnostics() end, { desc = 'Workspace diagnostics' })
  lspset('n', '<leader>lK', function() vim.lsp.buf.signature_help({ border = 'double' }) end, { desc = 'Signature help' }, 'textDocument/signatureHelp')
  lspset('n', '<Leader>lC', function() vim.lsp.codelens.refresh() end, { desc = 'Display code lens' }, 'textDocument/codeLens')
  lspset('n', '<Leader>ln', function() vim.lsp.buf.rename() end, { desc = 'Rename' })

  lspset({ 'n', 'v' }, '<Leader>la', function() require('fzf-lua').lsp_code_actions() end, { desc = 'Code actions' }, 'textDocument/codeAction')
  lspset({ 'n', 'v' }, '<Leader>lc', function() vim.lsp.codelens.run() end, { desc = 'Code lens' }, 'textDocument/codeLens')
end

-- Avoid overriding the unnamed register with the last pasted text
-- This is useful if we want to paste the yanked text more then one time
set('x', 'p', 'P')

-- Allow <esc> to clean the last highlighted search
set({ 'n', 'v', 'i' }, '<esc>', '<esc><cmd>nohl<cr><esc>')

-- Move the cursor up/down based on visual lines
--
-- So we avoid "jumping" lines, when these are very long and are wrapped
set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

-- More ergonomic "write" action
set({ 'n', 'i', 'x' }, '<c-s>', '<esc><cmd>w<cr><esc>')

-- More ergonomic window navigation
set('n', '<c-h>', '<c-w>h')
set('n', '<c-j>', '<c-w>j')
set('n', '<c-k>', '<c-w>k')
set('n', '<c-l>', '<c-w>l')

-- Increase the resize step for nvim windows
set('n', '<c-up>', '<cmd>resize +5<cr>')
set('n', '<c-down>', '<cmd>resize -5<cr>')
set('n', '<c-left>', '<cmd>vertical resize -20<cr>')
set('n', '<c-right>', '<cmd>vertical resize +20<cr>')

-- Briefly highlight the yanked text
-- Just a small visual feedback
au('TextYankPost', {
  group = group('crnvl96-highlight-on-yank', { clear = true }),
  callback = function() (vim.hl or vim.highlight).on_yank() end,
})

-- Here, we finally setup lazy.nvim
require('lazy').setup({
  defaults = {
    -- Lazy load plugins by default
    lazy = true,
    -- Use the last commit for each plugin
    -- This should be taken with a grain of salt, since plugins may contain breaking changes
    version = false,
  },
  spec = {
    -- Load our plugins that are located at `./lua/plugins`
    { import = 'plugins' },
  },
  change_detection = {
    -- Avoid annoying notifications about config changes
    enabled = false,
  },
  performance = {
    rtp = {
      -- Reset the runtime path to $VIMRUNTIME and your config directory
      reset = true,
      -- PERF:
      -- Disable some built-in nvim plugins, since we do not need them
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
