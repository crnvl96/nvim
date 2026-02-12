MiniDeps.later(function()
  local build = function(args)
    MiniMisc.put('Building dependencies of markdown-preview.nvim')
    local cmd = { 'npm', 'install', '--prefix', string.format('%s/app', args.path) }
    local obj = vim.system(cmd, { text = true }):wait()
    if obj.code ~= 0 then
      MiniMisc.put('An error occurred while building dependencies of markdown-preview.nvim')
    else
      vim.print(vim.inspect(obj))
    end
  end

  MiniDeps.add({
    source = 'iamcco/markdown-preview.nvim',
    hooks = {
      post_install = function(args)
        MiniDeps.later(function() build(args) end)
      end,
      post_checkout = function(args)
        MiniDeps.later(function() build(args) end)
      end,
    },
  })
end)
