return {
  name = 'setup bacon-ls',
  builder = function()
    return {
      cmd = 'bash',
      args = {
        '-c',
        'cat > bacon.toml << EOL\n[export]\nenabled = true\npath = ".bacon-locations"\nline_format = "{kind}:{path}:{line}:{column}:{message}"\nEOL',
      },
      components = {
        { 'on_complete_dispose', timeout = 1 },
        'default',
      },
    }
  end,
  condition = {
    filetype = { 'rust' },
    callback = function(search) return not vim.fs.find({ 'bacon.toml' }, { path = search.dir, upward = true })[1] end,
  },
}
