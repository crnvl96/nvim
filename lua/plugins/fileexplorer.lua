local grug_far = require('grug-far')
grug_far.setup({ headerMaxWidth = 80 })

local oil = require('oil')
oil.setup({
    columns = { 'icon' },
    watch_for_changes = true,
    view_options = { show_hidden = true },
    keymaps = {
        ['<C-s>'] = false,
        ['<C-h>'] = false,
        ['<C-l>'] = false,
        ['<M-v>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
        ['<M-s>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
    },
})

local fzf = require('fzf-lua')
fzf.setup({
    fzf_opts = { ['--cycle'] = '' },
    winopts = {
        height = 0.85,
        width = 0.80,
        row = 0.50,
        col = 0.50,
        border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
        backdrop = 60,
        preview = {
            hidden = 'hidden',
            vertical = 'up:55%',
            horizontal = 'right:60%',
            layout = 'flex',
            flip_columns = 150,
        },
    },
    keymap = {
        fzf = {
            true,
            ['alt-u'] = 'unix-line-discard',
            ['ctrl-d'] = 'half-page-down',
            ['ctrl-u'] = 'half-page-up',
            ['ctrl-f'] = 'preview-page-down',
            ['ctrl-b'] = 'preview-page-up',
        },
        builtin = {
            true,
            ['<C-f>'] = 'preview-page-down',
            ['<C-b>'] = 'preview-page-up',
        },
    },
})

vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Files' })
vim.keymap.set('n', '<leader>fo', fzf.oldfiles, { desc = 'Oldfiles' })
vim.keymap.set('n', '<leader>fq', fzf.quickfix, { desc = 'Qf' })
vim.keymap.set('n', '<leader>fl', fzf.blines, { desc = 'Lines' })
vim.keymap.set('n', '<leader>ft', fzf.tabs, { desc = 'Tabs' })
vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = 'Lgrep' })
vim.keymap.set('x', '<leader>sg', fzf.grep_visual, { desc = 'Lgrep visual' })
vim.keymap.set('n', '<leader>sG', fzf.live_grep_resume, { desc = 'Lgrep resume' })
vim.keymap.set('n', '<leader>sq', fzf.lgrep_quickfix, { desc = 'Lgrep qf' })
vim.keymap.set('n', '<leader>sl', fzf.lgrep_curbuf, { desc = 'Lgrep lines' })
vim.keymap.set('n', '<leader>sr', '<cmd>GrugFar<cr>', { desc = 'replace' })
vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'oil' })

fzf.register_ui_select()
