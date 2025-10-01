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
    mux = {
      backend = 'tmux',
      enabled = true,
    },
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
    lazygit = {
      position = 'float',
      backdrop = 60,
      height = 0.9,
      width = 0.9,
    },
    terminal = {
      bo = { filetype = 'snacks_terminal' },
      wo = {},
      keys = {
        term_normal = { '<C-t>', '<C-\\><C-n><Cmd>close<CR>', mode = 't' },
      },
    },
    scratch = {
      position = 'float',
      backdrop = 60,
      height = 0.9,
      width = 0.9,
    },
  },
})

vim.keymap.set('n', '<Leader>s', function() Snacks.scratch() end)
vim.keymap.set('n', '<C-t>', function() Snacks.terminal() end)
vim.keymap.set('n', '<Leader><Space>', function() Snacks.lazygit() end)

local Sq = require('sidekick')
local Cli = require('sidekick.cli')

vim.keymap.set({ 'n', 'x', 'i', 't' }, '<c-.>', function() Cli.focus() end)
vim.keymap.set({ 'n', 'v' }, '<leader>ap', function() Cli.prompt() end)

--- Open the opencode CLI and focus it
local function opencode() return Cli.toggle({ name = 'opencode', focus = true }) end
vim.keymap.set({ 'n', 'v' }, '<leader>ao', opencode)

--- Try to jump to the next nes action, or insert a <tab>
local function nes() return Sq.nes_jump_or_apply() or '<Tab>' end
vim.keymap.set('n', '<Tab>', nes, { expr = true })

require('which-key').setup({
  preset = 'helix',
  delay = 500,
  spec = {},
  win = {
    -- don't allow the popup to overlap with the cursor
    no_overlap = true,
    -- width = 1,
    -- height = { min = 4, max = 25 },
    -- col = 0,
    -- row = math.huge,
    -- border = "none",
    padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
    title = true,
    title_pos = 'center',
    zindex = 1000,
    -- Additional vim.wo and vim.bo options
    bo = {},
    wo = {
      -- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
    },
  },
})
