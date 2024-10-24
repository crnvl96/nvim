return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = ' '
    else
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    -- PERF: we don't need this lualine require madness
    local lualine_require = require('lualine_require')
    lualine_require.require = require

    local icons = {
      misc = {
        dots = '󰇘',
      },
      ft = {
        octo = '',
      },
      dap = {
        Stopped = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
        Breakpoint = ' ',
        BreakpointCondition = ' ',
        BreakpointRejected = { ' ', 'DiagnosticError' },
        LogPoint = '.>',
      },
      diagnostics = {
        Error = ' ',
        Warn = ' ',
        Hint = ' ',
        Info = ' ',
      },
      git = {
        added = ' ',
        modified = ' ',
        removed = ' ',
      },
      kinds = {
        Array = ' ',
        Boolean = '󰨙 ',
        Class = ' ',
        Codeium = '󰘦 ',
        Color = ' ',
        Control = ' ',
        Collapsed = ' ',
        Constant = '󰏿 ',
        Constructor = ' ',
        Copilot = ' ',
        Enum = ' ',
        EnumMember = ' ',
        Event = ' ',
        Field = ' ',
        File = ' ',
        Folder = ' ',
        Function = '󰊕 ',
        Interface = ' ',
        Key = ' ',
        Keyword = ' ',
        Method = '󰊕 ',
        Module = ' ',
        Namespace = '󰦮 ',
        Null = ' ',
        Number = '󰎠 ',
        Object = ' ',
        Operator = ' ',
        Package = ' ',
        Property = ' ',
        Reference = ' ',
        Snippet = ' ',
        String = ' ',
        Struct = '󰆼 ',
        Supermaven = ' ',
        TabNine = '󰏚 ',
        Text = ' ',
        TypeParameter = ' ',
        Unit = ' ',
        Value = ' ',
        Variable = '󰀫 ',
      },
    }

    vim.o.laststatus = vim.g.lualine_laststatus

    local trouble = require('trouble')
    local trouble_symbols = trouble.statusline({
      mode = 'symbols',
      groups = {},
      title = false,
      filter = { range = true },
      format = '{kind_icon}{symbol.name:Normal}',
      hl_group = 'lualine_c_normal',
    })

    return {
      options = {
        theme = 'auto',
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = {
          statusline = {
            'snacks_dashboard',
          },
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = {
          {
            'diagnostics',
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
          {
            trouble_symbols.get,
            cond = function() return vim.b.trouble_lualine ~= false and trouble_symbols.has() end,
          },
        },
        lualine_x = {
          'overseer',
          {
            require('noice').api.status.message.get_hl,
            cond = require('noice').api.status.message.has,
          },
          {
            require('noice').api.status.command.get,
            cond = require('noice').api.status.command.has,
            color = { fg = '#ff9e64' },
          },
          {
            require('noice').api.status.mode.get,
            cond = require('noice').api.status.mode.has,
            color = { fg = '#ff9e64' },
          },
          {
            require('noice').api.status.search.get,
            cond = require('noice').api.status.search.has,
            color = { fg = '#ff9e64' },
          },
          {
            function() return '  ' .. require('dap').status() end,
            cond = function() return package.loaded['dap'] and require('dap').status() ~= '' end,
          },
          {
            require('lazy.status').updates,
            cond = require('lazy.status').has_updates,
          },
          {
            'diff',
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = {
          { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
          { 'location', padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function() return ' ' .. os.date('%R') end,
        },
      },
      extensions = { 'lazy' },
    }
  end,
}
