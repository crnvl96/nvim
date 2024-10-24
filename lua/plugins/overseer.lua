return {
  'stevearc/overseer.nvim',
  opts = {
    templates = {
      'builtin',
      'rust.run-bacon-ls',
      'rust.setup-bacon-ls',
    },
    dap = false,
    task_list = {
      default_detail = 1,
      direction = 'left',
      bindings = {
        ['<C-d>'] = 'ScrollOutputUp',
        ['<C-u>'] = 'ScrollOutputDown',
        ['H'] = 'IncreaseAllDetail',
        ['L'] = 'DecreaseAllDetail',
        ['<C-h>'] = false,
        ['<C-j>'] = false,
        ['<C-k>'] = false,
        ['<C-l>'] = false,
      },
    },
    form = { border = 'double' },
    confirm = { border = 'double' },
    task_win = { border = 'double' },
    help_win = { border = 'double' },
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
