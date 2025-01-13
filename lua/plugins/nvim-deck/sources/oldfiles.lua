return function()
  require('deck').start({
    require('deck.builtin.source.recent_files')(),
  })
end
