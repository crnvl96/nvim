local map = function(mode, lhs, rhs, opts) vim.keymap.set(mode, lhs, rhs, opts) end
local nmap = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { desc = desc }) end

map('n', 'p', 'P')
map('x', 'p', 'P')
map('o', 'p', 'P')

nmap('[p', '<Cmd>exe "put! " . v:register<CR>', 'Paste Above')
nmap(']p', '<Cmd>exe "put "  . v:register<CR>', 'Paste Below')
nmap('<C-5>', '<Cmd>noh<CR>', 'Clear Highlights')

map({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
map({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
map({ 'n', 'i', 'x' }, '<C-s>', '<Esc>:noh<CR>:w<CR>')

map('n', '<C-H>', '<C-w>h', { desc = 'Focus on left window' })
map('n', '<C-J>', '<C-w>j', { desc = 'Focus on below window' })
map('n', '<C-K>', '<C-w>k', { desc = 'Focus on above window' })
map('n', '<C-L>', '<C-w>l', { desc = 'Focus on right window' })

map('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
map('n', '<C-Down>', '<Cmd>resize -5<CR>')
map('n', '<C-Up>', '<Cmd>resize +5<CR>')
map('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')

map('c', '<M-h>', '<Left>', { silent = false, desc = 'Left' })
map('c', '<M-l>', '<Right>', { silent = false, desc = 'Right' })

-- Don't `noremap` in insert mode to have these keybindings behave exactly like arrows
map('i', '<M-h>', '<Left>', { noremap = false, desc = 'Left' })
map('i', '<M-j>', '<Down>', { noremap = false, desc = 'Down' })
map('i', '<M-k>', '<Up>', { noremap = false, desc = 'Up' })
map('i', '<M-l>', '<Right>', { noremap = false, desc = 'Right' })

map('t', '<M-h>', '<Left>', { desc = 'Left' })
map('t', '<M-j>', '<Down>', { desc = 'Down' })
map('t', '<M-k>', '<Up>', { desc = 'Up' })
map('t', '<M-l>', '<Right>', { desc = 'Right' })

_G.Config.leader_group_clues = {
  { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
  { mode = 'n', keys = '<Leader>e', desc = '+Explore/Edit' },
  { mode = 'n', keys = '<Leader>f', desc = '+Find' },
  { mode = 'n', keys = '<Leader>g', desc = '+Git' },
  { mode = 'n', keys = '<Leader>l', desc = '+Language' },
  { mode = 'n', keys = '<Leader>o', desc = '+Other' },

  { mode = 'x', keys = '<Leader>g', desc = '+Git' },
  { mode = 'x', keys = '<Leader>l', desc = '+Language' },
}

local nmap_leader = function(suffix, rhs, desc) vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc }) end
local xmap_leader = function(suffix, rhs, desc) vim.keymap.set('x', '<Leader>' .. suffix, rhs, { desc = desc }) end

local new_scratch_buffer = function() vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true)) end

nmap_leader('bd', '<Cmd>lua MiniBufremove.delete()<CR>', 'Delete')
nmap_leader('bD', '<Cmd>lua MiniBufremove.delete(0, true)<CR>', 'Delete!')
nmap_leader('bs', new_scratch_buffer, 'Scratch')
nmap_leader('bw', '<Cmd>lua MiniBufremove.wipeout()<CR>', 'Wipeout')
nmap_leader('bW', '<Cmd>lua MiniBufremove.wipeout(0, true)<CR>', 'Wipeout!')

local edit_plugin_file = function(filename)
  return string.format('<Cmd>edit %s/plugin/%s<CR>', vim.fn.stdpath 'config', filename)
end
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
nmap_leader('ek', edit_plugin_file '20_keymaps.lua', 'Keymaps config')
nmap_leader('em', edit_plugin_file '30_mini.lua', 'MINI config')
nmap_leader('eo', edit_plugin_file '10_options.lua', 'Options config')
nmap_leader('ep', edit_plugin_file '40_plugins.lua', 'Plugins config')
nmap_leader('eq', explore_quickfix, 'Quickfix')

nmap_leader('f/', '<Cmd>Pick history scope="/"<CR>', '"/" history')
nmap_leader('f:', '<Cmd>Pick history scope=":"<CR>', '":" history')
nmap_leader("f'", '<Cmd>Pick resume<CR>', 'Resume')
nmap_leader('f.', '<Cmd>Pick commands<CR>', 'Commands')
nmap_leader('fA', '<Cmd>Pick git_hunks scope="staged"<CR>', 'Added hunks (all)')
nmap_leader('fa', '<Cmd>Pick git_hunks path="%" scope="staged"<CR>', 'Added hunks (buf)')
nmap_leader('fb', '<Cmd>Pick buffers<CR>', 'Buffers')
nmap_leader('fC', '<Cmd>Pick git_commits<CR>', 'Commits (all)')
nmap_leader('fc', '<Cmd>Pick git_commits path="%"<CR>', 'Commits (buf)')
nmap_leader('fD', '<Cmd>Pick diagnostic scope="all"<CR>', 'Diagnostic workspace')
nmap_leader('fd', '<Cmd>Pick diagnostic scope="current"<CR>', 'Diagnostic buffer')
nmap_leader('ff', '<Cmd>Pick files<CR>', 'Files')
nmap_leader('fg', '<Cmd>Pick grep_live<CR>', 'Grep live')
nmap_leader('fG', '<Cmd>Pick grep pattern="<cword>"<CR>', 'Grep current word')
nmap_leader('fh', '<Cmd>Pick help<CR>', 'Help tags')
nmap_leader('fH', '<Cmd>Pick hl_groups<CR>', 'Highlight groups')
nmap_leader('fk', '<Cmd>Pick keymaps<CR>', 'keymaps')
nmap_leader('fL', '<Cmd>Pick buf_lines scope="all"<CR>', 'Lines (all)')
nmap_leader('fl', '<Cmd>Pick buf_lines scope="current"<CR>', 'Lines (buf)')
nmap_leader('fM', '<Cmd>Pick git_hunks<CR>', 'Modified hunks (all)')
nmap_leader('fm', '<Cmd>Pick git_hunks path="%"<CR>', 'Modified hunks (buf)')
nmap_leader('fn', '<Cmd>lua MiniNotify.show_history()<CR>', 'Notifications')
nmap_leader('fo', '<Cmd>Pick oldfiles<CR>', 'Oldfiles')
nmap_leader('fr', '<Cmd>Pick lsp scope="references"<CR>', 'References (LSP)')
nmap_leader('fS', '<Cmd>Pick lsp scope="workspace_symbol"<CR>', 'Symbols workspace')
nmap_leader('fs', '<Cmd>Pick lsp scope="document_symbol"<CR>', 'Symbols document')
nmap_leader('fV', '<Cmd>Pick visit_paths cwd=""<CR>', 'Visit paths (all)')
nmap_leader('fv', '<Cmd>Pick visit_paths<CR>', 'Visit paths (cwd)')

local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
local git_log_buf_cmd = git_log_cmd .. ' --follow -- %'

nmap_leader('gA', '<Cmd>Git diff --cached<CR>', 'Added diff')
nmap_leader('ga', '<Cmd>Git diff --cached -- %<CR>', 'Added diff buffer')
nmap_leader('gc', '<Cmd>Git commit<CR>', 'Commit')
nmap_leader('gC', '<Cmd>Git commit --amend<CR>', 'Commit amend')
nmap_leader('gD', '<Cmd>Git diff<CR>', 'Diff')
nmap_leader('gd', '<Cmd>Git diff -- %<CR>', 'Diff buffer')
nmap_leader('gL', '<Cmd>' .. git_log_cmd .. '<CR>', 'Log')
nmap_leader('gl', '<Cmd>' .. git_log_buf_cmd .. '<CR>', 'Log buffer')
nmap_leader('go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>', 'Toggle overlay')
nmap_leader('gs', '<Cmd>Git<CR>', 'Status')

xmap_leader('gS', '<Cmd>lua MiniGit.show_at_cursor()<CR>', 'Show at selection')

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

nmap_leader('or', '<Cmd>lua MiniMisc.resize_window()<CR>', 'Resize to default width')
nmap_leader('ot', '<Cmd>lua MiniTrailspace.trim()<CR>', 'Trim trailspace')
nmap_leader('oz', '<Cmd>lua MiniMisc.zoom()<CR>', 'Zoom toggle')
