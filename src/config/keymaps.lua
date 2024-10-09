local keycode = vim.keycode or function(x) return vim.api.nvim_replace_termcodes(x, true, true, true) end

local keys = {
    ['cr'] = keycode('<CR>'),
    ['ctrl-y'] = keycode('<C-y>'),
    ['ctrl-y_cr'] = keycode('<C-y><CR>'),
}

_G.cr_action = function()
    if vim.fn.pumvisible() ~= 0 then
        local item_selected = vim.fn.complete_info()['selected'] ~= -1
        return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
    else
        return keys['cr']
    end
end

local function delete_other_buffers()
    local current = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if current ~= buf then require('mini.bufremove').wipeout(buf, true) end
    end

    vim.cmd('redraw!')
end

vim.keymap.set({ 'n', 'x', 'i' }, '<Esc>', '<Esc><Cmd>noh<CR><Esc>', { desc = 'Better Esc' })
vim.keymap.set({ 'n', 'x' }, '<c-d>', '<c-d>zz', { desc = 'Move window down and center' })
vim.keymap.set({ 'n', 'x' }, '<c-u>', '<c-u>zz', { desc = 'Move window up and center' })
vim.keymap.set('n', '<c-up>', '<Cmd>resize +5<CR>', { desc = 'Increase window height' })
vim.keymap.set('n', '<c-down>', '<Cmd>resize -5<CR>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<c-left>', '<Cmd>vertical resize -20<CR>', { desc = 'Increase window width' })
vim.keymap.set('n', '<c-right>', '<Cmd>vertical resize +20<CR>', { desc = 'Decrease window width' })
vim.keymap.set('x', '<', '<gv', { desc = 'Indent visually selected lines' })
vim.keymap.set('x', '>', '>gv', { desc = 'Dedent visually selected lines' })
vim.keymap.set('n', '>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<', '<cmd>bprev<CR>', { desc = 'Prev buffer' })

-- Mini.Pick
vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<CR>', { desc = 'Pick files' })
vim.keymap.set('n', '<leader>fk', '<cmd>Pick keymaps<CR>', { desc = 'Pick keymaps' })
vim.keymap.set('n', '<leader>fl', "<cmd>Pick buf_lines scope='current'<CR>", { desc = 'Pick buflines' })
vim.keymap.set('n', '<leader>fo', '<cmd>Pick visit_paths<CR>', { desc = 'Pick visit paths' })
vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep_live<CR>', { desc = 'Pick grep' })
vim.keymap.set('n', '<leader>fh', '<cmd>Pick help<CR>', { desc = 'Pick help' })
vim.keymap.set('n', '<leader>fr', '<cmd>Pick resume<CR>', { desc = 'Pick resume' })
vim.keymap.set('n', '<leader>fb', '<cmd>Pick buffers<CR>', { desc = 'Pick buffers' })

-- DAP
vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'Set breakpoint' })
vim.keymap.set('n', '<Leader>dc', function() require('dap').continue() end, { desc = 'Dap continue' })
vim.keymap.set('n', '<Leader>dt', function() require('dap').terminate() end, { desc = 'Dap terminate session' })
vim.keymap.set('n', '<Leader>du', function() require('dapui').toggle() end, { desc = 'Dap UI' })
vim.keymap.set('n', '<Leader>de', function() require('dapui').eval(nil, { enter = true }) end, { desc = 'Dap Eval' })

-- Mini.BufRemove
vim.keymap.set('n', '<leader>bd', '<cmd>lua MiniBufremove.delete(0, false)<CR>', { desc = 'Delete current buffer' })
vim.keymap.set('n', '<leader>bo', delete_other_buffers, { desc = 'Delete all other buffers ' })

-- Mini.Completion
vim.keymap.set('i', '<CR>', 'v:lua._G.cr_action()', { expr = true })

--Mini.Files
vim.keymap.set('n', '-', '<cmd>lua MiniFiles.open()<CR>')

-- Mini.Diff
vim.keymap.set('n', '<leader>go', '<cmd>lua MiniDiff.toggle_overlay()<CR>', { desc = 'Git overlay' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
