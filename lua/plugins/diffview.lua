local deps = require('mini.deps')
local add = deps.add
add('sindrets/diffview.nvim')

local diffview = require('diffview')
diffview.setup()
