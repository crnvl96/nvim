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

vim.keymap.set({ 'n', 'x' }, 'Y', 'yg_')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>p', '"+p')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>P', '"+P')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>y', '"+y')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>Y', '"+yg_')
vim.keymap.set({ 'n', 'x', 'i', 's' }, '<Esc>', '<Cmd>noh<CR><Esc>')
vim.keymap.set({ 'n', 'i', 'x' }, '<C-S>', '<Esc><Cmd>silent! update | redraw<CR>')
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-Up>', '<Cmd>resize +5<CR>')
vim.keymap.set('n', '<Leader>s', create_scratch_buf)

vim.keymap.set('x', 'p', 'P')
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

vim.keymap.set({ 'n', 't' }, '<C-Left>', '<Cmd>vertical resize -20<CR>')
vim.keymap.set({ 'n', 't' }, '<C-Right>', '<Cmd>vertical resize +20<CR>')

vim.keymap.set('t', '<C-h>', term_send_esc('<C-h>'))
vim.keymap.set('t', '<C-j>', term_send_esc('<C-j>'))
vim.keymap.set('t', '<C-k>', term_send_esc('<C-k>'))
vim.keymap.set('t', '<C-l>', term_send_esc('<C-l>'))
vim.keymap.set('t', '<C-e>', term_send_esc())
