vim.lsp.config('ruff', {
  on_init = function(client) client.server_capabilities.hoverProvider = false end,
  root_dir = function(bufnr, on_dir)
    if not bufnr then return end
    local root = vim.fs.root(bufnr, { 'pyproject.toml' })
    if root then on_dir(root) end
  end,
  init_options = {
    settings = {
      lineLength = 88,
      logLevel = 'debug',
    },
  },
})
