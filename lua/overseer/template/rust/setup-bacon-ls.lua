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
        'on_complete_dispose',
        'default',
      },
    }
  end,
  condition = {
    filetype = { 'rust' },
  },
}
