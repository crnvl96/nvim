Config.now_if_args(function() vim.pack.add({ 'https://github.com/b0o/SchemaStore.nvim' }) end)
Config.now_if_args(function() vim.pack.add({ 'https://github.com/tpope/vim-sleuth' }) end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/MagicDuck/grug-far.nvim' })

  require('grug-far').setup({
    folding = { enabled = false },
    resultLocation = { showNumberLabel = false },
  })

  Config.set_keymap({ 'n', 'x' }, '<Leader>ug', function()
    local grug = require('grug-far')
    grug.open({ transient = true })
  end, 'GrugFar')
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/folke/ts-comments.nvim' })
  require('ts-comments').setup({ lang = { typst = { '// %s', '/* %s */' } } })
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/folke/snacks.nvim' })

  local function term_nav(dir)
    return function(self)
      return self:is_floating() and '<c-' .. dir .. '>' or vim.schedule(function() vim.cmd.wincmd(dir) end)
    end
  end

  require('snacks').setup({
    terminal = {
      win = {
        position = 'float',
        width = math.floor(vim.o.columns * 0.85),
        height = math.floor(vim.o.lines * 0.85),
        bo = { filetype = 'snacks_terminal' },
        wo = {},
        stack = true,
        keys = {
          nav_h = { '<C-h>', term_nav('h'), desc = 'Go to Left Window', expr = true, mode = 't' },
          nav_j = { '<C-j>', term_nav('j'), desc = 'Go to Lower Window', expr = true, mode = 't' },
          nav_k = { '<C-k>', term_nav('k'), desc = 'Go to Upper Window', expr = true, mode = 't' },
          nav_l = { '<C-l>', term_nav('l'), desc = 'Go to Right Window', expr = true, mode = 't' },
        },
      },
    },
  })

  Config.set_keymap({ 'n', 't' }, '<M-1>', '<Cmd>lua Snacks.terminal()<CR>', 'Open Term')
  Config.set_keymap({ 'n', 't' }, '<M-2>', '<Cmd>lua Snacks.terminal("lazygit")<CR>', 'Open LazyGit')
  Config.set_keymap({ 'n', 't' }, '<M-3>', '<Cmd>lua Snacks.terminal("opencode")<CR>', 'Open OpenCode')
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' })
  require('lualine').setup()
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/tpope/vim-fugitive' })
  Config.set_keymap('n', '<Leader>gf', '<Cmd>Git<CR>', 'Open fugitive')
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/windwp/nvim-ts-autotag' })
  require('nvim-ts-autotag').setup()
end)
