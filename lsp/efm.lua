---@type vim.lsp.Config
return {
    cmd = { 'efm-langserver' },
    filetypes = {
        'lua',
        'typescript',
        'markdown',
        'json',
        'jsonc',
        'yaml',
    },
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
            typescript = {
                {
                    formatCommand = "prettier --stdin-filepath '${INPUT}'",
                    formatStdin = true,
                },
            },
            markdown = {
                {
                    formatCommand = "prettier --parser markdown --stdin-filepath '${INPUT}'",
                    formatStdin = true,
                },
            },
            json = {
                {
                    formatCommand = "prettier --parser json --stdin-filepath '${INPUT}'",
                    formatStdin = true,
                },
            },
            jsonc = {
                {
                    formatCommand = "prettier --parser json --stdin-filepath '${INPUT}'",
                    formatStdin = true,
                },
            },
            yaml = {
                {
                    formatCommand = "prettier --parser yaml --stdin-filepath '${INPUT}'",
                    formatStdin = true,
                },
            },
        },
    },
}
