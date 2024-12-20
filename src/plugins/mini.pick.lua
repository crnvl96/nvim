require('mini.pick').setup({
  options = {
    use_cache = true,
  },
  window = {
    config = {
      border = 'double',
    },
    prompt_cursor = '_',
    prompt_prefix = '',
  },
})

vim.ui.select = MiniPick.ui_select

MiniPick.registry.multigrep = function()
  local process
  local symbol = '%'
  local set_items_opts = { do_match = false }
  local spawn_opts = { cwd = MiniMisc.find_root() }

  local match = function(_, _, query)
    pcall(vim.loop.process_kill, process)
    if #query == 0 then return MiniPick.set_picker_items({}, set_items_opts) end
    local full_query = table.concat(query)
    local parts = vim.split(full_query, symbol, { plain = true })

    -- First part is always the search pattern
    local search_pattern = parts[1] and parts[1] ~= '' and parts[1] or nil

    local command = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    }

    -- Add search pattern if exists
    if search_pattern then
      table.insert(command, '-e')
      table.insert(command, search_pattern)
    end

    -- Process file patterns
    local include_patterns = {}
    local exclude_patterns = {}

    for i = 2, #parts do
      local pattern = parts[i]
      if pattern:sub(1, 1) == '!' then
        table.insert(exclude_patterns, pattern:sub(2))
      else
        table.insert(include_patterns, pattern)
      end
    end

    if #include_patterns > 0 then
      for _, pattern in ipairs(include_patterns) do
        table.insert(command, '-g')
        table.insert(command, pattern)
      end
    end

    if #exclude_patterns > 0 then
      for _, pattern in ipairs(exclude_patterns) do
        table.insert(command, '-g')
        table.insert(command, '!' .. pattern)
      end
    end

    process = MiniPick.set_picker_items_from_cli(command, {
      postprocess = function(lines)
        local results = {}
        for _, line in ipairs(lines) do
          if line ~= '' then
            local file, lnum, col = line:match('([^:]+):(%d+):(%d+):(.*)')
            if file then
              results[#results + 1] = {
                path = file,
                lnum = tonumber(lnum),
                col = tonumber(col),
                text = line,
              }
            end
          end
        end
        return results
      end,
      set_items_opts = set_items_opts,
      spawn_opts = spawn_opts,
    })
  end

  return MiniPick.start({
    source = {
      items = {},
      name = 'Multi Grep',
      match = match,
      show = function(buf_id, items_to_show, query)
        MiniPick.default_show(buf_id, items_to_show, query, { show_icons = true })
      end,
      choose = MiniPick.default_choose,
    },
  })
end
