return {
    {
        'lewis6991/gitsigns.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        opts = function()
            local signs = {
                add = { text = '▒' },
                untracked = { text = '▒' },
                change = { text = '▒' },
                delete = { text = '▒' },
                topdelete = { text = '▒' },
                changedelete = { text = '▒' },
            }

            return {
                signs = signs,
                signs_staged = signs,
                preview_config = { border = 'rounded' },
                attach_to_untracked = true,
                on_attach = function(bufnr)
                    vim.keymap.set('n', ']c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({ ']c', bang = true })
                        else
                            require('gitsigns').nav_hunk('next')
                        end
                    end, { desc = 'Next hunk', buffer = bufnr })

                    vim.keymap.set('n', '[c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({ '[c', bang = true })
                        else
                            require('gitsigns').nav_hunk('prev')
                        end
                    end, { desc = 'Previous hunk', buffer = bufnr })

                    vim.keymap.set(
                        'n',
                        '<leader>hs',
                        function() require('gitsigns').stage_hunk() end,
                        { desc = 'Stage hunk', buffer = bufnr }
                    )

                    vim.keymap.set(
                        'n',
                        '<leader>hr',
                        function() require('gitsigns').reset_hunk() end,
                        { desc = 'Reset hunk', buffer = bufnr }
                    )

                    vim.keymap.set(
                        'v',
                        '<leader>hs',
                        function() require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
                        { desc = 'Stage hunk', buffer = bufnr }
                    )
                    vim.keymap.set(
                        'v',
                        '<leader>hr',
                        function() require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
                        { desc = 'Reset hunk', buffer = bufnr }
                    )

                    vim.keymap.set(
                        'n',
                        '<leader>hS',
                        function() require('gitsigns').stage_buffer() end,
                        { desc = 'Stage buffer', buffer = bufnr }
                    )

                    vim.keymap.set(
                        'n',
                        '<leader>hu',
                        function() require('gitsigns').undo_stage_hunk() end,
                        { desc = 'Undo stage hunk', buffer = bufnr }
                    )

                    vim.keymap.set(
                        'n',
                        '<leader>hR',
                        function() require('gitsigns').reset_buffer() end,
                        { desc = 'Reset buffer', buffer = bufnr }
                    )

                    vim.keymap.set(
                        'n',
                        '<leader>hx',
                        function() require('gitsigns').setqflist() end,
                        { desc = 'Populate Quickfix', buffer = bufnr }
                    )

                    vim.keymap.set(
                        'n',
                        '<leader>hp',
                        function() require('gitsigns').preview_hunk_inline() end,
                        { desc = 'Preview hunk', buffer = bufnr }
                    )

                    vim.keymap.set(
                        'n',
                        '<leader>hb',
                        function() require('gitsigns').blame_line({ full = true }) end,
                        { desc = 'Blame line', buffer = bufnr }
                    )

                    vim.keymap.set(
                        'n',
                        '<leader>hd',
                        function() require('gitsigns').diffthis() end,
                        { desc = 'Diff this', buffer = bufnr }
                    )

                    vim.keymap.set(
                        'n',
                        '<leader>hD',
                        function() require('gitsigns').diffthis('~') end,
                        { desc = 'Diff this ~', buffer = bufnr }
                    )

                    vim.keymap.set(
                        'n',
                        '<leader>tb',
                        function() require('gitsigns').toggle_current_line_blame() end,
                        { desc = 'Toggle line blame', buffer = bufnr }
                    )

                    vim.keymap.set(
                        'n',
                        '<leader>td',
                        function() require('gitsigns').toggle_deleted() end,
                        { desc = 'Toggle deleted', buffer = bufnr }
                    )

                    vim.keymap.set(
                        { 'o', 'x' },
                        'ih',
                        ':<C-U>Gitsigns select_hunk<CR>',
                        { desc = 'Select hunk', buffer = bufnr }
                    )
                end,
            }
        end,
    },
}
