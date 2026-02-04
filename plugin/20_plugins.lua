MiniDeps.now(function()
    require('mini.extra').setup()
    require('mini.statusline').setup()
    require('mini.comment').setup()
    require('mini.move').setup()
    require('mini.align').setup()
    MiniDeps.add 'tpope/vim-fugitive'
end)

MiniDeps.now(function()
    require('mini.keymap').setup()

    require('mini.keymap').map_combo({ 'i', 'c', 'x', 's' }, 'jk', '<BS><BS><Esc>')
    require('mini.keymap').map_combo({ 'i', 'c', 'x', 's' }, 'kj', '<BS><BS><Esc>')
    require('mini.keymap').map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
    require('mini.keymap').map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')

    require('mini.keymap').map_combo({ 'n', 'i', 'x', 'c' }, '<Esc><Esc>', function()
        vim.cmd 'nohlsearch'
    end)
end)

MiniDeps.now(function()
    MiniDeps.add 'sainnhe/gruvbox-material'

    vim.g.gruvbox_material_background = 'hard'
    vim.g.gruvbox_material_enable_bold = 1
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_better_performance = 1

    vim.cmd.colorscheme 'gruvbox-material'
end)

MiniDeps.later(function()
    require('mini.colors').setup()
    MiniColors.get_colorscheme():add_transparency():apply()
end)

MiniDeps.now(function()
    require('mini.misc').setup()
    MiniMisc.setup_auto_root()
    MiniMisc.setup_restore_cursor()
end)

MiniDeps.later(function()
    local build = function(args)
        MiniMisc.put 'Building dependencies of markdown-preview.nvim'
        local cmd = { 'npm', 'install', '--prefix', string.format('%s/app', args.path) }
        local obj = vim.system(cmd, { text = true }):wait()
        if obj.code ~= 0 then
            MiniMisc.put 'An error occurred while building dependencies of markdown-preview.nvim'
        else
            vim.print(vim.inspect(obj))
        end
    end

    MiniDeps.add {
        source = 'iamcco/markdown-preview.nvim',
        hooks = {
            post_install = function(args)
                MiniDeps.later(function()
                    build(args)
                end)
            end,
            post_checkout = function(args)
                MiniDeps.later(function()
                    build(args)
                end)
            end,
        },
    }
end)

