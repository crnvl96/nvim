---@type vim.lsp.Config
return {
  settings = {
    pyright = {
      -- Using linter's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use dedicated linting
        ignore = { '*' },
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
}
