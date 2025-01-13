return function()
  require('deck').start(require('deck.builtin.source.lines')({
    bufnrs = { vim.api.nvim_get_current_buf() },
  }))
end
