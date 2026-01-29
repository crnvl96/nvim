---@diagnostic disable: undefined-global

local ltr = MiniDeps.later

ltr(function()
  if vim.fn.executable 'rg' == 1 then
    ---@diagnostic disable-next-line: unused-local
    function _G.RgFindFiles(cmdarg, _cmdcomplete)
      local fnames = vim.fn.systemlist 'rg --files --hidden --color=never --glob="!.git"'
      if #cmdarg == 0 then
        return fnames
      else
        return vim.fn.matchfuzzy(fnames, cmdarg)
      end
    end
    vim.o.findfunc = 'v:lua.RgFindFiles'
  end

  ---Debounce func on trailing edge.
  ---@generic F: function
  ---@param func F
  ---@param delay_ms number
  ---@return F
  local function debounce(func, delay_ms)
    ---@type uv.uv_timer_t?
    local timer = nil
    ---@type boolean?
    local running = nil
    return function(...)
      if not running then timer = assert(vim.uv.new_timer()) end
      local argv = { ... }
      assert(timer):start(delay_ms, 0, function()
        assert(timer):stop()
        running = nil
        func(unpack(argv, 1, table.maxn(argv)))
      end)
    end
  end

  local function is_cmdline_type_find()
    local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]

    return cmdline_cmd == 'find' or cmdline_cmd == 'fin'
  end

  vim.api.nvim_create_autocmd({ 'CmdlineChanged', 'CmdlineLeave' }, {
    pattern = { '*' },
    group = vim.api.nvim_create_augroup('CmdlineAutocompletion', { clear = true }),
    callback = debounce(
      vim.schedule_wrap(function(ev)
        local function should_enable_autocomplete()
          local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]
          local cmdline_type = vim.fn.getcmdtype()
          return cmdline_type == '/'
            or cmdline_type == '?'
            or (
              cmdline_type == ':'
              and (
                is_cmdline_type_find()
                or cmdline_cmd == 'help'
                or cmdline_cmd == 'h'
                or cmdline_cmd == 'buffer'
                or cmdline_cmd == 'b'
              )
            )
        end

        if ev.event == 'CmdlineChanged' and should_enable_autocomplete() then vim.fn.wildtrigger() end
      end),
      100
    ),
  })
end)
