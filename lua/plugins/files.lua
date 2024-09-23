return {
    {
        'christoomey/vim-tmux-navigator',
        keys = {
            { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
            { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
            { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
            { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
            { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
        },
    },
    {
        'ibhagwan/fzf-lua',
        cmd = 'FzfLua',
        config = function()
            require('fzf-lua').register_ui_select()

            require('fzf-lua').setup({
                fzf_opts = {
                    ['--info'] = 'default',
                    ['--layout'] = 'reverse-list',
                    ['--cycle'] = '',
                },
                defaults = {
                    file_icons = 'mini',
                },
                winopts = {
                    preview = {
                        scrollbar = false,
                        hidden = 'hidden',
                        vertical = 'up:70%',
                        layout = 'vertical',
                    },
                },
                keymap = {
                    fzf = {
                        true,
                        ['ctrl-d'] = 'half-page-down',
                        ['ctrl-u'] = 'half-page-up',
                        ['ctrl-f'] = 'preview-page-down',
                        ['ctrl-b'] = 'preview-page-up',
                        ['ctrl-a'] = 'select-all',
                        ['ctrl-o'] = 'toggle-all',
                    },
                },
                grep = {
                    rg_glob = true,
                },
                oldfiles = {
                    include_current_session = true,
                },
            })
        end,
        keys = {
            { '<Leader>f,', '<cmd>FzfLua<CR>', desc = 'Menu' },
            { '<Leader>fl', '<cmd>FzfLua lgrep_curbuf<CR>', desc = 'Grep buffer' },
            { '<Leader>f>', '<cmd>FzfLua resume<CR>', desc = 'Resume' },
            { '<Leader>fk', '<cmd>FzfLua keymaps<CR>', desc = 'Maps' },
            { '<Leader>fc', '<cmd>FzfLua highlights<CR>', desc = 'Highlights' },
            { '<Leader>ff', '<cmd>FzfLua files<CR>', desc = 'Files' },
            { '<Leader>fo', '<cmd>FzfLua oldfiles<CR>', desc = 'Oldfiles' },
            { '<Leader>fh', '<cmd>FzfLua help<CR>', desc = 'Help' },
            { '<Leader>fg', '<cmd>FzfLua live_grep_native<CR>', desc = 'Grep' },
            { '<Leader>fg', '<cmd>FzfLua grep_visual<CR>', desc = 'Grep visual', mode = 'x' },
            { '<Leader>fr', '<cmd>FzfLua live_grep_resume<CR>', desc = 'Resume last grep' },
            { '<Leader>fx', '<cmd>FzfLua quickfix<CR>', desc = 'Quickfix' },
        },
    },
    {
        'echasnovski/mini.files',
        config = function()
            require('mini.files').setup({
                mappings = {
                    show_help = '?',
                    go_in_plus = '<CR>',
                    go_out_plus = '-',
                    go_in = '',
                    go_out = '',
                },
                windows = { width_nofocus = 25 },
                options = { permanent_delete = false },
            })

            local function open_split(buf_id, lhs, direction)
                local function rhs()
                    local window = require('mini.files').get_explorer_state().target_window
                    if window == nil or require('mini.files').get_fs_entry().fs_type == 'directory' then return end
                    local new_target_window

                    vim.api.nvim_win_call(window, function()
                        vim.cmd(direction .. ' split')
                        new_target_window = vim.api.nvim_get_current_win()
                    end)

                    require('mini.files').set_target_window(new_target_window)
                    require('mini.files').go_in({ close_on_file = true })
                end

                vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = 'Split ' .. string.sub(direction, 12) })
            end

            local files_grug_far_replace = function()
                local cur_entry_path = require('mini.files').get_fs_entry().path

                local prefills = { paths = vim.fs.dirname(cur_entry_path) }

                local grug_far = require('grug-far')

                if not grug_far.has_instance('explorer') then
                    grug_far.open({
                        instanceName = 'explorer',
                        prefills = prefills,
                        staticTitle = 'Find and Replace from Explorer',
                    })
                else
                    grug_far.open_instance('explorer')
                    grug_far.update_instance_prefills('explorer', prefills, false)
                end
            end

            vim.api.nvim_create_autocmd('User', {
                desc = 'Add rounded corners to minifiles window',
                pattern = 'MiniFilesWindowOpen',
                callback = function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'rounded' }) end,
            })

            vim.api.nvim_create_autocmd('User', {
                desc = 'Add minifiles split keymaps',
                pattern = 'MiniFilesBufferCreate',
                callback = function(args)
                    open_split(args.data.buf_id, '<C-s>', 'belowright horizontal')
                    open_split(args.data.buf_id, '<C-v>', 'belowright vertical')
                end,
            })

            vim.api.nvim_create_autocmd('User', {
                pattern = 'MiniFilesBufferCreate',
                callback = function(args)
                    vim.keymap.set(
                        'n',
                        'gs',
                        files_grug_far_replace,
                        { buffer = args.data.buf_id, desc = 'Search in directory' }
                    )
                end,
            })
        end,
        keys = {
            {
                '-',
                function()
                    local bufname = vim.api.nvim_buf_get_name(0)
                    local path = vim.fn.fnamemodify(bufname, ':p')

                    if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
                end,
                desc = 'File explorer',
            },
        },
    },
}
