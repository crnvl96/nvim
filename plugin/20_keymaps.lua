local map = function(mode, lhs, rhs, opts) vim.keymap.set(mode, lhs, rhs, opts) end
local nmap = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { desc = desc }) end

map('v', 'p', 'P')

nmap('<C-d>', '<C-d>zz', 'Scroll down and center')
nmap('<C-u>', '<C-u>zz', 'Scroll up and center')

nmap('gl', 'g$', 'Go to the rightmost visible column')
nmap('gh', 'g^', 'Go to the leftmost visible column')

nmap('L', '%', 'Go to matching bracket')

map({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
map({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

map('n', '<C-h>', '<C-w>h', { desc = 'Focus on left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Focus on below window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Focus on above window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Focus on right window' })

map('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
map('n', '<C-Down>', '<Cmd>resize -5<CR>')
map('n', '<C-Up>', '<Cmd>resize +5<CR>')
map('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')

local nmap_leader = function(suffix, rhs, desc) vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc }) end
local xmap_leader = function(suffix, rhs, desc) vim.keymap.set('x', '<Leader>' .. suffix, rhs, { desc = desc }) end

local new_scratch_buffer = function() vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true)) end

nmap_leader('hh', '<Cmd>noh<CR>', 'Clear Highlights')
nmap_leader('hs', '<Esc>:noh<CR>:w<CR>', 'Save buffer')

nmap_leader('bd', '<Cmd>lua MiniBufremove.delete()<CR>', 'Delete')
nmap_leader('bD', '<Cmd>lua MiniBufremove.delete(0, true)<CR>', 'Delete!')
nmap_leader('bs', new_scratch_buffer, 'Scratch')
nmap_leader('bw', '<Cmd>lua MiniBufremove.wipeout()<CR>', 'Wipeout')
nmap_leader('bW', '<Cmd>lua MiniBufremove.wipeout(0, true)<CR>', 'Wipeout!')

local explore_at_file = '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>'

local explore_quickfix = function()
  for _, win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.fn.getwininfo(win_id)[1].quickfix == 1 then return vim.cmd 'cclose' end
  end
  vim.cmd 'copen'
end

nmap_leader('ed', '<Cmd>lua MiniFiles.open()<CR>', 'Directory')
nmap_leader('ef', explore_at_file, 'File directory')
nmap_leader('ei', '<Cmd>edit $MYVIMRC<CR>', 'init.lua')
nmap_leader('ex', explore_quickfix, 'Quickfix')

nmap_leader("f'", '<Cmd>Pick resume<CR>', 'Resume')
nmap_leader('fb', '<Cmd>Pick buffers<CR>', 'Buffers')
nmap_leader('fD', '<Cmd>Pick diagnostic scope="all"<CR>', 'Diagnostic workspace')
nmap_leader('fd', '<Cmd>Pick diagnostic scope="current"<CR>', 'Diagnostic buffer')
nmap_leader('ff', '<Cmd>Pick files<CR>', 'Files')
nmap_leader('fg', '<Cmd>Pick grep_live<CR>', 'Grep live')
nmap_leader('fh', '<Cmd>Pick help<CR>', 'Help tags')
nmap_leader('fH', '<Cmd>Pick hl_groups<CR>', 'Highlight groups')
nmap_leader('fl', '<Cmd>Pick buf_lines scope="current"<CR>', 'Lines (buf)')
nmap_leader('fo', '<Cmd>Pick oldfiles<CR>', 'Oldfiles')
nmap_leader('fr', '<Cmd>Pick lsp scope="references"<CR>', 'References (LSP)')
nmap_leader('fS', '<Cmd>Pick lsp scope="workspace_symbol"<CR>', 'Symbols workspace')
nmap_leader('fs', '<Cmd>Pick lsp scope="document_symbol"<CR>', 'Symbols document')

nmap_leader('gg', ':Git<space>', 'Git')

local formatting_cmd = '<Cmd>lua require("conform").format({lsp_fallback=true})<CR>'

nmap_leader('la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', 'Actions')
nmap_leader('ld', '<Cmd>Pick lsp scope="definition"<CR>', 'Source definition')
nmap_leader('le', '<Cmd>lua vim.diagnostic.open_float()<CR>', 'Diagnostic popup')
nmap_leader('lf', formatting_cmd, 'Format')
nmap_leader('lh', '<Cmd>lua vim.lsp.buf.hover()<CR>', 'Hover')
nmap_leader('li', '<Cmd>Pick lsp scope="implementation"<CR>', 'Implementation')
nmap_leader('ln', '<Cmd>lua vim.lsp.buf.rename()<CR>', 'Rename')
nmap_leader('lr', '<Cmd>Pick lsp scope="references"<CR>', 'References')
nmap_leader('lS', '<Cmd>Pick lsp scope="workspace_symbol"<CR>', 'Symbols workspace')
nmap_leader('ly', '<CmdPick lsp scope="type_definition"<CR>', 'Type definition')
nmap_leader('ls', '<Cmd>Pick lsp scope="document_symbol"<CR>', 'Symbols document')

xmap_leader('lf', formatting_cmd, 'Format selection')

nmap_leader('wh', '<C-w>h', 'Split window vertically')
nmap_leader('wv', '<C-w>v', 'Split window horizontally')
nmap_leader('wc', '<C-w>c', 'Close current window')
nmap_leader('wo', '<C-w>o', 'Close other windows')

nmap_leader('wH', '<C-w>H', 'Move window to the left')
nmap_leader('wJ', '<C-w>J', 'Move window to bottom')
nmap_leader('wK', '<C-w>K', 'Move window to top')
nmap_leader('wL', '<C-w>L', 'Move window to the right')
