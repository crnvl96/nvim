require('mason').setup()

vim.schedule(function()
  require('mason-registry').refresh(function()
    for _, tool in ipairs({
      'stylua',
      'prettier',
      'gofumpt',
      'pyproject-fmt',

      'json-lsp', -- jsonls
      'yaml-language-server', -- yamlls
      'bacon',
      'bacon-ls', -- bacon_ls
      'rust-analyzer',
      'taplo',
      'gopls',
      'biome',
      'css-lsp', -- cssls
      'eslint-lsp', -- eslint
      'lua-language-server', -- lua_ls
      'pyright',
      'ruff',
      'typescript-language-server', -- ts_ls
      'tailwindcss-language-server', -- tailwindcss
      'jq', -- json
    }) do
      local p = require('mason-registry').get_package(tool)
      if not p:is_installed() then p:install() end
    end
  end)
end)
