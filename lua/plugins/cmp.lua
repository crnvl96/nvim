return {
    'echasnovski/mini.completion',
    event = 'InsertEnter',
    config = function()
        require('mini.completion').setup({
            lsp_completion = {
                source_func = 'omnifunc',
                auto_setup = false,
                process_items = function(items, base)
                    items = vim.tbl_filter(function(x) return x.kind ~= 1 and x.kind ~= 15 end, items)
                    return require('mini.completion').default_process_items(items, base)
                end,
            },
            window = {
                info = { border = 'rounded' },
                signature = { border = 'rounded' },
            },
            set_vim_settings = false,
        })

        if vim.fn.has('nvim-0.11') == 1 then vim.opt.completeopt:append('fuzzy,menuone,noinsert,noselect,popup') end

        local keycode = vim.keycode or function(x) return vim.api.nvim_replace_termcodes(x, true, true, true) end
        local keys = {
            ['cr'] = keycode('<CR>'),
            ['ctrl-y'] = keycode('<C-y>'),
            ['ctrl-y_cr'] = keycode('<C-y><CR>'),
        }

        _G.cr_action = function()
            if vim.fn.pumvisible() ~= 0 then
                local item_selected = vim.fn.complete_info()['selected'] ~= -1
                return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
            else
                return keys['cr']
            end
        end

        vim.keymap.set('i', '<CR>', 'v:lua._G.cr_action()', { expr = true })
    end,
    -- { 'hrsh7th/cmp-nvim-lsp' },
    -- {
    --     'hrsh7th/nvim-cmp',
    --     event = 'InsertEnter',
    --     dependencies = {
    --         'hrsh7th/cmp-path',
    --         'hrsh7th/cmp-buffer',
    --         'hrsh7th/cmp-nvim-lua',
    --     },
    --     config = function()
    --         local cmp = require('cmp')
    --
    --         cmp.setup({
    --             snippet = {
    --                 expand = function(args) vim.snippet.expand(args.body) end,
    --             },
    --             window = {
    --                 completion = cmp.config.window.bordered(),
    --                 documentation = cmp.config.window.bordered(),
    --             },
    --             sorting = require('cmp.config.default')().sorting,
    --             preselect = cmp.PreselectMode.None,
    --             mapping = cmp.mapping.preset.insert({ ['<C-Space>'] = cmp.mapping.complete() }),
    --             sources = cmp.config.sources({
    --                 {
    --                     name = 'nvim_lsp',
    --                     entry_filter = function(entry)
    --                         local type = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
    --                         return type ~= 'Text' and type ~= 'Snippet'
    --                     end,
    --                 },
    --                 { name = 'nvim_lua' },
    --                 { name = 'path' },
    --                 { name = 'buffer' },
    --             }),
    --         })
    --     end,
    -- },
}
