local U = require('utils')

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

U.nmap('<Leader>z', terminal, 'Terminal')
U.nmap('<Leader>x', opencode, 'Opencode')
U.nmap('<Leader>v', lazygit, 'Lazygit')
