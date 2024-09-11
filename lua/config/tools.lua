local function first(buf, ...)
    local conform = require('conform')
    for i = 1, select('#', ...) do
        local formatter = select(i, ...)
        if conform.get_formatter_info(formatter, buf).available then return formatter end
    end

    return select(1, ...)
end

return {
    servers = {},
    formatters = {},
    debuggers = {},
    cmp_sources = {
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
    },
    ts_parsers = {
        'c',
        'vim',
        'vimdoc',
        'query',
        'markdown',
        'markdown_inline',
    },
    conform_by_ft = {
        markdown = function(buf) return { first(buf, 'prettierd', 'prettier'), 'injected' } end,
        json = { 'prettierd', 'prettier', stop_after_first = true },
        jsonc = { 'prettierd', 'prettier', stop_after_first = true },
        json5 = { 'prettierd', 'prettier', stop_after_first = true },
    },
    theme = {
        base00 = '#181818',
        base01 = '#282828',
        base02 = '#383838',
        base03 = '#585858',
        base04 = '#b8b8b8',
        base05 = '#d8d8d8',
        base06 = '#e8e8e8',
        base07 = '#f8f8f8',
        base08 = '#ab4642',
        base09 = '#dc9656',
        base0A = '#f7ca88',
        base0B = '#a1b56c',
        base0C = '#86c1b9',
        base0D = '#7cafc2',
        base0E = '#ba8baf',
        base0F = '#a16946',
    },
}
