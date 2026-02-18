Config.later(function()
  local extra = require('mini.extra')
  extra.setup()
end)

Config.later(function()
  local visits = require('mini.visits')
  visits.setup()
end)

Config.later(function()
  local align = require('mini.align')
  align.setup()
end)

Config.later(function()
  local move = require('mini.move')
  move.setup()
end)

Config.later(function()
  local splitjoin = require('mini.splitjoin')
  splitjoin.setup()
end)

Config.later(function()
  local indentscope = require('mini.indentscope')
  indentscope.setup()
end)

Config.later(function()
  local comment = require('mini.comment')
  comment.setup()
end)

Config.later(function()
  local km = require('mini.keymap')
  km.setup()

  local modes = { 'n', 'i', 'c', 'x', 's' }
  local noh = function() vim.cmd('nohlsearch') end

  km.map_combo(modes, 'jk', '<BS><BS><Esc>')
  km.map_combo(modes, 'kj', '<BS><BS><Esc>')
  km.map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
  km.map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')
  km.map_combo(modes, '<Esc><Esc>', noh)
end)

Config.later(function()
  local ai = require('mini.ai')
  local extra = require('mini.extra')
  ai.setup({
    custom_textobjects = {
      g = extra.gen_ai_spec.buffer(),
      f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
      c = ai.gen_spec.treesitter({ a = '@comment.outer', i = '@comment.inner' }),
      o = ai.gen_spec.treesitter({ a = '@conditional.outer', i = '@conditional.inner' }),
      l = ai.gen_spec.treesitter({ a = '@loop.outer', i = '@loop.inner' }),
    },
    search_method = 'cover',
  })
end)

Config.later(function()
  local files = require('mini.files')
  files.setup({
    mappings = { go_in = '', go_in_plus = '<CR>', go_out = '', go_out_plus = '-' },
    windows = { max_number = 3, preview = true, width_focus = 50, width_nofocus = 20, width_preview = 80 },
    content = { prefix = function() end },
  })

  local set = vim.keymap.set
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

      set('n', 'g.', f, { buffer = buf, desc = '[Un]show Dotfiles' })
    end,
  })

  local cmd = '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<CR>'
  set('n', '<Leader>ef', cmd, { desc = 'Explorer' })
end)

Config.later(function()
  local pick = require('mini.pick')

  pick.setup({
    window = { prompt_prefix = '  ' },
    source = { show = pick.default_show },
  })

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(items, opts, on_choice)
    return MiniPick.ui_select(items, opts, on_choice, {
      window = { config = { relative = 'cursor', anchor = 'NW', row = 0, col = 0, width = 80, height = 15 } },
    })
  end

  local set = vim.keymap.set
  local s = function(lhs, rhs, desc) set('n', '<Leader>' .. lhs, rhs, { desc = desc }) end

  local minipick_find_files = '<Cmd>lua MiniPick.builtin.files()<CR>'
  s('ff', minipick_find_files, 'Files')

  local minipick_grep_live = '<Cmd>lua Minipick.builtin.grep_live()<CR>'
  s('fg', minipick_grep_live, 'Grep live')

  local minipick_resume_last = '<Cmd>lua MiniPick.builtin.resume()<CR>'
  s('fr', minipick_resume_last, 'Resume')

  local wipe = function() vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {}) end
  local minipick_buffers = function()
    MiniPick.builtin.buffers({ include_current = false }, { mappings = { wipeout = { char = '<C-x>', func = wipe } } })
  end
  s('fb', minipick_buffers, 'Buffers')

  local minipick_blines = "<Cmd>lua MiniExtra.pickers.buf_lines({ scope = 'current', preserve_order = true })<CR>"
  s('fl', minipick_blines, 'Lines')

  local minipick_qf = "<Cmd>lua MiniExtra.pickers.list({ scope = 'quickfix' })<CR>"
  s('fq', minipick_qf, 'Quickfix')

  local minipick_maps = '<Cmd>lua MiniExtra.pickers.keymaps()<CR>'
  s('fk', minipick_maps, 'Keymaps')

  local minipick_hls = '<Cmd>lua MiniExtra.pickers.hl_groups()<CR>'
  s('fH', minipick_hls, 'Highlights')

  local minipick_diagnostics = '<Cmd>lua MiniExtra.pickers.diagnostic()<CR>'
  s('fd', minipick_diagnostics, 'Diagnostics')

  local minipick_commands = '<Cmd>lua MiniExtra.pickers.commands()<CR>'
  s('fc', minipick_commands, 'Commands')

  local minipick_helpfiles = "<Cmd>lua MiniPick.builtin.help({ default_split = 'vertical' })<CR>"
  s('fh', minipick_helpfiles, 'Help files')

  local minipick_manpages = '<Cmd>lua MiniExtra.pickers.manpages()<CR>'
  s('fm', minipick_manpages, 'Search manpages')

  local minipick_oldfiles = '<Cmd>lua MiniExtra.pickers.visit_paths({ preserve_order = true })<CR>'
  s('fo', minipick_oldfiles, 'Oldfiles')
end)

Config.later(function()
  local clue = require('mini.clue')

  clue.setup({
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
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.square_brackets(),
      clue.gen_clues.windows(),
      clue.gen_clues.z(),
    },
    window = {
      delay = 500,
      scroll_down = '<C-f>',
      scroll_up = '<C-b>',
      config = function()
        return {
          width = 'auto',
        }
      end,
    },
  })
end)
