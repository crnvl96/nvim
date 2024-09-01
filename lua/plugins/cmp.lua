local add = MiniDeps.add

add({ source = 'hrsh7th/cmp-buffer' })
add({ source = 'hrsh7th/cmp-path' })
add({ source = 'hrsh7th/cmp-nvim-lua' })
add({ source = 'hrsh7th/cmp-nvim-lsp' })
add({ source = 'hrsh7th/nvim-cmp' })

local cmp = require('cmp')
local cmp_defaults = require('cmp.config.default')()
local cmp_types = require('cmp.types')

cmp.setup({
    snippet = {
        expand = function(args) vim.snippet.expand(args.body) end,
    },
    sorting = cmp_defaults.sorting,
    preselect = cmp.PreselectMode.None,
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping({
            i = function(fallback)
                if cmp.visible() and cmp.get_active_entry() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                else
                    fallback()
                end
            end,
        }),
    }),
    sources = cmp.config.sources({
        {
            name = 'nvim_lsp',
            entry_filter = function(entry)
                local kind = entry:get_kind()
                local type = cmp_types.lsp.CompletionItemKind[kind]
                return type ~= 'Text' and type ~= 'Snippet'
            end,
        },
        { name = 'nvim_lua' },
        { name = 'path' },
    }, {
        { name = 'buffer' },
    }),
})
