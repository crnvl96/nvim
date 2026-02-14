MiniDeps.now(function()
  local predicate = function(notif)
    if not (notif.data.source == 'lsp_progress' and notif.data.client_name == 'lua_ls') then return true end
    return notif.msg:find('Diagnosing') == nil and notif.msg:find('semantic tokens') == nil
  end
  local custom_sort = function(notif_arr) return MiniNotify.default_sort(vim.tbl_filter(predicate, notif_arr)) end
  require('mini.notify').setup({ content = { sort = custom_sort } })
end)

MiniDeps.now(function() require('mini.hues').setup({ background = '#002734', foreground = '#c0c8cc' }) end)

MiniDeps.now(function()
  require('mini.icons').setup()
  MiniDeps.later(MiniIcons.mock_nvim_web_devicons)
  MiniDeps.later(MiniIcons.tweak_lsp_kind)
end)

MiniDeps.now(function()
  require('mini.misc').setup()
  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
  MiniMisc.setup_termbg_sync()
end)

MiniDeps.later(function() require('mini.extra').setup() end)
MiniDeps.later(function() require('mini.visits').setup() end)
MiniDeps.later(function() require('mini.align').setup() end)
MiniDeps.later(function() require('mini.move').setup() end)
MiniDeps.later(function() require('mini.splitjoin').setup() end)
MiniDeps.later(function() require('mini.trailspace').setup() end)
MiniDeps.later(function() require('mini.indentscope').setup() end)
MiniDeps.later(function() require('mini.comment').setup() end)
MiniDeps.later(function() require('mini.operators').setup() end)
MiniDeps.later(function() require('mini.cmdline').setup() end)

MiniDeps.later(function()
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

MiniDeps.later(function()
  local jump2d = require('mini.jump2d')
  jump2d.setup({
    spotter = jump2d.gen_spotter.pattern('[^%s%p]+'),
    labels = 'asdfghjkl;',
    view = {
      dim = true,
      n_steps_ahead = 2,
    },
  })
  vim.keymap.set({ 'n', 'x', 'o' }, 's', function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end)
end)

MiniDeps.later(function()
  require('mini.keymap').setup()
  require('mini.keymap').map_combo({ 'i', 'c', 'x', 's' }, 'jk', '<BS><BS><Esc>')
  require('mini.keymap').map_combo({ 'i', 'c', 'x', 's' }, 'kj', '<BS><BS><Esc>')
  require('mini.keymap').map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
  require('mini.keymap').map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')
  require('mini.keymap').map_combo({ 'n', 'i', 'x', 'c' }, '<Esc><Esc>', function() vim.cmd('nohlsearch') end)
end)

MiniDeps.later(function()
  local ai = require('mini.ai')
  ai.setup({
    custom_textobjects = {
      g = MiniExtra.gen_ai_spec.buffer(),
      f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
      c = ai.gen_spec.treesitter({ a = '@comment.outer', i = '@comment.inner' }),
      o = ai.gen_spec.treesitter({ a = '@conditional.outer', i = '@conditional.inner' }),
      l = ai.gen_spec.treesitter({ a = '@loop.outer', i = '@loop.inner' }),
    },
    search_method = 'cover',
  })
end)

MiniDeps.later(function()
  require('mini.files').setup({
    mappings = {
      go_in = '',
      go_in_plus = '<CR>',
      go_out = '',
      go_out_plus = '-',
    },
    windows = {
      max_number = 3,
      preview = true,
      width_focus = 50,
      width_nofocus = 20,
      width_preview = 80,
    },
  })
  vim.keymap.set(
    'n',
    '<Leader>ef',
    function() MiniFiles.open(vim.api.nvim_buf_get_name(0), false) end,
    { desc = 'Toggle file explorer' }
  )

  local show_dotfiles = true

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(e)
      local buf_id = e.data.buf_id

      local filter_show = function() return true end
      local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, '.') end

      vim.keymap.set('n', 'g.', function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        MiniFiles.refresh({ content = { filter = new_filter } })
      end, { buffer = buf_id, desc = 'Toggle dotfiles' })
    end,
  })
end)

