return {
  'stevearc/overseer.nvim',
  opts = {
    templates = {
      'builtin',
      'rust.setup-bacon-ls',
      'rust.start-bacon-ls',
    },
    dap = false,
    task_list = {
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
      desc = 'Toggle task window',
    },
    {
      '<leader>o<',
      function()
        local overseer = require('overseer')

        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
          Snacks.notify.warn('No tasks found')
        else
          overseer.run_action(tasks[1], 'restart')
          overseer.open({ enter = false })
        end
      end,
      desc = 'Restart last task',
    },
    {
      '<leader>or',
      function()
        local overseer = require('overseer')

        overseer.run_template({}, function(task)
          if task then overseer.open({ enter = false }) end
        end)
      end,
      desc = 'Run task',
    },
  },
}
