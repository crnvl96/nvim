---@type vim.lsp.Config

return {
    settings = {
        pyright = {
            disableOrganizeImports = true, -- Using Ruff's import organizer
        },
        python = {
            analysis = {
                ignore = { '*' }, -- Ignore all files for analysis to exclusively use Ruff for linting
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
            },
        },
    },
}
