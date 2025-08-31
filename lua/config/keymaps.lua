local U = require('utils')

--- Creates a scratch, transient buffer. Ideal for quick annotations
---@return nil
local function create_scratch_buf()
  local buf_opts = {
    filetype = 'scratch',
    buftype = 'nofile',
    bufhidden = 'wipe',
    swapfile = false,
    modifiable = true,
  }
  vim.cmd('bel 10new')
  local buf = vim.api.nvim_get_current_buf()
  for name, value in pairs(buf_opts) do
    vim.api.nvim_set_option_value(name, value, { buf = buf })
  end
end

U.map('Y', 'yg_', 'Yank till end of line', { 'n', 'x' })
U.map('<Leader>p', '"+p', 'Paste from clipboard', { 'n', 'x', 'o' })
U.map('<Leader>P', '"+P', 'Paste from clipboard before cursor', { 'n', 'x', 'o' })
U.map('<Leader>y', '"+y', 'Yank to clipboard', { 'n', 'x', 'o' })
U.map('<Leader>Y', '"+yg_', 'Yank to clipboard till end of line', { 'n', 'x', 'o' })
U.map('<Esc>', '<Cmd>noh<CR><Esc>', 'Clear hls and <Esc>', { 'n', 'x', 'i', 's' })
U.map('<C-S>', '<Esc><Cmd>silent! update | redraw<CR>', 'Save', { 'n', 'i', 'x' })
U.map('j', "v:count == 0 ? 'gj' : 'j'", 'Go up one line', { 'n', 'x' }, { expr = true })
U.map('k', "v:count == 0 ? 'gk' : 'k'", 'Go down one line', { 'n', 'x' }, { expr = true })
U.xmap('p', 'P', 'Paste before cursor')
U.xmap('<', '<gv', 'Deindent selection')
U.xmap('>', '>gv', 'Indent selection')
U.nmap('<C-h>', '<C-w>h', 'Goto left window')
U.nmap('<C-j>', '<C-w>j', 'Goto window below')
U.nmap('<C-k>', '<C-w>k', 'Goto window above')
U.nmap('<C-l>', '<C-w>l', 'Goto right window')
U.nmap('<C-Down>', '<Cmd>resize -5<CR>', 'Decrease window height')
U.nmap('<C-Up>', '<Cmd>resize +5<CR>', 'Increase window height')
U.nmap('<C-Left>', '<Cmd>vertical resize -20<CR>', 'Decrease window width')
U.nmap('<C-Right>', '<Cmd>vertical resize +20<CR>', 'Increase window width')
U.nmap('<Leader>b', create_scratch_buf, 'Open a scratch buffer')
