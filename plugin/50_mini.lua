Config.now(function()
  require('mini.colors').setup()
  MiniColors.get_colorscheme('elflord'):add_transparency({ general = false, float = true }):apply()
  MiniColors.animate({})
end)

Config.later(function() require('mini.extra').setup() end)
Config.later(function() require('mini.visits').setup() end)
Config.later(function() require('mini.align').setup() end)
Config.later(function() require('mini.move').setup() end)
Config.later(function() require('mini.splitjoin').setup() end)
Config.later(function() require('mini.indentscope').setup() end)
Config.later(function() require('mini.comment').setup() end)

Config.later(function()
  require('mini.completion').setup({
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = function(items, base)
        return MiniCompletion.default_process_items(items, base, { kind_priority = { Text = -1, Snippet = -1 } })
      end,
    },
  })
  vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })
  vim.api.nvim_create_autocmd('LspAttach', {
    group = Config.gr,
    callback = function(e) vim.bo[e.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end,
  })
end)

Config.later(
  function()
    require('mini.hipatterns').setup({
      highlighters = {
        fixme = MiniExtra.gen_highlighter.words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
        hack = MiniExtra.gen_highlighter.words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
        todo = MiniExtra.gen_highlighter.words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
        note = MiniExtra.gen_highlighter.words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
        hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
      },
    })
  end
)

Config.later(
  function()
    require('mini.ai').setup({
      custom_textobjects = {
        g = MiniExtra.gen_ai_spec.buffer(),
        f = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
        c = require('mini.ai').gen_spec.treesitter({ a = '@comment.outer', i = '@comment.inner' }),
        o = require('mini.ai').gen_spec.treesitter({ a = '@conditional.outer', i = '@conditional.inner' }),
        l = require('mini.ai').gen_spec.treesitter({ a = '@loop.outer', i = '@loop.inner' }),
      },
      search_method = 'cover',
    })
  end
)

Config.later(function()
  require('mini.files').setup({
    mappings = { go_in = '', go_in_plus = '<CR>', go_out = '', go_out_plus = '-' },
    windows = { max_number = 3, preview = true, width_focus = 50, width_nofocus = 20, width_preview = 80 },
    content = { prefix = function() end },
  })

  local show_dotfiles = true

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    group = Config.gr,
    callback = function(e)
      local buf = e.data.buf_id

      local filter_show = function() return true end
      local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, '.') end

      local f = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        MiniFiles.refresh({ content = { filter = new_filter } })
      end

      vim.keymap.set('n', 'g.', f, { buffer = buf, desc = '[Un]show Dotfiles' })
    end,
  })

  -- stylua: ignore start
  vim.keymap.set('n', '<Leader>ef', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<CR>', { desc = 'Explorer' })
  -- stylua: ignore end
end)

