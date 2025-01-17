local deps = require('mini.deps')

local add, now, later = deps.add, deps.now, deps.later

now(function() require('mini.icons').setup() end)
later(function() require('mini.doc').setup() end)
later(function() require('mini.align').setup() end)
later(function() require('mini.splitjoin').setup() end)
later(function() require('mini.surround').setup() end)

later(
  function()
    require('mini.operators').setup({
      multiply = { prefix = '' },
      exchange = { prefix = '' },
    })
  end
)

later(function()
  require('mini.diff').setup({
    view = {
      style = 'sign',
    },
  })
end)

later(
  function()
    require('mini.files').setup({
      mappings = {
        show_help = '?',
        go_in_plus = '<cr>',
        go_out_plus = '<bs>',
        go_in = '',
        go_out = '',
      },
      windows = { width_nofocus = 25 },
    })
  end
)

later(function()
  add('nvim-treesitter/nvim-treesitter-textobjects')

  local miniai = require('mini.ai')
  require('mini.ai').setup({
    n_lines = 300,
    custom_textobjects = {
      f = miniai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
      g = function()
        local from = { line = 1, col = 1 }
        local to = {
          line = vim.fn.line('$'),
          col = math.max(vim.fn.getline('$'):len(), 1),
        }
        return { from = from, to = to }
      end,
    },
    silent = true,
    search_method = 'cover',
    mappings = {
      around_next = '',
      inside_next = '',
      around_last = '',
      inside_last = '',
    },
  })
end)

later(function()
  local miniclue = require('mini.clue')

  miniclue.setup({
    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
      { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
      { mode = 'n', keys = '<Leader>c', desc = '+CodeCompanion' },
      { mode = 'n', keys = '<Leader>c', desc = '+CodeCompanion' },
      { mode = 'n', keys = '<Leader>d', desc = '+Debug' },
      { mode = 'n', keys = '<Leader>f', desc = '+Files' },
      { mode = 'n', keys = '<Leader>g', desc = '+Git' },
      { mode = 'x', keys = '<Leader>g', desc = '+Git' },
      { mode = 'n', keys = '<Leader>i', desc = '+Iron' },
      { mode = 'x', keys = '<Leader>i', desc = '+Iron' },
      { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
      { mode = 'n', keys = '<Leader>u', desc = '+Toggle' },
    },
    triggers = {
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = '<Localleader>' },
      { mode = 'x', keys = '<Localleader>' },
      { mode = 'n', keys = [[\]] },
      { mode = 'n', keys = '[' },
      { mode = 'x', keys = '[' },
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' },
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },
      { mode = 'x', keys = "'" },
      { mode = 'n', keys = '`' },
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
      delay = 200,
      config = {
        width = 'auto',
      },
    },
  })
end)
