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

  local cursor_based_display_opts = {
    window = {
      config = { relative = 'cursor', anchor = 'NW', row = 0, col = 0, width = 40, height = 15 },
    },
  }

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(items, opts, on_choice)
    return MiniPick.ui_select(items, opts, on_choice, cursor_based_display_opts)
  end

  local f_blines = function() MiniExtra.pickers.buf_lines({ scope = 'current', preserve_order = true }) end
  local f_qf = function() MiniExtra.pickers.list({ scope = 'quickfix' }) end
  local f_help = function() MiniPick.builtin.help({ default_split = 'vertical' }) end
  local f_oldfiles = function() MiniExtra.pickers.visit_paths({ preserve_order = true }, cursor_based_display_opts) end
  local f_km = function() MiniExtra.pickers.keymaps() end
  local f_hl = function() MiniExtra.pickers.hl_groups() end
  local f_diag = function() MiniExtra.pickers.diagnostic() end
  local f_cmd = function() MiniExtra.pickers.commands() end
  local f_man = function() MiniExtra.pickers.manpages() end

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

  set('n', '<Leader>fl', f_blines, { desc = 'Search on buffer lines' })
  set('n', '<Leader>fq', f_qf, { desc = 'Search on quickfix list' })
  set('n', '<Leader>fk', f_km, { desc = 'Search keymaps' })
  set('n', '<Leader>fH', f_hl, { desc = 'Search highlight groups' })
  set('n', '<Leader>fd', f_diag, { desc = 'Search diagnostics' })
  set('n', '<Leader>fc', f_cmd, { desc = 'Search commands' })
  set('n', '<Leader>fh', f_help, { desc = 'Search help files' })
  set('n', '<Leader>fm', f_man, { desc = 'Search manpages' })
  set('n', '<Leader>fo', f_oldfiles, { desc = 'Search on oldfiles' })
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
