local now, later = MiniDeps.now, MiniDeps.later

now(function()
  -- -- stylua: ignore
  -- local hues = {
  --   catppuccin   = { background = '#24273a', foreground = '#cad3f5' },
  --   everforest   = { background = '#2d353b', foreground = '#d3c6aa' },
  --   gruvbox      = { background = '#282828', foreground = '#ebdbb2' },
  --   kanagawa     = { background = '#1f1f28', foreground = '#dcd7ba' },
  --   nord         = { background = '#2e3440', foreground = '#d8dee9' },
  --   osaka_jade   = { background = '#111c18', foreground = '#C1C497' },
  --   tokyonight   = { background = '#1a1b26', foreground = '#a9b1d6' },
  -- }

  vim.cmd 'colo miniwinter'

  -- require('mini.colors').setup()
  -- require('mini.hues').setup(hues.everforest)
  --
  -- MiniColors.get_colorscheme()
  --   :add_transparency({
  --     general = true,
  --     float = true,
  --     statuscolumn = true,
  --     statusline = true,
  --     tabline = true,
  --     winbar = true,
  --   })
  --   :apply()
end)

now(function()
  local ext3_blocklist = { scm = true, txt = true, yml = true }
  local ext4_blocklist = { json = true, yaml = true }
  require('mini.icons').setup {
    use_file_extension = function(ext, _) return not (ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)]) end,
  }

  later(MiniIcons.mock_nvim_web_devicons)
  later(MiniIcons.tweak_lsp_kind)
end)

now(function()
  require('mini.misc').setup()

  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
  MiniMisc.setup_termbg_sync()
end)

later(function() require('mini.extra').setup() end)

later(function()
  local ai = require 'mini.ai'
  ai.setup {
    custom_textobjects = {
      g = MiniExtra.gen_ai_spec.buffer(),
      f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
    },
    search_method = 'cover',
  }
end)

later(function() require('mini.align').setup() end)
later(function() require('mini.bracketed').setup() end)
later(function() require('mini.bufremove').setup() end)
later(function()
  local miniclue = require 'mini.clue'
  miniclue.setup {
    clues = {
      { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
      { mode = 'n', keys = '<Leader>e', desc = '+Explore/Edit' },
      { mode = 'n', keys = '<Leader>f', desc = '+Find' },
      { mode = 'n', keys = '<Leader>g', desc = '+Git' },
      { mode = 'n', keys = '<Leader>l', desc = '+Language' },
      { mode = 'n', keys = '<Leader>o', desc = '+Other' },
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

later(function() require('mini.comment').setup() end)

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

later(function() require('mini.diff').setup() end)

later(
  function()
    require('mini.files').setup {
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
        width_preview = 50,
      },
    }
  end
)

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

later(function() require('mini.indentscope').setup() end)
later(function() require('mini.jump').setup() end)

later(
  function()
    require('mini.jump2d').setup {
      spotter = require('mini.jump2d').gen_spotter.pattern '[^%s%p]+',
      labels = "asdfghjkl'",
      view = { dim = true, n_steps_ahead = 2 },
    }
  end
)

later(function()
  require('mini.keymap').setup()
  MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
  MiniKeymap.map_multistep('i', '<C-n>', { 'pmenu_next' })
  MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
  MiniKeymap.map_multistep('i', '<C-p>', { 'pmenu_prev' })
  MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
  MiniKeymap.map_multistep('i', '<BS>', { 'minipairs_bs' })

  local mode = { 'i', 'c', 'x', 's' }
  require('mini.keymap').map_combo(mode, 'jk', '<BS><BS><Esc>')
  require('mini.keymap').map_combo(mode, 'kj', '<BS><BS><Esc>')
  require('mini.keymap').map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
  require('mini.keymap').map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')
end)

later(function() require('mini.move').setup() end)

later(function()
  local lang_patterns = {
    markdown_inline = { 'markdown.json' },
  }

  local snippets = require 'mini.snippets'
  local config_path = vim.fn.stdpath 'config'

  snippets.setup {
    snippets = {
      snippets.gen_loader.from_file(config_path .. '/snippets/global.json'),
      snippets.gen_loader.from_lang { lang_patterns = lang_patterns },
    },
  }
end)

later(function()
  require('mini.operators').setup()
  vim.keymap.set('n', '(', 'gxiagxila', { remap = true, desc = 'Swap arg left' })
  vim.keymap.set('n', ')', 'gxiagxina', { remap = true, desc = 'Swap arg right' })
end)

later(function() require('mini.pairs').setup { modes = { command = true } } end)
later(function() require('mini.pick').setup() end)
later(function() require('mini.splitjoin').setup() end)
later(function() require('mini.surround').setup() end)
later(function() require('mini.trailspace').setup() end)
later(function() require('mini.visits').setup() end)
