---@diagnostic disable: undefined-global

local ltr = MiniDeps.later

ltr(
  function()
    vim.diagnostic.config {
      signs = {
        priority = 9999,
        severity = { min = 'HINT', max = 'ERROR' },
      },
      underline = {
        severity = {
          min = 'HINT',
          max = 'ERROR',
        },
      },
      virtual_text = {
        current_line = true,
        severity = { min = 'ERROR', max = 'ERROR' },
      },
      virtual_lines = false,
      update_in_insert = false,
    }
  end
)
