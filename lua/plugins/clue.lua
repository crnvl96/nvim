require('mini.clue').setup({
    triggers = {
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = '`' },
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'n', keys = "'" },
        { mode = 'x', keys = "'" },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },
        { mode = 'n', keys = '<C-w>' },
        { mode = 'i', keys = '<C-x>' },
        { mode = 'n', keys = 'z' },
        { mode = 'n', keys = '<leader>' },
        { mode = 'x', keys = '<leader>' },
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },
    },
    clues = {
        { mode = 'n', keys = '[', desc = '+prev' },
        { mode = 'n', keys = ']', desc = '+next' },
        { mode = 'n', keys = '<leader>b', desc = '+buffers' },
        { mode = 'n', keys = '<leader>d', desc = '+dap' },
        { mode = 'n', keys = '<leader>f', desc = '+files' },
        { mode = 'x', keys = '<leader>f', desc = '+files' },
        { mode = 'n', keys = '<leader>h', desc = '+hunks' },
        { mode = 'x', keys = '<leader>h', desc = '+hunks' },
        { mode = 'n', keys = '<leader>t', desc = '+tabs' },
        { mode = 'n', keys = '<leader>x', desc = '+list' },
        -- { mode = 'n', keys = '<leader>s', desc = '+search' },
        -- { mode = 'x', keys = '<leader>s', desc = '+search' },
        { mode = 'n', keys = '<leader><tab>', desc = '+tabs' },
        require('mini.clue').gen_clues.builtin_completion(),
        require('mini.clue').gen_clues.g(),
        require('mini.clue').gen_clues.marks(),
        require('mini.clue').gen_clues.registers(),
        require('mini.clue').gen_clues.windows(),
        require('mini.clue').gen_clues.z(),
    },
    window = {
        delay = 200,
        scroll_down = '<C-f>',
        scroll_up = '<C-b>',
        config = {
            width = 'auto',
        },
    },
})

vim.api.nvim_create_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup(vim.g.whoami .. '/delete_unwanted_keymaps', {}),
    once = true,
    callback = function()
        for _, lhs in ipairs({ '[%', ']%', 'g%' }) do
            vim.keymap.del('n', lhs)
        end
    end,
})
