return {
  name = 'start bacon-ls',
  builder = function()
    return {
      cmd = 'bacon',
      args = { 'clippy', '--', '--all-features' },
    }
  end,
  condition = {
    filetype = { 'rust' },
  },
}
