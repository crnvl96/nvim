local bind = require('utils.bind')

--- When sending a key command to a terminal (e.g: <C-h>) to a terminal buffer, automatically precedes it with <Esc>
---@param key string Key command to be executed on the terminal
---@return function
local function term_send_esc(key)
  return function()
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true)
        .. vim.api.nvim_replace_termcodes(key, true, true, true),
      't',
      true
    )
  end
end

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

bind.map('Y', 'yg_', 'Yank till end of line', { 'n', 'x' })
bind.map('<Leader>p', '"+p', 'Paste from clipboard', { 'n', 'x', 'o' })
bind.map('<Leader>P', '"+P', 'Paste from clipboard before cursor', { 'n', 'x', 'o' })
bind.map('<Leader>y', '"+y', 'Yank to clipboard', { 'n', 'x', 'o' })
bind.map('<Leader>Y', '"+yg_', 'Yank to clipboard till end of line', { 'n', 'x', 'o' })
bind.map('<Esc>', '<Cmd>noh<CR><Esc>', 'Clear hls and <Esc>', { 'n', 'x', 'i', 's' })
bind.map('<C-S>', '<Esc><Cmd>silent! update | redraw<CR>', 'Save', { 'n', 'i', 'x' })
bind.map('j', "v:count == 0 ? 'gj' : 'j'", 'Go up one line', { 'n', 'x' }, { expr = true })
bind.map('k', "v:count == 0 ? 'gk' : 'k'", 'Go down one line', { 'n', 'x' }, { expr = true })
bind.xmap('p', 'P', 'Paste before cursor')
bind.xmap('<', '<gv', 'Deindent selection')
bind.xmap('>', '>gv', 'Indent selection')
bind.nmap('<C-h>', '<C-w>h', 'Goto left window')
bind.nmap('<C-j>', '<C-w>j', 'Goto window below')
bind.nmap('<C-k>', '<C-w>k', 'Goto window above')
bind.nmap('<C-l>', '<C-w>l', 'Goto right window')
bind.nmap('<C-Down>', '<Cmd>resize -5<CR>', 'Decrease window height')
bind.nmap('<C-Up>', '<Cmd>resize +5<CR>', 'Increase window height')
bind.nmap('<C-Left>', '<Cmd>vertical resize -20<CR>', 'Decrease window width')
bind.nmap('<C-Right>', '<Cmd>vertical resize +20<CR>', 'Increase window width')
bind.tmap('<C-h>', term_send_esc('<C-h>'), 'Goto left window')
bind.tmap('<C-j>', term_send_esc('<C-j>'), 'Goto window below')
bind.tmap('<C-k>', term_send_esc('<C-k>'), 'Goto window above')
bind.tmap('<C-l>', term_send_esc('<C-l>'), 'Goto right window')
bind.tmap('<C-/>', '<cmd>close<cr>', 'Hide Terminal')
bind.nmap('<Leader>b', create_scratch_buf, 'Open a scratch buffer')
