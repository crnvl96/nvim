return {
  name = 'setup bacon-ls',
  builder = function()
    return {
      cmd = 'bash',
      -- Create a file with the following content inside it
      args = {
        '-c',
        'cat > bacon.toml << EOL\n[export]\nenabled = true\npath = ".bacon-locations"\nline_format = "{kind}:{path}:{line}:{column}:{message}"\nEOL',
      },
      -- After One second, remove the task from list
      components = {
        { 'on_complete_dispose', timeout = 1 },
        'default',
      },
    }
  end,
  -- Enable this task only on rust files that doesn't have a `bacon.toml` at its root level
  condition = {
    filetype = { 'rust' },
    callback = function(search) return not vim.fs.find({ 'bacon.toml' }, { path = search.dir, upward = true })[1] end,
  },
}
