MiniDeps.now(function()
  MiniDeps.add {
    source = 'mason-org/mason.nvim',
    hooks = { post_checkout = function() vim.cmd 'MasonUpdate' end },
  }

  local ensure_installed = {
    'stylua',
    'prettier',
    'ruff',
    'css-lsp',
    'eslint-lsp',
    'basedpyright',
    'lua-language-server',
    'vtsls',
    'biome',
    'typescript-language-server',
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