Config.later(function()
  require('mini.pick').setup({
    window = { prompt_prefix = '  ' },
    source = { show = require('mini.pick').default_show },
  })

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(items, opts, on_choice)
    return MiniPick.ui_select(items, opts, on_choice, {
      window = {
        config = {
          relative = 'cursor',
          anchor = 'NW',
          row = 0,
          col = 0,
          width = 80,
          height = 15,
        },
      },
    })
  end

  local s = function(lhs, rhs, desc) vim.keymap.set('n', '<Leader>' .. lhs, rhs, { desc = desc }) end

  -- stylua: ignore start
  vim.keymap.set('n', 'E',     '<Cmd>lua vim.diagnostic.open_float()<CR>')
  vim.keymap.set('n', 'K',     '<Cmd>lua vim.lsp.buf.hover()<CR>')
  vim.keymap.set('i', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')

  s('ff', '<Cmd>lua MiniPick.builtin.files()<CR>',                                 'Files')
  s('fg', '<Cmd>lua Minipick.builtin.grep_live()<CR>',                             'Grep live')
  s('fr', '<Cmd>lua MiniPick.builtin.resume()<CR>',                                'Resume')
  s('fb', '<CR>lua MiniPick.builtin.buffers({ include_current = false })<CR>',     'Buffers')
  s('fl', "<Cmd>lua MiniExtra.pickers.buf_lines({ scope = 'current',               preserve_order = true })<CR>", 'Lines')
  s('fq', "<Cmd>lua MiniExtra.pickers.list({ scope = 'quickfix' })<CR>",           'Quickfix')
  s('fk', '<Cmd>lua MiniExtra.pickers.keymaps()<CR>',                              'Keymaps')
  s('fH', '<Cmd>lua MiniExtra.pickers.hl_groups()<CR>',                            'Highlights')
  s('fd', '<Cmd>lua MiniExtra.pickers.diagnostic()<CR>',                           'Diagnostics')
  s('fc', '<Cmd>lua MiniExtra.pickers.commands()<CR>',                             'Commands')
  s('fh', "<Cmd>lua MiniPick.builtin.help({ default_split = 'vertical' })<CR>",    'Help files')
  s('fm', '<Cmd>lua MiniExtra.pickers.manpages()<CR>',                             'Search manpages')
  s('fo', '<Cmd>lua MiniExtra.pickers.visit_paths({ preserve_order = true })<CR>', 'Oldfiles')
  s('lD', "<Cmd>lua MiniExtra.pickers.lsp({scope ='declaration'})<CR>",            'Declarations')
  s('ld', "<Cmd>lua MiniExtra.pickers.lsp({scope='definition'})<CR>",              'Definitions')
  s('ls', "<Cmd>lua MiniExtra.pickers.lsp({scope='document_symbol'})<CR>",         'Document Symbols')
  s('lS', "<Cmd>lua MiniExtra.pickers.lsp({scope='workspace_symbol_live'})<CR>",   'Workspace symbols')
  s('li', "<Cmd>lua MiniExtra.pickers.lsp({scope='implementation'})<CR>",          'Implementations')
  s('lr', "<Cmd>lua MiniExtra.pickers.lsp({scope='references'})<CR>",              'References')
  s('lt', "<Cmd>lua MiniExtra.pickers.lsp({scope='type_definition'})<CR>",         'Typedefs')
  s('la', '<Cmd>lua vim.lsp.buf.code_action()<CR>',                                'Code actions')
  s('ln', '<Cmd>lua vim.lsp.buf.rename()<CR>',                                     'Rename')
  -- stylua: ignore end
end)

Config.later(
  function()
    require('mini.clue').setup({
      triggers = {
        { mode = 'n', keys = '\\' },
        { mode = 'i', keys = '<C-x>' },
        { mode = 'n', keys = '<C-w>' },
        { mode = { 'n', 'x' }, keys = '<Leader>' },
        { mode = { 'n', 'x' }, keys = '[' },
        { mode = { 'n', 'x' }, keys = ']' },
        { mode = { 'n', 'x' }, keys = 'g' },
        { mode = { 'n', 'x' }, keys = "'" },
        { mode = { 'n', 'x' }, keys = '`' },
        { mode = { 'n', 'x' }, keys = '"' },
        { mode = { 'i', 'c' }, keys = '<C-r>' },
        { mode = { 'n', 'x' }, keys = 'z' },
      },
      clues = {
        { mode = { 'n' }, keys = '<leader>e', desc = '+explorer' },
        { mode = { 'n', 'x' }, keys = '<leader>f', desc = '+find' },
        { mode = { 'n', 'x' }, keys = '<leader>l', desc = '+lsp' },
        require('mini.clue').gen_clues.builtin_completion(),
        require('mini.clue').gen_clues.g(),
        require('mini.clue').gen_clues.marks(),
        require('mini.clue').gen_clues.registers(),
        require('mini.clue').gen_clues.square_brackets(),
        require('mini.clue').gen_clues.windows(),
        require('mini.clue').gen_clues.z(),
      },
      window = {
        delay = 500,
        scroll_down = '<C-f>',
        scroll_up = '<C-b>',
        config = { width = 'auto' },
      },
    })
  end
)
