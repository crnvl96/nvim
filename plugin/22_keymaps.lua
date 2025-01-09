local set = vim.keymap.set

function _G.deck_git() deck.start(require('deck.builtin.source.git')({ cwd = vim.uv.cwd() })) end

function _G.deck_resume()
  local ctx = require('deck').get_history()[1]
  if ctx then ctx.show() end
end

function _G.deck_lines()
  require('deck').start(require('deck.builtin.source.lines')({
    bufnrs = { vim.api.nvim_get_current_buf() },
  }))
end

function _G.deck_files()
  require('deck').start({
    require('deck.builtin.source.files')({
      root_dir = vim.uv.cwd(),
      ignore_globs = {
        '**/node_modules/**',
        '**/.git/**',
      },
    }),
  })
end

function _G.deck_buffers()
  require('deck').start({
    require('deck.builtin.source.buffers')(),
  })
end

function _G.deck_help() require('deck').start(require('deck.builtin.source.helpgrep')()) end

function _G.deck_oldfiles()
  require('deck').start({
    require('deck.builtin.source.recent_files')(),
  })
end

function _G.deck_grep()
  require('deck').start(require('deck.builtin.source.grep')({
    dynamic = true,
    root_dir = vim.uv.cwd(),
    ignore_globs = {
      '**/node_modules/**',
      '**/.git/**',
    },
  }))
end

-- stylua: ignore start 
set('n', '<Leader>ba', '<Cmd>b#<CR>', { desc = 'Alternate buffer' })
set('n', '<Leader>bd', '<Cmd>bd<CR>', { desc = 'Delete current buffer' })
set('n', '<Leader>ca', '<Cmd>CodeCompanionActions<CR>', { desc = 'Show AI actions' })
set('x', '<Leader>cc', '<Cmd>CodeCompanionChat Add<CR>', { desc = 'Add to chat buffer' })
set('n', '<Leader>ct', '<Cmd>CodeCompanionChat Toggle<CR>', { desc = 'Toggle chat buffer' })
set('n', '<Leader>dR', '<Cmd>lua require("dap.repl").toggle({}, "belowright split")<CR>', { desc = 'Repl' })
set('n', '<Leader>db', '<Cmd>lua require("dap").toggle_breakpoint()<CR>', { desc = 'Set breakpoint' })
set('n', '<Leader>dc', '<Cmd>lua require("dap").clear_breakpoints()<CR>', { desc = 'Clear breakpoints' })
set('n', '<Leader>de', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { desc = 'Eval' })
set('n', '<Leader>dr', '<Cmd>lua require("dap").continue()<CR>', { desc = 'Continue' })
set('n', '<Leader>ds', '<Cmd>lua require("dap.ui.widgets").sidebar(require("dap.ui.widgets").scopes, {}, "vsplit").toggle()<CR>', { desc = 'Scopes' })
set('n', '<Leader>dt', '<Cmd>lua require("dap").terminate()<CR>', { desc = 'Terminate' })
set('n', '<Leader>du', '<Cmd>lua require("dap").run_to_cursor()<CR>', { desc = 'Run to cursor' })
set('n', '<Leader>ee', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>')
set('n', '<Leader>fb', '<Cmd>lua _G.deck_buffers()<CR>', { desc = 'Buffers' })
set('n', '<Leader>ff', '<Cmd>lua _G.deck_files()<CR>', { desc = 'Find files' })
set('n', '<Leader>fg', '<Cmd>lua _G.deck_grep()<CR>', { desc = 'Grep' })
set('n', '<Leader>fh', '<Cmd>lua _G.deck_help()<CR>', { desc = 'Help tags' })
set('n', '<Leader>fl', '<Cmd>lua _G.deck_lines()<CR>', { desc = 'Buffer lines' })
set('n', '<Leader>fo', '<Cmd>lua _G.deck_oldfiles()<CR>', { desc = 'Oldfiles' })
set('n', '<Leader>fr', '<Cmd>lua _G.deck_resume()<CR>', { desc = 'Resume last context' })
set('n', '<Leader>gg', '<Cmd>lua _G.deck_git()<CR>', { desc = 'Git' })
set('n', '<Leader>ia', '<cmd>IronAttach<cr>', { desc = 'Iron Attach' })
set('n', '<Leader>ih', '<cmd>IronHide<cr>', { desc = 'Iron Hide' })
set('n', '<Leader>io', '<cmd>IronFocus<cr>', { desc = 'Iron Focus' })
set('n', '<Leader>ie', '<cmd>IronRepl<cr>', { desc = 'Iron Repl' })
set('n', '<Leader>ir', '<cmd>IronRestart<cr>', { desc = 'Iron Restart' })
set('n', '<Leader>is', '<cmd>IronSend<cr>', { desc = 'Iron Send' })
set('n', '<Leader>nh', '<Cmd>lua MiniNotify.show_history()<CR>', { desc = 'Show notification history' })
