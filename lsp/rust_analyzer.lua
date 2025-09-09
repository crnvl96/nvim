return {
  capabilities = {
    general = {
      positionEncodings = { 'utf-16' },
    },
  },
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        buildScripts = {
          enable = true,
        },
      },
      checkOnSave = false, -- Remove clippy lints for Rust due to bacon
      diagnostics = { enable = false }, -- Disable diagnostics due to bacon
      procMacro = {
        enable = true,
        ignored = {
          ['async-trait'] = { 'async_trait' },
          ['napi-derive'] = { 'napi' },
          ['async-recursion'] = { 'async_recursion' },
        },
      },
      files = {
        excludeDirs = {
          '.direnv',
          '.git',
          '.github',
          '.gitlab',
          'bin',
          'node_modules',
          'target',
          'venv',
          '.venv',
        },
      },
    },
  },
}
