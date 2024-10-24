return {
  'mfussenegger/nvim-dap',
  dependencies = {
    { 'mfussenegger/nvim-dap-python' },
    { 'theHamsta/nvim-dap-virtual-text' },
  },
  config = function()
    local M = require('config.functions')

    local function json_decode(data)
      local decode = vim.json.decode
      local strip_comments = require('plenary.json').json_strip_comments
      data = strip_comments(data)

      return decode(data)
    end

    M.hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

    local debugpy = require('mason-registry').get_package('debugpy'):get_install_path()

    require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })
    require('overseer').enable_dap()
    require('dap-python').setup(debugpy .. '/venv/bin/python')
    require('dap.ext.vscode').json_decode = json_decode
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
        local scopes = widgets.sidebar(widgets.scopes, {}, 'vsplit')
        scopes.toggle()
      end,
      desc = 'scopes',
    },
    {
      '<leader>da',
      function()
        local repl = require('dap.repl')
        repl.toggle({}, 'belowright split')
      end,
      desc = 'repl',
    },
    {
      '<leader>df',
      function()
        local widgets = require('dap.ui.widgets')
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
