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

--- When sending a key command to a terminal (e.g: <C-h>) to a terminal buffer, automatically precedes it with <Esc>
---@param key? string Key command to be executed on the terminal
---@return function
local function term_send_esc(key)
  return function()
    local feed = vim.api.nvim_feedkeys
    local rep = vim.api.nvim_replace_termcodes

    local esc_termcode = rep('<C-\\><C-n>', true, true, true)

    if key then
      local key_termcode = rep(key, true, true, true)
      feed(esc_termcode .. key_termcode, 't', true)
    else
      feed(esc_termcode, 't', true)
    end
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
U.map('<C-Left>', '<Cmd>vertical resize -20<CR>', 'Decrease window width', { 'n', 't' })
U.map('<C-Right>', '<Cmd>vertical resize +20<CR>', 'Increase window width', { 'n', 't' })
U.nmap('<Leader>s', create_scratch_buf, 'Open a scratch buffer')
U.tmap('<C-h>', term_send_esc('<C-h>'), 'Goto left window')
U.tmap('<C-j>', term_send_esc('<C-j>'), 'Goto window below')
U.tmap('<C-k>', term_send_esc('<C-k>'), 'Goto window above')
U.tmap('<C-l>', term_send_esc('<C-l>'), 'Goto right window')
U.tmap('<C-e>', term_send_esc(), '<Esc>')
