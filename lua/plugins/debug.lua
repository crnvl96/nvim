return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'mfussenegger/nvim-dap-python',
    'theHamsta/nvim-dap-virtual-text',
  },
  config = function()
    -- Better visualization When debug stops on a breakpoint line
    vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

    --- Show current variable values as virtual text
    require('nvim-dap-virtual-text').setup()

    -- Enable overseer integration
    require('overseer').enable_dap()

    -- Enable debugger for python
    -- Get the package path from mason
    local package_path = require('mason-registry').get_package('debugpy'):get_install_path()

    -- Register the plugin with the found path
    require('dap-python').setup(package_path .. '/venv/bin/python')

    -- Allow support for jsonc
    require('dap.ext.vscode').json_decode = function(str)
      return vim.json.decode(require('plenary.json').json_strip_comments(str))
    end
  end,
  keys = {
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'toggle breakpoint' },
    { '<leader>dc', function() require('dap').continue() end, desc = 'continue execution' },
    { '<leader>dC', function() require('dap').run_to_cursor() end, desc = 'run to cursor' },
    { '<leader>dx', function() require('dap').clear_breakpoints() end, desc = 'clear breakpoints' },
    { '<leader>dt', function() require('dap').terminate() end, desc = 'terminate session' },
    { '<leader>dpt', function() require('dap-python').test_method() end, desc = 'debug method', ft = 'python' },
    { '<leader>dpc', function() require('dap-python').test_class() end, desc = 'debug class', ft = 'python' },
    {
      '<leader>ds',
      function()
        local widgets = require('dap.ui.widgets')
        -- set scopes as right pane
        local scopes = widgets.sidebar(widgets.scopes, {}, 'vsplit')

        scopes.toggle()
      end,
      desc = 'scopes',
    },
    {
      '<leader>da',
      function()
        local repl = require('dap.repl')
        return repl.toggle({}, 'belowright split')
      end,
      desc = 'repl',
    },
    {
      '<leader>df',
      function()
        local widgets = require('dap.ui.widgets')
        -- set frames as bottom pane
        local frames = widgets.sidebar(widgets.frames, { height = 10 }, 'belowright split')
        frames.toggle()
      end,
      desc = 'frames',
    },
    {
      '<leader>de',
      function()
        local widgets = require('dap.ui.widgets')
        widgets.hover()
      end,
      desc = 'hover',
    },
  },
}
