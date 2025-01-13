return function()
  local bufnr = vim.api.nvim_get_current_buf()
  local modes = { 'n', 'i', 'v', 'x', 'o', 'c' }

  local function format_maps(mode, maps, output_fmt)
    for _, map in ipairs(maps) do
      local lhs = map.lhs

      return vim.tbl_deep_extend('force', map or {}, {
        display_text = string.format(
          output_fmt,
          mode,
          (lhs ~= nil and lhs:sub(1, 1) == ' ') and '<Leader>' .. lhs:sub(2) or lhs,
          map.rhs or '',
          map.desc and ('(' .. map.desc .. ')') or ''
        ),
      })
    end
  end

  require('deck').start({
    name = 'Keymaps',
    execute = function(ctx)
      for _, mode in ipairs(modes) do
        local mode_maps = vim.api.nvim_get_keymap(mode)
        local buf_mode_maps = vim.api.nvim_buf_get_keymap(bufnr, mode)

        local maps = vim.list_extend(
          format_maps(mode, mode_maps, '%s | %s → %s %s'),
          format_maps(mode, buf_mode_maps, '%s | %s → %s %s (buffer)')
        )

        for _, map in ipairs(maps) do
          ctx.item(map)
        end
      end

      ctx.done()
    end,
    actions = {
      {
        name = 'execute_keymap',
        resolve = function(ctx) return #ctx.get_action_items() == 1 and ctx.get_action_items()[1].lhs end,
        execute = function(ctx)
          ctx.hide()
          local lhs = ctx.get_action_items()[1].lhs
          local keys = vim.api.nvim_replace_termcodes(lhs, true, true, true)
          vim.api.nvim_feedkeys(keys, 'm', false)
        end,
      },
    },
  })
end
