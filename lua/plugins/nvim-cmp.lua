local deps = require('mini.deps')
local add = deps.add

add('hrsh7th/cmp-nvim-lsp')
add('hrsh7th/cmp-path')
add('hrsh7th/cmp-buffer')
add('hrsh7th/cmp-nvim-lua')
add('hrsh7th/nvim-cmp')

local cmp = require('cmp')

cmp.setup({
    snippet = { expand = function(args) vim.snippet.expand(args.body) end },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    sorting = require('cmp.config.default')().sorting,
    preselect = cmp.PreselectMode.None,
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
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
