return {
    { 'hrsh7th/cmp-nvim-lsp' },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lua',
        },
        config = function()
            local cmp = require('cmp')

            cmp.setup({
                snippet = { expand = function(args) vim.snippet.expand(args.body) end },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                sorting = require('cmp.config.default')().sorting,
                preselect = cmp.PreselectMode.None,
                mapping = cmp.mapping.preset.insert({ ['<C-Space>'] = cmp.mapping.complete() }),
                sources = cmp.config.sources({
                    {
                        name = 'nvim_lsp',
                        entry_filter = function(entry)
                            local type = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
                            return type ~= 'Text' and type ~= 'Snippet'
                        end,
                    },
                    { name = 'nvim_lua' },
                    { name = 'path' },
                    { name = 'buffer' },
                }),
            })
        end,
    },
}
