Config.now_if_args(function() vim.pack.add({ 'https://github.com/OXY2DEV/markview.nvim' }) end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/HakonHarnes/img-clip.nvim' })
  require('img-clip').setup({
    default = {
      dir_path = 'static/img',
    },
  })
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/3rd/image.nvim' })
  require('image').setup({
    backend = 'kitty', -- or "ueberzug" or "sixel"
    processor = 'magick_cli', -- or "magick_rock"
  })
end)

Config.now_if_args(function()
  Config.on_packchanged('markdown-preview.nvim', { 'install', 'update' }, function(e)
    MiniMisc.log_add('Building dependencies', {
      name = e.data.spec.name,
      path = e.data.path,
    })

    local stdout = vim.system({ 'npm', 'install' }, { text = true, cwd = e.data.path .. '/app' }):wait()

    if stdout.code ~= 0 then
      MiniMisc.log_add('Error during dependencies build', { name = e.data.spec.name, path = e.data.path })
    else
      MiniMisc.log_add('Dependencies built', { name = e.data.spec.name, path = e.data.path })
    end
  end)

  vim.pack.add({ 'https://github.com/iamcco/markdown-preview.nvim' })
end)