MiniDeps.later(function()
  require('mini.pick').setup({
    window = {
      prompt_prefix = '  ',
    },
  })

  local cursor_based_display_opts = {
    window = {
      config = {
        relative = 'cursor',
        anchor = 'NW',
        row = 0,
        col = 0,
        width = 80,
        height = 20,
      },
    },
  }

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(items, opts, on_choice)
    return MiniPick.ui_select(items, opts, on_choice, cursor_based_display_opts)
  end

  vim.keymap.set('n', '<Leader>ff', function() MiniPick.builtin.files() end, { desc = 'Find files' })
  vim.keymap.set('n', '<Leader>fg', function() MiniPick.builtin.grep_live() end, { desc = 'Grep live' })
  vim.keymap.set('n', '<Leader>fr', function() MiniPick.builtin.resume() end, { desc = 'Resume last picker' })
  vim.keymap.set(
    'n',
    '<Leader>fl',
    function()
      MiniExtra.pickers.buf_lines({
        scope = 'current',
        preserve_order = true,
      })
    end,
    { desc = 'Search on buffer lines' }
  )
  vim.keymap.set(
    'n',
    '<Leader>fq',
    function() MiniExtra.pickers.list({ scope = 'quickfix' }) end,
    { desc = 'Search on quickfix list' }
  )
  vim.keymap.set('n', '<Leader>fk', function() MiniExtra.pickers.keymaps() end, { desc = 'Search keymaps' })
  vim.keymap.set('n', '<Leader>fH', function() MiniExtra.pickers.hl_groups() end, { desc = 'Search highlight groups' })
  vim.keymap.set('n', '<Leader>fd', function() MiniExtra.pickers.diagnostic() end, { desc = 'Search diagnostics' })
  vim.keymap.set('n', '<Leader>fc', function() MiniExtra.pickers.commands() end, { desc = 'Search commands' })
  vim.keymap.set(
    'n',
    '<Leader>fh',
    function()
      MiniPick.builtin.help({
        default_split = 'vertical',
      })
    end,
    { desc = 'Search help files' }
  )
  vim.keymap.set(
    'n',
    '<Leader>fb',
    function() MiniPick.builtin.buffers({ include_current = false }, cursor_based_display_opts) end,
    { desc = 'Search buffers' }
  )
  vim.keymap.set('n', '<Leader>fm', function() MiniExtra.pickers.manpages() end, { desc = 'Search manpages' })
  vim.keymap.set(
    'n',
    '<Leader>fo',
    function() MiniExtra.pickers.visit_paths({ preserve_order = true }, cursor_based_display_opts) end,
    { desc = 'Search on oldfiles' }
  )

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('crnvl96-on-lspattach-mini-maps', { clear = true }),
    callback = function(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)
      if not client then return end

      local m = vim.lsp.protocol.Methods
      local function sup(method) return client:supports_method(method, e.buf) end

      if sup(m.textDocument_declaration) then
        vim.keymap.set(
          'n',
          'gD',
          function() MiniExtra.pickers.lsp({ scope = 'declaration' }) end,
          { desc = 'Lsp declaration', buffer = e.buf }
        )
      end

      if sup(m.textDocument_definition) then
        vim.keymap.set(
          'n',
          'gd',
          function() MiniExtra.pickers.lsp({ scope = 'definition' }) end,
          { desc = 'Lsp definition', buffer = e.buf }
        )
      end

      if sup(m.textDocument_documentSymbol) then
        vim.keymap.set(
          'n',
          'gO',
          function() MiniExtra.pickers.lsp({ scope = 'document_symbol' }) end,
          { desc = 'Lsp document symbols', buffer = e.buf }
        )
        vim.keymap.set(
          'n',
          'gS',
          function() MiniExtra.pickers.lsp({ scope = 'workspace_symbol_live' }) end,
          { desc = 'Lsp workspace symbols', buffer = e.buf }
        )
      end

      if sup(m.textDocument_implementation) then
        vim.keymap.set(
          'n',
          'gri',
          function() MiniExtra.pickers.lsp({ scope = 'implementation' }) end,
          { desc = 'Lsp implementation', buffer = e.buf }
        )
      end

      if sup(m.textDocument_references) then
        vim.keymap.set(
          'n',
          'grr',
          function() MiniExtra.pickers.lsp({ scope = 'references' }) end,
          { desc = 'Lsp references', buffer = e.buf }
        )
      end

      if sup(m.textDocument_typeDefinition) then
        vim.keymap.set(
          'n',
          'grt',
          function() MiniExtra.pickers.lsp({ scope = 'type_definition' }) end,
          { desc = 'Lsp type definition', buffer = e.buf }
        )
      end

      if sup(m.textDocument_codeAction) then
        vim.keymap.set(
          'n',
          'gra',
          function() vim.lsp.buf.code_action() end,
          { desc = 'Lsp code actions', buffer = e.buf }
        )
      end

      if sup(m.textDocument_rename) then
        vim.keymap.set('n', 'grn', function() vim.lsp.buf.rename() end, { desc = 'Lsp rename symbol', buffer = e.buf })
      end
    end,
  })
end)

MiniDeps.later(function()
  local miniclue = require('mini.clue')

  for _, lhs in ipairs({ '[%', ']%', 'g%' }) do
    vim.keymap.del('n', lhs)
  end

  require('mini.clue').setup({
    triggers = {
      { mode = { 'n', 'x' }, keys = '<Leader>' },
      { mode = 'n', keys = '\\' },
      { mode = { 'n', 'x' }, keys = '[' },
      { mode = { 'n', 'x' }, keys = ']' },
      { mode = 'i', keys = '<C-x>' },
      { mode = { 'n', 'x' }, keys = 'g' },
      { mode = { 'n', 'x' }, keys = "'" },
      { mode = { 'n', 'x' }, keys = '`' },
      { mode = { 'n', 'x' }, keys = '"' },
      { mode = { 'i', 'c' }, keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },
      -- { mode = { 'n', 'x' }, keys = 's' },
      { mode = { 'n', 'x' }, keys = 'z' },
    },
    clues = {
      { mode = { 'n', 'x' }, keys = '<leader>f', desc = '+find' },
      { mode = { 'n' }, keys = '<leader>e', desc = '+explorer' },
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
    window = {
      delay = 500,
      scroll_down = '<C-f>',
      scroll_up = '<C-b>',
      config = function(bufnr)
        local max_width = 0
        for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
          max_width = math.max(max_width, vim.fn.strchars(line))
        end

        max_width = max_width + 2

        return {
          width = math.min(70, max_width),
        }
      end,
    },
  })
end)
