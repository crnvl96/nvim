return {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        require('gitsigns').setup({
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
                local gs = package.loaded.gitsigns

                local function nmap(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { desc = desc, buffer = bufnr }) end

                local opts = function()
                    return {
                        size = {
                            width = 0.95,
                            height = 0.9,
                        },
                        cwd = vim.b.gitsigns_status_dict.root,
                    }
                end

                nmap('[h', gs.prev_hunk, 'Previous hunk')
                nmap(']h', gs.next_hunk, 'Next hunk')
                nmap('<leader>hs', gs.stage_hunk, 'Stage hunk')
                nmap('<leader>hr', gs.reset_hunk, 'Reser hunk')
                nmap('<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Stage hunk')
                nmap('<leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Reset hunk')
                nmap('<leader>hu', gs.undo_stage_hunk, 'Undo stage hunk')
                nmap('<leader>hS', gs.stage_buffer, 'Stage buffer')
                nmap('<leader>hR', gs.reset_buffer, 'Reset buffer')
                nmap('<leader>hp', gs.preview_hunk_inline, 'Preview hunk')
                nmap('<leader>hb', function() gs.blame_line({ full = true }) end, 'Blame line')
                nmap('<leader>hd', gs.diffthis, 'Diff this')
                nmap('<leader>hD', function() gs.diffthis('~') end, 'Diff this (~)')

                nmap('<leader>cd', gs.toggle_deleted, 'Toggle deleted')
                nmap('<leader>cb', gs.toggle_current_line_blame, 'Toggle line blame')

                nmap('<leader>tg', function() require('term').float_term('lazygit', opts()) end, 'Git')
                nmap('<leader>to', function() require('term').float_term('lazydocker', opts()) end, 'Docker')
                nmap('<leader>tt', function() require('term').float_term(nil, opts()) end, 'Terminal')

                vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<cr>')
            end,
        })
    end,
}
