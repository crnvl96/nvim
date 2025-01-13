return function()
  require('deck').start({
    require('deck.builtin.source.buffers')(),
  })
end
