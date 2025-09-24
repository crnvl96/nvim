---@type vim.lsp.Config
return {
  cmd = { 'gopls' },
  root_markers = { 'go.mod' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
      semanticTokens = true,
      codelenses = {
        gc_details = true,
        generate = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
      },
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedvariable = true,
        unusedwrite = true,
        useany = true,
        ST1000 = false, -- Incorrect or missing package comment
      },
      directoryFilters = {
        '-.git',
        '-node_modules',
      },
    },
  },
}
