Config.now(function()
  require('mini.icons').setup()
  Config.later(MiniIcons.tweak_lsp_kind)
  Config.later(MiniIcons.mock_nvim_web_devicons)
end)

Config.later(function() require('mini.extra').setup() end)
Config.later(function() require('mini.visits').setup() end)
Config.later(function() require('mini.align').setup() end)
Config.later(function() require('mini.move').setup() end)
Config.later(function() require('mini.splitjoin').setup() end)
Config.later(function() require('mini.comment').setup() end)
Config.later(function() require('mini.cmdline').setup() end)
Config.later(function() require('mini.bracketed').setup() end)
Config.later(function() require('mini.statusline').setup() end)
Config.later(function() require('mini.tabline').setup() end)
Config.later(function() require('mini.git').setup() end)
Config.later(function() require('mini.diff').setup({ view = { style = 'sign' } }) end)
Config.later(function() require('mini.indentscope').setup({ options = { border = 'top', try_as_border = true } }) end)

Config.now(function()
  -- We've setup this plugin at init.lua
  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
  MiniMisc.setup_termbg_sync()
end)

Config.now(function()
  vim.cmd.colorscheme('miniwinter')
  require('mini.colors').get_colorscheme():add_transparency({ general = false, float = true }):apply()
end)

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
      highlighters = { hex_color = require('mini.hipatterns').gen_highlighter.hex_color() },
    })
  end
)

Config.later(
  function()
    require('mini.jump2d').setup({
      spotter = require('mini.jump2d').gen_spotter.pattern('[^%s%p]+'),
      labels = 'asdfghjklweruioxcvn,.',
      view = { dim = true, n_steps_ahead = 2 },
    })
  end
)

Config.later(
  function()
    require('mini.ai').setup({
      search_method = 'cover',
      custom_textobjects = {
        g = MiniExtra.gen_ai_spec.buffer(),
        f = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
        c = require('mini.ai').gen_spec.treesitter({ a = '@comment.outer', i = '@comment.inner' }),
        o = require('mini.ai').gen_spec.treesitter({ a = '@conditional.outer', i = '@conditional.inner' }),
        l = require('mini.ai').gen_spec.treesitter({ a = '@loop.outer', i = '@loop.inner' }),
      },
    })
  end
)

Config.later(function()
  require('mini.keymap').setup()
  MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
  MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
  MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept' })
end)

Config.later(function()
  require('mini.files').setup({
    mappings = {
      go_in = '',
      go_in_plus = '<CR>',
      go_out = '',
      go_out_plus = '-',
      mark_goto = "'",
    },
    windows = {
      max_number = 3,
      preview = true,
      width_focus = 50,
      width_nofocus = 20,
      width_preview = 80,
    },
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesExplorerOpen',
    group = Config.gr,
    callback = function()
      MiniFiles.set_bookmark('c', vim.fn.stdpath('config'), { desc = 'Config' })
      MiniFiles.set_bookmark('@', vim.fn.stdpath('data') .. '/site/pack/core/opt', { desc = 'Plugins' })
      MiniFiles.set_bookmark('_', vim.fn.getcwd, { desc = 'Working directory' })
      MiniFiles.set_bookmark('n', vim.env.HOME .. '/Developer/personal/notes', { desc = 'Notes' })
      MiniFiles.set_bookmark('p', vim.env.HOME .. '/Developer/personal/presentations', { desc = 'Presentations' })
      MiniFiles.set_bookmark('e', vim.env.HOME .. '/Developer/personal', { desc = 'Personal projects' })
      MiniFiles.set_bookmark('w', vim.env.HOME .. '/Developer/work', { desc = 'Work projects' })
    end,
  })
end)

Config.later(function()
  require('mini.pick').setup({ window = { prompt_prefix = ' ' } })

  MiniPick.registry.projects = function()
    local cwd = vim.fn.expand('~/Developer')

    local choose = function(item)
      local local_opts = nil
      local opts = { source = { cwd = item.path } }
      vim.schedule(function() MiniPick.builtin.files(local_opts, opts) end)
    end

    local choose_scope = function(item)
      local local_opts = { cwd = item.path }
      local opts = { source = { cwd = item.path, choose = choose } }
      vim.schedule(function() MiniExtra.pickers.explorer(local_opts, opts) end)
    end

    local local_opts = { cwd = cwd }
    local opts = { source = { choose = choose_scope } }
    return MiniExtra.pickers.explorer(local_opts, opts)
  end

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(items, opts, on_choice)
    return MiniPick.ui_select(
      items,
      opts,
      on_choice,
      { window = { config = { relative = 'cursor', anchor = 'NW', row = 0, col = 0, width = 80, height = 15 } } }
    )
  end
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
        Config.clues,
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
        config = {
          width = 'auto',
        },
      },
    })
  end
)
