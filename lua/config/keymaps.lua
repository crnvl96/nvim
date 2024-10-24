local M = require('config.functions')
local set = M.set

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

set('n', '<leader><c-x>', '<cmd>qa<cr>', { desc = 'quit neovim' })
