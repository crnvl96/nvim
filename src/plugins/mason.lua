require('mason').setup()

Later(function()
  local mr = require('mason-registry')

  mr:on('package:install:success', function()
    vim.defer_fn(function() vim.cmd([[do FileType]]) end, 100)
  end)

  mr.refresh(function()
    for _, tool in ipairs({
      -- javascript/typescript
      'vtsls',
      'eslint_d',
      'deno',
      'prettierd',

      -- lua
      'lua-language-server',
      'stylua',
      'selene',

      -- python
      'basedpyright',
      'ruff',
      'debugpy',

      -- LaTex
      'tectonic',
    }) do
      local p = mr.get_package(tool)
      if not p:is_installed() then p:install() end
    end
  end)
end)
