vim.keymap.set({ 'n', 'x', 'i' }, '<c-s>', '<esc><cmd>w<cr><esc>')
vim.keymap.set({ 'n', 'x', 'i' }, '<esc>', '<esc><cmd>noh<cr><esc>')
vim.keymap.set({ 'n', 'x', 'i' }, '<c-c>', '<esc><cmd>noh<cr><esc>')

vim.keymap.set('n', '-', '<cmd>Ex<CR>')

vim.keymap.set({ 'n', 'v' }, '<leader><space>', ':', { desc = 'Write' })
vim.keymap.set({ 'n', 'x', 'i' }, '<c-x>c', '<cmd>qa<cr>', { desc = 'Quit' })

vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

vim.keymap.set('x', 'p', 'P')

vim.keymap.set('n', '<c-up>', '<cmd>resize +5<cr>')
vim.keymap.set('n', '<c-down>', '<cmd>resize -5<cr>')
vim.keymap.set('n', '<c-left>', '<cmd>vertical resize -20<cr>')
vim.keymap.set('n', '<c-right>', '<cmd>vertical resize +20<cr>')

vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')

vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

local function toggle_background()
    local current_theme = vim.o.background

    if current_theme == 'dark' then
        vim.o.background = 'light'
    else
        vim.o.background = 'dark'
    end
end

vim.keymap.set('n', '<leader>cb', toggle_background, { desc = 'Toggle background' })
