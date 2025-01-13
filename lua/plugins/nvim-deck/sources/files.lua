return function()
  require('deck').start({
    require('deck.builtin.source.files')({
      root_dir = vim.uv.cwd(),
      ignore_globs = {
        '**/node_modules/**',
        '**/.git/**',
      },
    }),
  })
end
