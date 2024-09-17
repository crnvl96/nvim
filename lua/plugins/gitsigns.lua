return {
    {
        'lewis6991/gitsigns.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        opts = {
            signs = {
                add = { text = '▒' },
                untracked = { text = '▒' },
                change = { text = '▒' },
                delete = { text = '▒' },
                topdelete = { text = '▒' },
                changedelete = { text = '▒' },
            },
            signs_staged = {
                add = { text = '▒' },
                untracked = { text = '▒' },
                change = { text = '▒' },
                delete = { text = '▒' },
                topdelete = { text = '▒' },
                changedelete = { text = '▒' },
            },
            preview_config = { border = 'rounded' },
            attach_to_untracked = true,
            on_attach = function(bufnr)
                local gitsigns = package.loaded.gitsigns

                local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { desc = desc, buffer = bufnr }) end

                map('n', ']c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ ']c', bang = true })
                    else
                        gitsigns.nav_hunk('next')
                    end
                end, 'Next hunk')

                map('n', '[c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ '[c', bang = true })
                    else
                        gitsigns.nav_hunk('prev')
                    end
                end, 'Previous hunk')

                vim.keymap.set('n', '<leader>h', '', { desc = 'Git Hunks' })
                vim.keymap.set('n', '<leader>t', '', { desc = 'Toggle' })

                map('n', '<leader>hs', gitsigns.stage_hunk, 'Stage hunk')
                map('n', '<leader>hr', gitsigns.reset_hunk, 'Reset hunk')
                map(
                    'v',
                    '<leader>hs',
                    function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
                    'Stage hunk'
                )
                map(
                    'v',
                    '<leader>hr',
                    function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
                    'Reset hunk'
                )
                map('n', '<leader>hS', gitsigns.stage_buffer, 'Stage buffer')
                map('n', '<leader>hu', gitsigns.undo_stage_hunk, 'Undo stage hunk')
                map('n', '<leader>hR', gitsigns.reset_buffer, 'Reset buffer')
                map('n', '<leader>hp', gitsigns.preview_hunk_inline, 'Preview hunk')
                map('n', '<leader>hb', function() gitsigns.blame_line({ full = true }) end, 'Blame line')
                map('n', '<leader>hd', gitsigns.diffthis, 'Diff this')
                map('n', '<leader>hD', function() gitsigns.diffthis('~') end, 'Diff this ~')

                map('n', '<leader>tb', gitsigns.toggle_current_line_blame, 'Toggle line blame')
                map('n', '<leader>td', gitsigns.toggle_deleted, 'Toggle deleted')

                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Select hunk')
            end,
        },
    },
}
