-- https://docs.libuv.org/en/v1.x/index.html
--
-- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/lua/nvim-treesitter/parsers.lua
-- https://github.com/nvim-treesitter/nvim-treesitter/tree/main/runtime/queries
-- https://github.com/romus204/tree-sitter-manager.nvim
-- https://github.com/arborist-ts/registry/blob/main/parsers.toml
--
-- https://github.com/neovim/neovim/blob/master/INSTALL.md#linux

local Config = {}
_G.Config = Config

Config.gr = vim.api.nvim_create_augroup('custom-config', {})
Config.set = vim.keymap.set

vim.cmd([[packadd nvim.difftool]])
vim.cmd([[packadd cfilter]])
vim.cmd([[colorscheme ansi]])

vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('vim._core.ui2').enable({
  enable = true,
  msg = {
    targets = 'msg',
    cmd = { height = 0.5 },
    dialog = { height = 0.5 },
    msg = { height = 0.5, timeout = 4000 },
    pager = { height = 1 },
  },
})
