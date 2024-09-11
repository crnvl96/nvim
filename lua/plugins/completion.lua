require('mini.deps').add('hrsh7th/cmp-buffer')
require('mini.deps').add('hrsh7th/cmp-path')
require('mini.deps').add('hrsh7th/cmp-nvim-lua')
require('mini.deps').add('hrsh7th/cmp-nvim-lsp')
require('mini.deps').add('hrsh7th/nvim-cmp')

local cmp = require('cmp')

cmp.setup({
    snippet = {
        expand = function(args) vim.snippet.expand(args.body) end,
    },
    sorting = require('cmp.config.default')().sorting,
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
    sources = cmp.config.sources(require('config.tools').cmp_sources),
})
