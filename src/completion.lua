local cmp = require('cmp')
local defaults = require('cmp.config.default')()

cmp.setup({
    preselect = cmp.PreselectMode.None,
    sorting = defaults.sorting,
    formatting = { fields = { 'kind', 'abbr', 'menu' } },
    snippet = { expand = function(args) vim.snippet.expand(args.body) end },
    performance = { max_view_entries = 10 },
    mapping = cmp.mapping.preset.insert({
        ['<C-f>'] = cmp.mapping.complete({ config = { sources = { { name = 'path' } } } }),
        ['<cr>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp', keyword_length = 2 },
        { name = 'nvim_lua', keyword_length = 2 },
    }, {
        {
            name = 'buffer',
            keyword_length = 3,
            option = {
                get_bufnrs = function()
                    local bufs = {}

                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        local buf = vim.api.nvim_win_get_buf(win)
                        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size < (250 * 1024) then table.insert(bufs, buf) end
                    end

                    return bufs
                end,
            },
        },
    }),
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = 'buffer' } },
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = 'path' } }, {
        { name = 'cmdline' },
    }),
    matching = { disallow_symbol_nonprefix_matching = false },
})
