_G.Hooks = {}

Hooks.mkdp = {
  post_checkout = function()
    MiniDeps.later(function() vim.fn['mkdp#util#install']() end)
  end,
  post_install = function()
    MiniDeps.later(function() vim.fn['mkdp#util#install']() end)
  end,
}

Hooks.fzf = {
  post_checkout = function()
    MiniDeps.later(function() vim.fn['fzf#install']() end)
  end,
  post_install = function()
    MiniDeps.later(function() vim.fn['fzf#install']() end)
  end,
}
