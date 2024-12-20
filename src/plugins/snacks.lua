require('snacks').setup({
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
})

Snacks.toggle.option('spell'):map('<leader>us', { desc = 'toggle: spelling' })
Snacks.toggle.option('wrap'):map('<leader>uw', { desc = 'toggle: wrap' })
Snacks.toggle.option('relativenumber'):map('<leader>uL', { desc = 'toggle: relative number' })
Snacks.toggle.option('conceallevel', { off = 0, on = 2 }):map('<leader>uc', { desc = 'toggle: conceal' })

Snacks.toggle.diagnostics():map('<leader>ud', { desc = 'toggle: diagnostics' })
Snacks.toggle.line_number():map('<leader>ul', { desc = 'toggle: line number' })
Snacks.toggle.treesitter():map('<leader>uT', { desc = 'toggle: treesitter' })
Snacks.toggle.inlay_hints():map('<leader>uh', { desc = 'toggle: inlay hints' })
Snacks.toggle.indent():map('<leader>ug', { desc = 'toggle: indent' })
Snacks.toggle.dim():map('<leader>uD', { desc = 'toggle: dim' })

Snacks.toggle
  .option('background', { off = 'light', on = 'dark' })
  :map('<leader>ub', { desc = 'toggle: dark background' })