MiniDeps.later(function()
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

MiniDeps.later(function()
    MiniDeps.add 'ibhagwan/fzf-lua'

    local actions = require 'fzf-lua.actions'

    require('fzf-lua').setup {
        { 'border-fused', 'hide' },
        fzf_colors = {
            bg = { 'bg', 'Normal' },
            gutter = { 'bg', 'Normal' },
            info = { 'fg', 'Conditional' },
            scrollbar = { 'bg', 'Normal' },
            separator = { 'fg', 'Comment' },
        },
        fzf_opts = {
            ['--info'] = 'default',
            ['--layout'] = 'reverse-list',
        },
        keymap = {
            builtin = {
                ['<C-/>'] = 'toggle-help',
                ['<C-i>'] = 'toggle-preview',
            },
            fzf = {
                ['alt-s'] = 'toggle',
                ['alt-a'] = 'toggle-all',
                ['ctrl-i'] = 'toggle-preview',
            },
        },
        winopts = {
            height = 0.7,
            width = 0.55,
            preview = {
                scrollbar = false,
                layout = 'vertical',
                vertical = 'up:40%',
            },
        },
        defaults = {
            git_icons = false,
        },
        previewers = {
            codeaction = {
                toggle_behavior = 'extend',
            },
        },
        files = {
            winopts = {
                preview = {
                    hidden = true,
                },
            },
        },
        grep = {
            hidden = true,
            rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g "!.git" -e',
            rg_glob_fn = function(query, opts)
                local regex, flags = query:match(string.format('^(.*)%s(.*)$', opts.glob_separator))
                return (regex or query), flags
            end,
        },
        helptags = { actions = { ['enter'] = actions.help_vert } },
        lsp = {
            code_actions = {
                winopts = {
                    width = 70,
                    height = 20,
                    relative = 'cursor',
                    preview = {
                        hidden = true,
                        vertical = 'down:50%',
                    },
                },
            },
        },
        diagnostics = {
            multiline = 1,
            actions = {
                ['ctrl-e'] = {
                    fn = function(_, opts)
                        if opts.severity_only then
                            opts.severity_only = nil
                        else
                            opts.severity_only = vim.diagnostic.severity.ERROR
                        end
                        require('fzf-lua').resume(opts)
                    end,
                    noclose = true,
                    desc = 'toggle-all-only-errors',
                    header = function(opts)
                        return opts.severity_only and 'show all' or 'show only errors'
                    end,
                },
            },
        },
        oldfiles = {
            include_current_session = true,
            winopts = {
                preview = {
                    hidden = true,
                },
            },
        },
    }

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(items, opts, on_choice)
        local ui_select = require 'fzf-lua.providers.ui_select'

        if not ui_select.is_registered() then
            ui_select.register(function(ui_opts)
                ui_opts.winopts = { height = 0.5, width = 0.4 }

                if ui_opts.kind then
                    ui_opts.winopts.title = string.format(' %s ', ui_opts.kind)
                end

                if ui_opts.prompt and not vim.endswith(ui_opts.prompt, ' ') then
                    ui_opts.prompt = ui_opts.prompt .. ' '
                end

                return ui_opts
            end)
        end

        if #items > 0 then
            return vim.ui.select(items, opts, on_choice)
        end
    end

    vim.keymap.set('n', '<leader>fl', function()
        local opts = {
            winopts = {
                height = 0.6,
                width = 0.5,
                preview = { vertical = 'up:70%' },
                treesitter = {
                    enabled = false,
                    fzf_colors = { ['fg'] = { 'fg', 'CursorLine' }, ['bg'] = { 'bg', 'Normal' } },
                },
            },
            fzf_opts = {
                ['--layout'] = 'reverse',
            },
        }

        -- Use grep when in normal mode and blines in visual mode since the former doesn't support
        -- searching inside visual selections.
        -- See https://github.com/ibhagwan/fzf-lua/issues/2051
        local mode = vim.api.nvim_get_mode().mode
        if vim.startswith(mode, 'n') then
            require('fzf-lua').lgrep_curbuf(opts)
        else
            require('fzf-lua').blines(opts)
        end
    end)

    vim.keymap.set('n', '<leader>fb', function()
        require('fzf-lua').buffers()
    end)

    vim.keymap.set('n', '<leader>fH', function()
        require('fzf-lua').highlights()
    end)

    vim.keymap.set('n', '<leader>fx', function()
        require('fzf-lua').lsp_document_diagnostics()
    end)

    vim.keymap.set('n', '<leader>ff', function()
        require('fzf-lua').files()
    end)

    vim.keymap.set('n', '<leader>fg', function()
        require('fzf-lua').live_grep()
    end)

    vim.keymap.set('x', '<leader>fg', function()
        require('fzf-lua').grep_visual()
    end)

    vim.keymap.set('n', '<leader>fh', function()
        require('fzf-lua').help_tags()
    end)

    vim.keymap.set('n', '<leader>fo', function()
        require('fzf-lua').oldfiles()
    end)

    vim.keymap.set('n', '<leader>fk', function()
        require('fzf-lua').keymaps()
    end)

    vim.keymap.set('n', '<leader>fr', function()
        require('fzf-lua').resume()
    end)

    vim.keymap.set('i', '<C-x><C-f>', function()
        require('fzf-lua').complete_path {
            winopts = {
                height = 0.4,
                width = 0.5,
                relative = 'cursor',
            },
        }
    end)
end)

MiniDeps.later(function()
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

    vim.keymap.set('n', '<leader>ed', function()
        MiniFiles.open()
    end)

    vim.keymap.set('n', '<leader>ef', function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0))
    end)
end)
