Snacks.toggle.indent():map('<Leader>ui', { desc = 'Toggle indentation' })

vim.g.autoformat = true

Snacks.toggle({
  name = 'Auto format',
  get = function() return vim.g.autoformat end,
  set = function(e)
    if e then
      vim.g.autoformat = true
    else
      vim.g.autoformat = false
    end
  end,
}):map('<Leader>uf', { desc = 'Toggle autoformat' })

Utils.Keymap('Open file explorer', {
  lhs = '-',
  rhs = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local path = vim.fn.fnamemodify(bufname, ':p')
    if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
  end,
})

Utils.Keymap('Open terminal buffer', {
  lhs = '<C-t>',
  rhs = function()
    local term = Snacks.terminal
    term()
  end,
})

Utils.Keymap('Close terminal buffer', {
  lhs = '<C-t>',
  rhs = '<Cmd>close<cr>',
  mode = 't',
})

Utils.Keymap('Find keymaps', {
  lhs = '<Leader>fk',
  mode = { 'n', 'v' },
  rhs = function()
    local keymaps = Snacks.picker
    keymaps()
  end,
})

Utils.Keymap('Git Browse', {
  lhs = '<Leader>gB',
  mode = { 'n', 'v' },
  rhs = function()
    local git = Snacks.gitbrowse
    git()
  end,
})

Utils.Keymap('Open DAP REPL', {
  lhs = '<Leader>dR',
  mode = 'n',
  rhs = function()
    local dap = require('dap.repl')
    dap.toggle({}, 'belowright split')
  end,
})

Utils.Keymap('Set DAP breakpoint', {
  lhs = '<Leader>db',
  mode = 'n',
  rhs = function()
    local dap = require('dap')
    dap.toggle_breakpoint()
  end,
})

Utils.Keymap('Clear all DAP breakpoints', {
  lhs = '<Leader>dc',
  mode = 'n',
  rhs = function()
    local dap = require('dap')
    dap.clear_breakpoints()
  end,
})

Utils.Keymap('DAP eval current expression', {
  lhs = '<Leader>de',
  mode = { 'n', 'x' },
  rhs = function()
    local dap_widgets = require('dap.ui.widgets')
    dap_widgets.hover()
  end,
})

Utils.Keymap('DAP run (continue execution)', {
  lhs = '<Leader>dr',
  mode = 'n',
  rhs = function()
    local dap = require('dap')
    dap.continue()
  end,
})

Utils.Keymap('Inspect DAP scopes', {
  lhs = '<Leader>ds',
  mode = 'n',
  rhs = function()
    local dap_widgets = require('dap.ui.widgets')
    dap_widgets.sidebar(dap_widgets.scopes, {}, 'vsplit').toggle()
  end,
})

Utils.Keymap('Terminate current DAP session', {
  lhs = '<Leader>dt',
  mode = 'n',
  rhs = function()
    local dap = require('dap')
    dap.terminate()
  end,
})

Utils.Keymap('Toggle git diff overlay (mini.diff)', {
  lhs = '<Leader>go',
  mode = 'n',
  rhs = function()
    local minidiff = MiniDiff
    minidiff.toggle_overlay()
  end,
})

Utils.Keymap('Goto last edited buffer', {
  lhs = '<Leader>bb',
  mode = 'n',
  rhs = '<Cmd>b#<CR>',
})

Utils.Keymap('Delete current buffer', {
  lhs = '<Leader>bd',
  mode = 'n',
  rhs = function()
    local bufdelete = Snacks.bufdelete
    bufdelete()
  end,
})

Utils.Keymap('Delete other buffers', {
  lhs = '<Leader>bo',
  mode = 'n',
  rhs = function()
    local bufdelete = Snacks.bufdelete.other
    bufdelete()
  end,
})

Utils.Keymap('Find in buffer list', {
  lhs = '<Leader>fb',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.buffers()
  end,
})

Utils.Keymap('Find Files', {
  lhs = '<Leader>ff',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.files()
  end,
})

Utils.Keymap('Live grep', {
  lhs = '<Leader>fg',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.grep({ hidden = true })
  end,
})

Utils.Keymap('Find in help tags', {
  lhs = '<Leader>fh',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.help()
  end,
})

Utils.Keymap('Find in current buffer lines', {
  lhs = '<Leader>fl',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lines()
  end,
})

Utils.Keymap('Find in recent edited files', {
  lhs = '<Leader>fo',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.recent()
  end,
})

Utils.Keymap('Resume last picker', {
  lhs = '<Leader>fr',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.resume()
  end,
})

Utils.Keymap('List all pickers', {
  lhs = '<Leader>fs',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.pickers()
  end,
})

Utils.Keymap('Find in quickfix list', {
  lhs = '<Leader>fx',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.qflist()
  end,
})

Utils.Keymap('Git blame line', {
  lhs = '<Leader>gb',
  mode = 'n',
  rhs = function()
    local git = Snacks.git
    git.blame_line()
  end,
})

Utils.Keymap('Git log', {
  lhs = '<Leader>gl',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.git_log()
  end,
})

