---@type vim.lsp.Config
return {
    cmd = { 'efm-langserver' },
    filetypes = { 'lua' },
    root_markers = { '.git' },
    init_options = {
        documentFormatting = true,
    },
    settings = {
        languages = {
            lua = {
                {
                    formatCommand = "stylua --color Never --stdin-filepath '${INPUT}' -",
                    formatStdin = true,
                    rootMarkers = { 'stylua.toml', '.stylua.toml' },
                },
            },
        },
    },
}
