MiniDeps.later(function()
  MiniDeps.add 'MeanderingProgrammer/render-markdown.nvim'

  require('render-markdown').setup {
    completions = {
      blink = { enabled = true },
    },
    file_types = {
      'markdown',
      'codecompanion',
    },
    code = {
      disable_background = true,
    },
  }
end)
