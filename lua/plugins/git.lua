return {
    {
        'tpope/vim-fugitive',
        cmd = { 'Git', 'G', 'Gvdiffsplit' },
        config = function()
            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup(vim.g.whoami .. '/fugitive_group', {}),
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

                    nmap('[h', gs.prev_hunk, 'Previous hunk')
                    nmap(']h', gs.next_hunk, 'Next hunk')
                    nmap('<leader>hR', gs.reset_buffer, 'Reset buffer')
                    nmap('<leader>hb', gs.blame_line, 'Blame line')
                    nmap('<leader>hp', gs.preview_hunk, 'Preview hunk')
                    nmap('<leader>hr', gs.reset_hunk, 'Reset hunk')
                    nmap('<leader>hs', gs.stage_hunk, 'Stage hunk')
                    nmap(
                        '<leader>hl',
                        function()
                            require('term').float_term('lazygit', {
                                size = { width = 0.95, height = 0.9 },
                                cwd = vim.b.gitsigns_status_dict.root,
                            })
                        end,
                        'Lazygit'
                    )

                    -- Text object:
                    vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<cr>')
                end,
            })
        end,
    },
}
