return {
    {
        'tpope/vim-fugitive',
        cmd = { 'G', 'Git', 'Gvdiffsplit' },
        config = function()
            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup(vim.g.whoami .. '/mini_git_setup', { clear = true }),
                pattern = { 'fugitive', 'fugitiveblame' },
                callback = function(e) vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = e.buf }) end,
            })
        end,
    },
    {
        'lewis6991/gitsigns.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            require('gitsigns').setup({
                signs = {
                    add = { text = '▒' },
                    change = { text = '▒' },
                    delete = { text = '▒' },
                    topdelete = { text = '▒' },
                    changedelete = { text = '▒' },
                    untracked = { text = '▒' },
                },
                signs_staged = {
                    add = { text = '▒' },
                    change = { text = '▒' },
                    delete = { text = '▒' },
                    topdelete = { text = '▒' },
                    changedelete = { text = '▒' },
                    untracked = { text = '▒' },
                },
                attach_to_untracked = true,
                preview_config = {
                    border = 'rounded',
                },
                on_attach = function(bufnr)
                    local gs = require('gitsigns')
                    local function map(lhs, rhs, desc, mode)
                        vim.keymap.set(mode or 'n', lhs, rhs, { desc = desc, buffer = bufnr })
                    end

                    map(']h', gs.next_hunk, 'Next hunk')
                    map('[h', gs.prev_hunk, 'Previous hunk')
                    map('<leader>hs', gs.stage_hunk, 'Stage hunk', { 'n', 'x' })
                    map('<leader>hr', gs.reset_hunk, 'Reset hunk', { 'n', 'x' })

                    map('<leader>hS', gs.stage_buffer, 'Stage buffer')
                    map('<leader>hu', gs.undo_stage_hunk, 'Undo stage hunk')
                    map('<leader>hR', gs.reset_buffer, 'Reset buffer')
                    map('<leader>hp', gs.preview_hunk_inline, 'Preview hunk')
                    map('<leader>hb', gs.blame_line, 'Blame line')
                    map('<leader>hd', gs.diffthis, 'Diff this')
                    map('<leader>hx', gs.setqflist, 'Populate Quickfix')

                    map('<leader>td', gs.toggle_deleted, 'Toggle deleted')
                    map('<leader>tb', gs.toggle_current_line_blame, 'Toggle line blame')

                    vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<cr>')
                end,
            })
        end,
    },
}