Utils.Keymap('Git status', {
  lhs = '<Leader>gs',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.git_status()
  end,
})

Utils.Keymap('LSP code actions', {
  lhs = '<Leader>la',
  mode = 'n',
  rhs = function()
    local lsp = vim.lsp.buf
    lsp.code_action()
  end,
})

Utils.Keymap('LSP hover (eval) expression', {
  lhs = '<Leader>le',
  mode = 'n',
  rhs = function()
    local lsp = vim.lsp.buf
    lsp.hover({ border = 'rounded' })
  end,
})

Utils.Keymap('LSP signature help', {
  lhs = '<Leader>lh',
  mode = 'n',
  rhs = function()
    local lsp = vim.lsp.buf
    lsp.signature_help({ border = 'rounded' })
  end,
})

Utils.Keymap('Next LSP diagnostic', {
  lhs = '<Leader>lj',
  mode = 'n',
  rhs = function()
    local diagnostic = vim.diagnostic
    diagnostic.goto_next()
  end,
})

Utils.Keymap('Previous LSP diagnostic', {
  lhs = '<Leader>lk',
  mode = 'n',
  rhs = function()
    local diagnostic = vim.diagnostic
    diagnostic.goto_prev()
  end,
})

Utils.Keymap('Inspect LSP diagnostic', {
  lhs = '<Leader>ll',
  mode = 'n',
  rhs = function()
    local diagnostic = vim.diagnostic
    diagnostic.open_float({ border = 'rounded' })
  end,
})

Utils.Keymap('Rename LSP symbol under cursor', {
  lhs = '<Leader>ln',
  mode = 'n',
  rhs = function()
    local lsp = vim.lsp.buf
    lsp.rename()
  end,
})

Utils.Keymap('Go to definition', {
  lhs = '<Leader>ld',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_definitions()
  end,
})

Utils.Keymap('Go to implementation', {
  lhs = '<Leader>li',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_implementations()
  end,
})

Utils.Keymap('Go to references', {
  lhs = '<Leader>lr',
  mode = 'n',
  nowait = true,
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_references()
  end,
})

Utils.Keymap('List LSP symbols', {
  lhs = '<Leader>ls',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_symbols()
  end,
})

Utils.Keymap('List LSP diagnostics', {
  lhs = '<Leader>lx',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.diagnostics()
  end,
})

Utils.Keymap('Go to type definition', {
  lhs = '<Leader>ly',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_type_definitions()
  end,
})

Utils.Keymap('Inspect notification history', {
  lhs = '<Leader>nn',
  mode = 'n',
  rhs = function()
    local notifier = Snacks.notifier
    notifier.show_history()
  end,
})

Utils.Keymap('Clear all notifications', {
  lhs = '<Leader>nc',
  mode = 'n',
  rhs = function()
    local notifier = Snacks.notifier
    notifier.hide()
  end,
})

Utils.Keymap('Start Aider', {
  lhs = '<Leader>as',
  mode = 'n',
  rhs = '<Plug>(REPLStart-aider)',
})

Utils.Keymap('Toggle Aider', {
  lhs = '<Leader>at',
  mode = 'n',
  rhs = '<Plug>(REPLHideOrFocus-aider)',
})

Utils.Keymap('Send visual to Aider', {
  lhs = '<Leader>av',
  mode = 'v',
  rhs = '<Plug>(REPLSendVisual-aider)',
})

Utils.Keymap('Exec in Aider', {
  lhs = '<Leader>ae',
  mode = 'n',
  rhs = '<Plug>(AiderExec)',
})

Utils.Keymap('Send yes to Aider', {
  lhs = '<Leader>ay',
  mode = 'n',
  rhs = '<Plug>(AiderSendYes)',
})

Utils.Keymap('Send no to Aider', {
  lhs = '<Leader>an',
  mode = 'n',
  rhs = '<Plug>(AiderSendNo)',
})

Utils.Keymap('Send abort to Aider', {
  lhs = '<Leader>aa',
  mode = 'n',
  rhs = '<Plug>(AiderSendAbort)',
})

Utils.Keymap('Send exit to Aider', {
  lhs = '<Leader>aq',
  mode = 'n',
  rhs = '<Plug>(AiderSendExit)',
})

Utils.Keymap('Send clear to Aider', {
  lhs = '<Leader>ac',
  mode = 'n',
  rhs = '<Plug>(AiderSendClear)',
})

Utils.Keymap('Change Aider to ask mode', {
  lhs = '<Leader>ama',
  mode = 'n',
  rhs = '<Plug>(AiderSendAskMode)',
})

Utils.Keymap('Change Aider to arch mode', {
  lhs = '<Leader>amA',
  mode = 'n',
  rhs = '<Plug>(AiderSendArchMode)',
})

Utils.Keymap('Change Aider to code mode', {
  lhs = '<Leader>amc',
  mode = 'n',
  rhs = '<Plug>(AiderSendCodeMode)',
})

Utils.Keymap('Sync buffer with Aider changes', {
  lhs = '<Leader>a<Space>',
  mode = 'n',
  rhs = '<Cmd>checktime<CR>',
})
