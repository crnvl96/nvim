Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/b0o/SchemaStore.nvim' })
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/tpope/vim-sleuth' })
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/tpope/vim-fugitive' })
  Config.set_keymap('n', '<Leader>gf', '<Cmd>Git<CR>', 'Open fugitive')
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' })
  require('lualine').setup()
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/windwp/nvim-ts-autotag' })
  require('nvim-ts-autotag').setup()
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/folke/ts-comments.nvim' })
  require('ts-comments').setup({ lang = { typst = { '// %s', '/* %s */' } } })
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/MagicDuck/grug-far.nvim' })

  require('grug-far').setup({
    folding = { enabled = false },
    resultLocation = { showNumberLabel = false },
  })

  local function grug_search_replace()
    require('grug-far').open({ transient = true })
  end
  Config.set_keymap(
    { 'n', 'x' },
    '<Leader>ug',
    grug_search_replace,
    'Search & Replace'
  )
end)

Config.now_if_args(function()
  vim.pack.add({ 'https://github.com/folke/snacks.nvim' })

  local function term_nav(dir)
    return function(self)
      return self:is_floating() and '<c-' .. dir .. '>'
        or vim.schedule(function()
          vim.cmd.wincmd(dir)
        end)
    end
  end

  local function term_close()
    vim.schedule(function()
      vim.cmd.wincmd('c')
    end)
  end

  local function term_normal(self)
    self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
    if self.esc_timer:is_active() then
      self.esc_timer:stop()
      vim.cmd('stopinsert')
    else
      self.esc_timer:start(200, 0, function() end)
      return '<esc>'
    end
  end

  local function visit_file_under_cursor(self)
    local f = vim.fn.findfile(vim.fn.expand('<cfile>'), '**')
    if f == '' then
      Snacks.notify.warn('No file under cursor')
    else
      self:hide()
      vim.schedule(function()
        vim.cmd('e ' .. f)
      end)
    end
  end

  require('snacks').setup({
    terminal = {
      win = {
        border = vim.o.winborder,
        height = math.floor(vim.o.lines * 0.65),
        bo = { filetype = 'snacks_terminal' },
        -- stylua: ignore
        keys = {
          q = 'hide',
          nav_h       = { '<C-h>', term_nav('h'), desc = 'Go to Left Window',            expr = true, mode = 't' },
          nav_j       = { '<C-j>', term_nav('j'), desc = 'Go to Lower Window',           expr = true, mode = 't' },
          nav_k       = { '<C-k>', term_nav('k'), desc = 'Go to Upper Window',           expr = true, mode = 't' },
          nav_l       = { '<C-l>', term_nav('l'), desc = 'Go to Right Window',           expr = true, mode = 't' },
          term_close  = { '<C-g>', term_close,    desc = 'Close Terminal',               expr = true, mode = 't' },
          term_normal = { '<esc>', term_normal,   desc = 'Double escape to normal mode', expr = true, mode = 't' },
          gf = visit_file_under_cursor,
        },
      },
    },
  })

  Config.set_keymap(
    'n',
    '<Leader>gg',
    '<Cmd>lua Snacks.lazygit()<CR>',
    'LazyGit'
  )
  Config.set_keymap(
    'n',
    '<Leader>tt',
    '<Cmd>lua Snacks.terminal()<CR>',
    'Open Term'
  )
  Config.set_keymap(
    'n',
    '<Leader>ac',
    '<Cmd>lua Snacks.terminal("cursor-agent")<CR>',
    'Open Cursor'
  )
  Config.set_keymap(
    'n',
    '<Leader>ao',
    '<Cmd>lua Snacks.terminal("opencode")<CR>',
    'Open OpenCode'
  )
end)
