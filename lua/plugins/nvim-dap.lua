return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'mfussenegger/nvim-dap-python',
    'theHamsta/nvim-dap-virtual-text',
  },
  config = function()
    local function json_decode(data)
      local decode = vim.json.decode
      local strip_comments = require('plenary.json').json_strip_comments
      data = strip_comments(data)

      return decode(data)
    end

    vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

    local debugpy = require('mason-registry').get_package('debugpy'):get_install_path()

    require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })
    require('dap-python').setup(debugpy .. '/venv/bin/python')
    require('dap.ext.vscode').json_decode = json_decode
  end,
  keys = {
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'dap: toggle breakpoint' },
    { '<leader>dc', function() require('dap').continue() end, desc = 'dap: continue execution' },
    { '<leader>dC', function() require('dap').run_to_cursor() end, desc = 'dap: run to cursor' },
    { '<leader>dx', function() require('dap').clear_breakpoints() end, desc = 'dap: clear breakpoints' },
    { '<leader>dt', function() require('dap').terminate() end, desc = 'dap: terminate session' },
    { '<leader>da', function() require('dap.repl').toggle({}, 'belowright split') end, desc = 'dap: repl' },
    { '<leader>de', function() require('dap.ui.widgets').hover() end, desc = 'dap: hover', mode = { 'n', 'v' } },
    {
      '<leader>ds',
      function()
        local dap_widgets = require('dap.ui.widgets')
        local vsplit = function(widget) dap_widgets.sidebar(widget, {}, 'vsplit').toggle() end
        vsplit(dap_widgets.scopes)
      end,
      desc = 'dap: scopes',
    },
    {
      '<leader>df',
      function()
        local dap_widgets = require('dap.ui.widgets')
        local hsplit = function(widget) dap_widgets.sidebar(widget, { height = 10 }, 'belowright split').toggle() end
        hsplit(dap_widgets.frames)
      end,
      desc = 'dap: frames',
    },
    {
      '<leader>dpc',
      function() require('dap-python').test_class() end,
      desc = 'dap: debug class (py)',
      ft = 'python',
    },
    {
      '<leader>dpt',
      function() require('dap-python').test_method() end,
      desc = 'dap: debug method (py)',
      ft = 'python',
    },
  },
}
