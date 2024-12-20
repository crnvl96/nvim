Add({ name = 'mini.nvim' })

Now(function() vim.cmd('colorscheme minigrey') end)

Later(function() require('mini.extra').setup() end)
Later(function() require('mini.diff').setup() end)
Later(function() require('mini.doc').setup() end)
Later(function() require('mini.git').setup() end)
Later(function() require('mini.operators').setup() end)
Later(function() require('mini.visits').setup() end)

Now(function()
  require('mini.misc').setup_auto_root()
  require('mini.misc').setup_termbg_sync()
end)

Now(function()
  require('mini.notify').setup({
    content = {
      sort = function(notif_arr)
        return MiniNotify.default_sort(
          vim.tbl_filter(function(notif) return not vim.startswith(notif.msg, 'lua_ls: Diagnosing') end, notif_arr)
        )
      end,
    },
  })

  vim.notify = MiniNotify.make_notify()
end)

Now(function()
  require('mini.icons').setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
    end,
  })

  MiniIcons.mock_nvim_web_devicons()

  Later(MiniIcons.tweak_lsp_kind)
end)

Later(function()
  local miniclue = require('mini.clue')
  miniclue.setup({
    clues = {
      Clues(),
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },
    triggers = Triggers(),
    window = { delay = 200, config = { width = 'auto' } },
  })
end)

Later(
  function()
    require('mini.files').setup({
      mappings = {
        go_in = '',
        go_in_plus = '<CR>',
        go_out = '',
        go_out_plus = '-',
      },
      windows = { width_nofocus = 25, preview = true, width_preview = 120 },
      options = { permanent_delete = false },
    })
  end
)

Later(function()
  require('mini.pick').setup({
    options = {
      use_cache = true,
    },
    window = {
      prompt_cursor = '_',
      prompt_prefix = '',
    },
  })

  vim.ui.select = MiniPick.ui_select

  RegisterMultigrepPicker()
end)
