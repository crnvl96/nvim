---@diagnostic disable: undefined-global

local add, now, ltr = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
    require('mini.extra').setup()
    require('mini.statusline').setup()
    require('mini.comment').setup()
    require('mini.move').setup()
    require('mini.align').setup()
    add 'tpope/vim-fugitive'
end)

now(function()
    add 'sainnhe/gruvbox-material'

    vim.g.gruvbox_material_background = 'hard'
    vim.g.gruvbox_material_enable_bold = 1
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_better_performance = 1

    vim.cmd.colorscheme 'gruvbox-material'
end)

ltr(function()
    require('mini.colors').setup()
    MiniColors.get_colorscheme():add_transparency():apply()
end)

now(function()
    require('mini.misc').setup()
    MiniMisc.setup_auto_root()
    MiniMisc.setup_restore_cursor()
end)

ltr(function()
    local build = function(args)
        put 'Building dependencies of markdown-preview.nvim'
        local put = MiniMisc.put
        local cmd = { 'npm', 'install', '--prefix', string.format('%s/app', args.path) }
        local obj = vim.system(cmd, { text = true }):wait()
        if obj.code ~= 0 then
            put 'An error occurred while building dependencies of markdown-preview.nvim'
        else
            vim.print(vim.inspect(obj))
        end
    end

    add {
        source = 'iamcco/markdown-preview.nvim',
        hooks = {
            post_install = function(args)
                ltr(function()
                    build(args)
                end)
            end,
            post_checkout = function(args)
                ltr(function()
                    build(args)
                end)
            end,
        },
    }
end)

ltr(function()
    local ai = require 'mini.ai'

    ai.setup {
        custom_textobjects = {
            g = MiniExtra.gen_ai_spec.buffer(),
            f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
            c = ai.gen_spec.treesitter { a = '@comment.outer', i = '@comment.inner' },
            o = ai.gen_spec.treesitter { a = '@conditional.outer', i = '@conditional.inner' },
            l = ai.gen_spec.treesitter { a = '@loop.outer', i = '@loop.inner' },
        },
        search_method = 'cover',
    }
end)

ltr(function()
    add 'ibhagwan/fzf-lua'

    require('fzf-lua').setup()
    require('fzf-lua').register_ui_select()

    local set = vim.keymap.set

    set({ 'n', 'x' }, '<leader>fl', function()
        if vim.startswith(vim.api.nvim_get_mode().mode, 'n') then
            require('fzf-lua').lgrep_curbuf(opts)
        else
            require('fzf-lua').blines(opts)
        end
    end, { desc = 'Search current buffer' })

    set('n', '<leader>fb', '<Cmd>FzfLua buffers<CR>', { desc = 'Buffers' })
    set('n', '<leader>fH', '<Cmd>FzfLua highlights<CR>', { desc = 'Highlights' })
    set('n', '<leader>fx', '<Cmd>FzfLua lsp_document_diagnostics<CR>', { desc = 'Document diagnostics' })
    set('n', '<leader>ff', '<Cmd>FzfLua files<CR>', { desc = 'Find files' })
    set('n', '<leader>fg', '<Cmd>FzfLua live_grep<CR>', { desc = 'Grep' })
    set('x', '<leader>fg', '<Cmd>FzfLua grep_visual<CR>', { desc = 'Grep' })
    set('n', '<leader>fh', '<Cmd>FzfLua help_tags<CR>', { desc = 'Help' })
    set('n', '<leader>fo', '<Cmd>FzfLua oldfiles<CR>', { desc = 'Recently opened files' })
    set('n', '<leader>fr', '<Cmd>FzfLua resume<CR>', { desc = 'Resume last fzf command' })
    set('i', '<C-x><C-f>', '<Cmd>FzfLua complete_path<CR>')
end)

ltr(function()
    local files = require 'mini.files'

    files.setup {
        mappings = {
            go_in = '',
            go_in_plus = '<CR>',
            go_out = '',
            go_out_plus = '-',
        },
        windows = {
            preview = true,
            width_focus = 50,
            width_nofocus = 15,
            width_preview = 80,
        },
    }

    local set = vim.keymap.set

    local dir_cmd = '<Cmd>lua MiniFiles.open()<CR>'
    local file_cmd = '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>'

    set('n', '<leader>ed', dir_cmd, { desc = 'Directory' })
    set('n', '<leader>ef', file_cmd, { desc = 'File' })
end)
