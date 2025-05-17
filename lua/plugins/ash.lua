MiniDeps.now(function()
  MiniDeps.add 'drewxs/ash.nvim'

  require('ash').setup {
    transparent = true,
    highlights = function(colors)
      return {
        LineNr = { fg = colors.text },
        CursorLineNr = { fg = colors.text },
        LineNrAbove = { fg = colors.text },
        LineNrBelow = { fg = colors.text },
      }
    end,
  }

  vim.cmd [[colorscheme ash]]
end)
