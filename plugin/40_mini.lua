local now, later = MiniDeps.now, MiniDeps.later

later(function() require('mini.extra').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.cmdline').setup() end)
later(function() require('mini.jump').setup() end)
later(function() require('mini.trailspace').setup() end)
later(function() require('mini.move').setup() end)
later(function() require('mini.pick').setup() end)
later(function() require('mini.splitjoin').setup() end)
later(function() require('mini.align').setup() end)

later(function()
  local jump2d = require 'mini.jump2d'
  jump2d.setup {
    spotter = jump2d.gen_spotter.pattern '[^%s%p]+',
    labels = 'fjdkslah',
    view = { dim = true, n_steps_ahead = 2 },
    mappings = { start_jumping = 's' },
  }
  vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end)
end)

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
  local hipatterns = require 'mini.hipatterns'
  local hi_words = MiniExtra.gen_highlighter.words
  hipatterns.setup {
    highlighters = {
      fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
      hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
      todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
      note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
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
  require('mini.completion').setup {
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = function(items, base)
        return MiniCompletion.default_process_items(items, base, { kind_priority = { Text = -1, Snippet = -1 } })
      end,
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
  require('mini.keymap').setup()

  MiniKeymap.map_combo({ 'i', 'c', 'x', 's' }, 'jk', '<BS><BS><Esc>')
  MiniKeymap.map_combo({ 'i', 'c', 'x', 's' }, 'kj', '<BS><BS><Esc>')

  MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
  MiniKeymap.map_multistep('i', '<C-n>', { 'pmenu_next' })
  MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
  MiniKeymap.map_multistep('i', '<C-p>', { 'pmenu_prev' })
  MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept' })
end)
