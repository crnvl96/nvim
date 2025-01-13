return function()
  local bufnr = vim.api.nvim_get_current_buf()
  local modes = { 'n', 'i', 'v', 'x', 'o', 'c' }
  local maps = {}

  for _, mode in ipairs(modes) do
    local mode_maps = vim.api.nvim_get_keymap(mode)
    local buf_mode_maps = vim.api.nvim_buf_get_keymap(bufnr, mode)

    for _, map in ipairs(mode_maps) do
      local lhs = map.lhs
      if lhs ~= nil and lhs:sub(1, 1) == ' ' then lhs = '<Leader>' .. lhs:sub(2) end

      map['display_text'] =
        string.format('%s | %s → %s %s', mode, lhs, map.rhs or '', map.desc and ('(' .. map.desc .. ')') or '')
      table.insert(maps, map)
    end

    for _, map in ipairs(buf_mode_maps) do
      local lhs = map.lhs
      if lhs ~= nil and lhs:sub(1, 1) == ' ' then lhs = '<Leader>' .. lhs:sub(2) end

      map['display_text'] = string.format(
        '%s | %s → %s %s (buffer)',
        mode,
        lhs,
        map.rhs or '',
        map.desc and ('(' .. map.desc .. ')') or ''
      )
      table.insert(maps, map)
    end
  end

  require('deck').start({
    name = 'Keymaps',
    execute = function(ctx)
      for _, map in ipairs(maps) do
        ctx.item(map)
      end

      ctx.done()
    end,
    actions = {
      {
        name = 'default',
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
