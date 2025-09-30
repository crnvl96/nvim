require('sidekick').setup({
  nes = {
    diff = { inline = 'chars' },
  },
  cli = {
    watch = true,
    win = {
      layout = 'right', ---@type "float"|"left"|"bottom"|"top"|"right"
      split = { width = 120 },
      keys = {
        hide_t = { '<C-.>', 'hide' },
        win_p = { '<C-o>', 'blur' },
        blur = { '<C-o>', 'blur' },
      },
    },
    mux = { enabled = false },
  },
  copilot = {
    status = { enabled = true },
  },
  debug = false,
})

require('snacks').setup({
  indent = {
    chunk = {
      enabled = true,
      only_current = true,
    },
  },
  input = {
    enabled = true,
  },
  scratch = {
    name = 'Scratch',
    ft = function() return 'markdown' end,
    filekey = {
      cwd = true, -- use current working directory
      branch = true, -- use current branch name
      count = true, -- use vim.v.count1
    },
  },
  statuscolumn = {
    enabled = true,
    left = { 'mark', 'sign' }, -- priority of signs on the left (high to low)
    right = { 'fold', 'git' }, -- priority of signs on the right (high to low)
  },
  styles = {
    terminal = {
      bo = { filetype = 'snacks_terminal' },
      wo = {},
      keys = { term_normal = { '<C-t>', '<C-\\><C-n><Cmd>close<CR>', mode = 't' } },
    },
  },
})

vim.keymap.set('n', '<Leader>.', function() Snacks.scratch() end)
vim.keymap.set('n', '<C-t>', function() Snacks.terminal() end)
vim.keymap.set('n', '<Leader>s', function() Snacks.lazygit() end)
vim.keymap.set('n', '<c-.>', function() require('sidekick.cli').focus() end)
vim.keymap.set('n', '<leader>ao', function() require('sidekick.cli').toggle({ name = 'opencode', focus = true }) end)
vim.keymap.set({ 'n', 'v' }, '<leader>ap', function() require('sidekick.cli').select_prompt() end)
-- stylua: ignore
vim.keymap.set('n', '<Tab>', function() if not require('sidekick').nes_jump_or_apply() then return '<Tab>' end end, { expr = true })
