return {
  'echasnovski/mini.animate',
  event = 'VeryLazy',
  opts = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'grug-far',
      callback = function() vim.b.minianimate_disable = true end,
    })

    Snacks.toggle({
      name = 'Mini Animate',
      get = function() return not vim.g.minianimate_disable end,
      set = function(state) vim.g.minianimate_disable = not state end,
    }):map('<leader>ua')

    return {
      scroll = {
        enable = false,
      },
      cursor = {
        enable = false,
      },
    }
  end,
}
