local binds = require('utils.bind')

local function terminal() Snacks.terminal() end
local function lazygit() Snacks.lazygit() end
local function opencode() Snacks.terminal('opencode') end

require('snacks').setup({
  terminal = {
    win = {
      border = 'single',
    },
  },
  styles = {
    terminal = {
      height = 0.95,
      width = 0.95,
    },
    lazygit = {
      height = 0.95,
      width = 0.95,
    },
  },
})

binds.nmap('<Leader>z', terminal, 'Terminal')
binds.nmap('<Leader>x', opencode, 'Opencode')
binds.nmap('<Leader>v', lazygit, 'Lazygit')
