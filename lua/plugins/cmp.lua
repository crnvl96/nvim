return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-nvim-lua',
    },
    opts = function()
        local cmp = require('cmp')
        local defaults = require('cmp.config.default')()

        local function cmp_CR_action()
            return {
                i = function(fallback)
                    if cmp.visible() and cmp.get_active_entry() then
                        cmp.confirm({
                            behavior = cmp.ConfirmBehavior.Replace,
                            select = false,
                        })
                    else
                        fallback()
                    end
                end,
            }
        end

        local function cmp_lsp_entry_filter(entry)
            local type = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
            return type ~= 'Text' and type ~= 'Snippet'
        end

        return {
            snippet = {
                expand = function(args) vim.snippet.expand(args.body) end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            sorting = defaults.sorting,
            preselect = cmp.PreselectMode.None,
            mapping = cmp.mapping.preset.insert({
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping(cmp_CR_action()),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp', entry_filter = cmp_lsp_entry_filter },
                { name = 'nvim_lua' },
                { name = 'path' },
                { name = 'buffer' },
            }),
        }
    end,
    config = function(_, opts) require('cmp').setup(opts) end,
}
