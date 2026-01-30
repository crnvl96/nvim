---@diagnostic disable: unused-local
---@type vim.lsp.Config

return {
    settings = {},
    init_options = {
        settings = {
            logLevel = 'debug',
            fixAll = true,
            organizeImports = true,
            lint = {
                enable = true,
            },
            format = {
                backend = 'uv',
            },
        },
    },
    capabilities = {
        general = {
            positionEncodings = { 'utf-16' },
        },
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.hoverProvider = false -- Use hovers from Pyright
    end,
}
