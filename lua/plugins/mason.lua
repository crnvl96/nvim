MiniDeps.now(function()
  MiniDeps.add 'mason-org/mason.nvim'

  local ensure_installed = {
    'stylua',
    'prettier',
    'ruff',
    'rubocop',
    'css-lsp',
    'eslint-lsp',
    'basedpyright',
    'lua-language-server',
    'vtsls',
    'ruby-lsp',
  }

  require('mason').setup()

  MiniDeps.later(function()
    local mr = require 'mason-registry'

    mr.refresh(function()
      for _, tool in ipairs(ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then p:install() end
      end
    end)
  end)
end)
