local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function() require('mini.extra').setup() end)
later(function() require('mini.bufremove').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.cmdline').setup() end)
later(function() require('mini.jump').setup() end)
later(function() require('mini.move').setup() end)
later(function() require('mini.pick').setup() end)
later(function() require('mini.splitjoin').setup() end)

now(function()
  require('mini.misc').setup()
  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
end)

later(function()
  local ai = require 'mini.ai'
  ai.setup {
    custom_textobjects = {
      b = MiniExtra.gen_ai_spec.buffer(),
      f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
    },
    search_method = 'cover',
  }
end)

later(function()
  local miniclue = require 'mini.clue'
  miniclue.setup {
    clues = {
      { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
      { mode = 'n', keys = '<Leader>e', desc = '+Explore/Edit' },
      { mode = 'n', keys = '<Leader>f', desc = '+Find' },
      { mode = 'n', keys = '<Leader>g', desc = '+Git' },
      { mode = 'n', keys = '<Leader>l', desc = '+Language' },
      { mode = 'n', keys = '<Leader>w', desc = '+Window' },
      { mode = 'n', keys = '<Leader>h', desc = '+Misc' },
      { mode = 'x', keys = '<Leader>g', desc = '+Git' },
      { mode = 'x', keys = '<Leader>l', desc = '+Language' },
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows { submode_resize = true },
      miniclue.gen_clues.z(),
    },
    triggers = {
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = '<Localleader>' },
      { mode = 'x', keys = '<Localleader>' },
      { mode = 'n', keys = '\\' },
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' },
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },
    window = {
      config = { width = 'auto' },
      delay = 500,
      scroll_down = '<C-d>',
      scroll_up = '<C-u>',
    },
  }
end)

later(function()
  local process_items_opts = { kind_priority = { Text = -1, Snippet = -1 } }
  local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, process_items_opts)
  end

  require('mini.completion').setup {
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = process_items,
    },
  }

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('crnvl96-on-lspattach', {}),
    callback = function(ev) vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end,
  })

  vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })
end)

later(function()
  local minifiles = require 'mini.files'

  minifiles.setup {
    mappings = {
      go_in = '',
      go_in_plus = '<CR>',
      go_out = '',
      go_out_plus = '-',
    },
    windows = {
      preview = true,
      width_focus = 50,
      width_nofocus = 15,
      width_preview = 80,
    },
  }
end)

later(function()
  local jump2d = require 'mini.jump2d'

  jump2d.setup {
    spotter = require('mini.jump2d').gen_spotter.pattern '[^%s%p]+',
    view = { dim = true, n_steps_ahead = 2 },
    mappings = {
      start_jumping = 's',
    },
  }
end)

later(function()
  require('mini.keymap').setup()

  MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
  MiniKeymap.map_multistep('i', '<C-n>', { 'pmenu_next' })
  MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
  MiniKeymap.map_multistep('i', '<C-p>', { 'pmenu_prev' })
  MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept' })

  local mode = { 'i', 'c', 'x', 's' }

  require('mini.keymap').map_combo(mode, 'jk', '<BS><BS><Esc>')
  require('mini.keymap').map_combo(mode, 'kj', '<BS><BS><Esc>')
  require('mini.keymap').map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
  require('mini.keymap').map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')
end)
