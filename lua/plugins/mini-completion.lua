return {
    'echasnovski/mini.completion',
    event = 'InsertEnter',
    config = function()
        require('mini.completion').setup({
            delay = { completion = 100, info = 100, signature = 100 },
            window = {
                info = { height = 25, width = 80, border = 'rounded' },
                signature = { height = 25, width = 80, border = 'rounded' },
            },
            lsp_completion = {
                source_func = 'omnifunc',
                auto_setup = false,
                process_items = function(items, base)
                    items = vim.tbl_filter(function(x) return x.kind ~= 1 and x.kind ~= 15 end, items)
                    return require('mini.completion').default_process_items(items, base)
                end,
            },
            set_vim_settings = true,
        })
    end,
    -- 'hrsh7th/nvim-cmp',
    -- event = 'InsertEnter',
    -- dependencies = {
    --     'hrsh7th/cmp-path',
    --     'hrsh7th/cmp-buffer',
    --     'hrsh7th/cmp-nvim-lua',
    --     'hrsh7th/cmp-nvim-lsp',
    -- },
    -- config = function()
    --     local cmp = require('cmp')
    --
    --     cmp.setup({
    --         snippet = {
    --             expand = function(args) vim.snippet.expand(args.body) end,
    --         },
    --         window = {
    --             completion = cmp.config.window.bordered(),
    --             documentation = cmp.config.window.bordered(),
    --         },
    --         sorting = require('cmp.config.default')().sorting,
    --         preselect = cmp.PreselectMode.None,
    --         mapping = cmp.mapping.preset.insert({ ['<C-Space>'] = cmp.mapping.complete() }),
    --         sources = cmp.config.sources({
    --             {
    --                 name = 'nvim_lsp',
    --                 entry_filter = function(entry)
    --                     local type = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
    --                     return type ~= 'Text' and type ~= 'Snippet'
    --                 end,
    --             },
    --             { name = 'nvim_lua' },
    --             { name = 'path' },
    --             { name = 'buffer' },
    --         }),
    --     })
    -- end,
}
