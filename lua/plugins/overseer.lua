return {
  'stevearc/overseer.nvim',
  opts = {
    templates = {
      'builtin',
      -- These are located at `lua/overseer/templates`
      'rust.setup-bacon-ls',
      'rust.start-bacon-ls',
    },
    dap = false,
    task_list = {
      max_height = { 40, 0.2 },
      min_height = 20,
      bindings = {
        ['<C-u>'] = 'ScrollOutputUp',
        ['<C-d>'] = 'ScrollOutputDown',
        ['H'] = 'IncreaseAllDetail',
        ['L'] = 'DecreaseAllDetail',
        ['<C-h>'] = false,
        ['<C-j>'] = false,
        ['<C-k>'] = false,
        ['<C-l>'] = false,
      },
    },
  },
  keys = {
    {
      '<leader>oo',
      '<cmd>OverseerToggle<cr>',
      desc = 'toggle task window',
    },
    {
      '<leader>o<',
      function()
        local notify = require('config.functions').notify
        local overseer = require('overseer')

        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
          notify.info('No tasks found')
        else
          overseer.run_action(tasks[1], 'restart')
          overseer.open({ enter = false })
        end
      end,
      desc = 'restart last',
    },
    {
      '<leader>or',
      function()
        local overseer = require('overseer')

        overseer.run_template({}, function(task)
          if task then overseer.open({ enter = false }) end
        end)
      end,
      desc = 'run task',
    },
  },
}
