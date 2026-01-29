---@diagnostic disable: undefined-global

local add, now, ltr = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function() require('mini.extra').setup() end)
ltr(function() require('mini.comment').setup() end)
ltr(function() require('mini.move').setup() end)
ltr(function() require('mini.align').setup() end)
ltr(function() require('mini.cmdline').setup() end)
ltr(function() add 'tpope/vim-fugitive' end)

ltr(function()
  add 'folke/snacks.nvim'
  require('snacks').setup()
end)

now(function()
  add 'sainnhe/gruvbox-material'

  vim.g.gruvbox_material_background = 'hard'
  vim.g.gruvbox_material_enable_bold = 1
  vim.g.gruvbox_material_enable_italic = 1
  vim.g.gruvbox_material_better_performance = 1

  vim.cmd.colorscheme 'gruvbox-material'
end)

ltr(function()
  require('mini.colors').setup()

  MiniColors.get_colorscheme()
    :add_transparency({
      general = true,
      float = true,
      statuscolumn = true,
      statusline = true,
      tabline = true,
      winbar = true,
    })
    :apply()
end)

now(function()
  require('mini.misc').setup()

  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
end)

ltr(function()
  local build = function(args)
    put 'Building dependencies of markdown-preview.nvim'

    local put = MiniMisc.put
    local cmd = { 'npm', 'install', '--prefix', string.format('%s/app', args.path) }
    local obj = vim.system(cmd, { text = true }):wait()

    if obj.code ~= 0 then
      put 'An error occurred while building dependencies of markdown-preview.nvim'
    else
      vim.print(vim.inspect(obj))
    end
  end

  add {
    source = 'iamcco/markdown-preview.nvim',
    hooks = {
      post_install = function(args)
        ltr(function() build(args) end)
      end,
      post_checkout = function(args)
        ltr(function() build(args) end)
      end,
    },
  }
end)

ltr(function()
  require('mini.keymap').setup()
  local mode = { 'i', 'c', 'x', 's' }
  require('mini.keymap').map_combo(mode, 'jk', '<BS><BS><Esc>')
  require('mini.keymap').map_combo(mode, 'kj', '<BS><BS><Esc>')
end)

ltr(function()
  require('mini.jump2d').setup {
    spotter = require('mini.jump2d').gen_spotter.pattern '[^%s%p]+',
    labels = 'fjdkslah',
    view = { dim = true, n_steps_ahead = 2 },
    mappings = { start_jumping = '' },
  }

  vim.keymap.set({ 'n', 'x', 'o' }, 's', function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end)
end)

ltr(function()
  local ai = require 'mini.ai'

  ai.setup {
    custom_textobjects = {
      g = MiniExtra.gen_ai_spec.buffer(),
      f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
      c = ai.gen_spec.treesitter { a = '@comment.outer', i = '@comment.inner' },
      o = ai.gen_spec.treesitter { a = '@conditional.outer', i = '@conditional.inner' },
      l = ai.gen_spec.treesitter { a = '@loop.outer', i = '@loop.inner' },
    },
    search_method = 'cover',
  }
end)

-- ltr(function()
--   add 'MagicDuck/grug-far.nvim'
--   require('grug-far').setup()
-- end)

-- ltr(function()
--   require('mini.pick').setup()
--
--   local set = vim.keymap.set
--
--   set('n', '<leader>fH', '<Cmd>Pick hl_groups<CR>', { desc = 'Highlight groups' })
--   set('n', '<leader>fb', '<Cmd>Pick buffers<CR>', { desc = 'Buffers' })
--   set('n', '<leader>ff', '<Cmd>Pick files<CR>', { desc = 'Files' })
--   set('n', '<leader>fg', '<Cmd>Pick grep_live<CR>', { desc = 'Grep live' })
--   set('n', '<leader>fh', '<Cmd>Pick help<CR>', { desc = 'Help tags' })
--   set('n', '<leader>fl', '<Cmd>Pick buf_lines scope="current"<CR>', { desc = 'Lines (buf)' })
--   set('n', '<leader>fk', '<Cmd>Pick keymaps<CR>', { desc = 'Keymaps' })
--   set('n', '<leader>fo', '<Cmd>Pick oldfiles<CR>', { desc = 'Oldfiles' })
--   set('n', '<leader>fr', '<Cmd>Pick resume<CR>', { desc = 'Resume' })
--   set('n', '<leader>gS', '<Cmd>Pick git_hunks scope="staged"<CR>', { desc = 'Status (staged)' })
--   set('n', '<leader>gb', '<Cmd>Pick git_branches<CR>', { desc = 'Branches' })
--   set('n', '<leader>gc', '<Cmd>Pick git_commits<CR>', { desc = 'Commits' })
--   set('n', '<leader>gs', '<Cmd>Pick git_hunks<CR>', { desc = 'Status' })
-- end)

-- ltr(function()
--   local files = require 'mini.files'
--
--   files.setup {
--     mappings = {
--       go_in = '',
--       go_in_plus = '<CR>',
--       go_out = '',
--       go_out_plus = '-',
--     },
--     windows = {
--       preview = true,
--       width_focus = 50,
--       width_nofocus = 15,
--       width_preview = 80,
--     },
--   }
--
--   local set = vim.keymap.set
--
--   local dir_cmd = '<Cmd>lua MiniFiles.open()<CR>'
--   local file_cmd = '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>'
--
--   set('n', '<leader>ed', dir_cmd, { desc = 'Directory' })
--   set('n', '<leader>ef', file_cmd, { desc = 'File' })
-- end)
