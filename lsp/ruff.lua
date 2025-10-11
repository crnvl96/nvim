---@type vim.lsp.Config
return {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
    settings = {},
    init_options = {
        settings = {
            logLevel = 'debug',
            fixAll = true,
            organizeImports = true,
            lint = { enable = true },
            format = { backend = 'uv' },
        },
    },
    capabilities = {
        general = { positionEncodings = { 'utf-16' } },
    },
    on_attach = function(client, _bufnr)
        client.server_capabilities.hoverProvider = false
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
}
