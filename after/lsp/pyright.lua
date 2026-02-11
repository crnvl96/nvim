---@type vim.lsp.Config
return {
  settings = {
    pyright = {
      disableOrganizeImports = true, -- Using linter's import organizer
    },
    python = {
      analysis = {
        ignore = { '*' }, -- Ignore all files for analysis to exclusively use dedicated linting
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
}
