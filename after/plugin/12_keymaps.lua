Snacks.toggle.indent():map('<leader>ui', { desc = 'Toggle indentation' })

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
}):map('<leader>uf', { desc = 'Toggle autoformat' })

Utils.Keymap2('Open file explorer', {
  lhs = '-',
  rhs = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local path = vim.fn.fnamemodify(bufname, ':p')
    if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
  end,
})

Utils.Keymap2('Open terminal buffer', {
  lhs = '<C-t>',
  rhs = function()
    local term = Snacks.terminal
    term()
  end,
})

Utils.Keymap2('Close terminal buffer', {
  lhs = '<C-t>',
  rhs = '<Cmd>close<cr>',
  mode = 't',
})

Utils.Keymap2('Find keymaps', {
  lhs = '<leader>fk',
  mode = { 'n', 'v' },
  rhs = function()
    local keymaps = Snacks.picker
    keymaps()
  end,
})

Utils.Keymap2('Git Browse', {
  lhs = '<leader>gB',
  mode = { 'n', 'v' },
  rhs = function()
    local git = Snacks.gitbrowse
    git()
  end,
})

Utils.Keymap2('Open DAP REPL', {
  lhs = '<Leader>dR',
  mode = 'n',
  rhs = function()
    local dap = require('dap.repl')
    dap.toggle({}, 'belowright split')
  end,
})

Utils.Keymap2('Set DAP breakpoint', {
  lhs = '<Leader>db',
  mode = 'n',
  rhs = function()
    local dap = require('dap')
    dap.toggle_breakpoint()
  end,
})

Utils.Keymap2('Clear all DAP breakpoints', {
  lhs = '<Leader>dc',
  mode = 'n',
  rhs = function()
    local dap = require('dap')
    dap.clear_breakpoints()
  end,
})

Utils.Keymap2('DAP eval current expression', {
  lhs = '<Leader>de',
  mode = { 'n', 'x' },
  rhs = function()
    local dap_widgets = require('dap.ui.widgets')
    dap_widgets.hover()
  end,
})

Utils.Keymap2('DAP run (continue execution)', {
  lhs = '<Leader>dr',
  mode = 'n',
  rhs = function()
    local dap = require('dap')
    dap.continue()
  end,
})

Utils.Keymap2('Inspect DAP scopes', {
  lhs = '<Leader>ds',
  mode = 'n',
  rhs = function()
    local dap_widgets = require('dap.ui.widgets')
    dap_widgets.sidebar(dap_widgets.scopes, {}, 'vsplit').toggle()
  end,
})

Utils.Keymap2('Terminate current DAP session', {
  lhs = '<Leader>dt',
  mode = 'n',
  rhs = function()
    local dap = require('dap')
    dap.terminate()
  end,
})

Utils.Keymap2('Toggle git diff overlay (mini.diff)', {
  lhs = '<Leader>go',
  mode = 'n',
  rhs = function()
    local minidiff = MiniDiff
    minidiff.toggle_overlay()
  end,
})

Utils.Keymap2('Goto last edited buffer', {
  lhs = '<Leader>bb',
  mode = 'n',
  rhs = '<Cmd>b#<CR>',
})

Utils.Keymap2('Delete current buffer', {
  lhs = '<leader>bd',
  mode = 'n',
  rhs = function()
    local bufdelete = Snacks.bufdelete
    bufdelete()
  end,
})

Utils.Keymap2('Delete other buffers', {
  lhs = '<leader>bo',
  mode = 'n',
  rhs = function()
    local bufdelete = Snacks.bufdelete.other
    bufdelete()
  end,
})

Utils.Keymap2('Find in buffer list', {
  lhs = '<leader>fb',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.buffers()
  end,
})

Utils.Keymap2('Find Files', {
  lhs = '<leader>ff',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.files()
  end,
})

Utils.Keymap2('Live grep', {
  lhs = '<leader>fg',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.grep({ hidden = true })
  end,
})

Utils.Keymap2('Find in help tags', {
  lhs = '<leader>fh',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.help()
  end,
})

Utils.Keymap2('Find in current buffer lines', {
  lhs = '<leader>fl',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lines()
  end,
})

Utils.Keymap2('Find in recent edited files', {
  lhs = '<leader>fo',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.recent()
  end,
})

Utils.Keymap2('Resume last picker', {
  lhs = '<leader>fr',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.resume()
  end,
})

Utils.Keymap2('List all pickers', {
  lhs = '<leader>fs',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.pickers()
  end,
})

Utils.Keymap2('Find in quickfix list', {
  lhs = '<leader>fx',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.qflist()
  end,
})

Utils.Keymap2('Git blame line', {
  lhs = '<leader>gb',
  mode = 'n',
  rhs = function()
    local git = Snacks.git
    git.blame_line()
  end,
})

Utils.Keymap2('Git log', {
  lhs = '<leader>gl',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.git_log()
  end,
})

Utils.Keymap2('Git status', {
  lhs = '<leader>gs',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.git_status()
  end,
})

Utils.Keymap2('LSP code actions', {
  lhs = '<Leader>la',
  mode = 'n',
  rhs = function()
    local lsp = vim.lsp.buf
    lsp.code_action()
  end,
})

Utils.Keymap2('LSP hover (eval) expression', {
  lhs = '<Leader>le',
  mode = 'n',
  rhs = function()
    local lsp = vim.lsp.buf
    lsp.hover({ border = 'rounded' })
  end,
})

Utils.Keymap2('LSP signature help', {
  lhs = '<Leader>lh',
  mode = 'n',
  rhs = function()
    local lsp = vim.lsp.buf
    lsp.signature_help({ border = 'rounded' })
  end,
})

Utils.Keymap2('Next LSP diagnostic', {
  lhs = '<Leader>lj',
  mode = 'n',
  rhs = function()
    local diagnostic = vim.diagnostic
    diagnostic.goto_next()
  end,
})

Utils.Keymap2('Previous LSP diagnostic', {
  lhs = '<Leader>lk',
  mode = 'n',
  rhs = function()
    local diagnostic = vim.diagnostic
    diagnostic.goto_prev()
  end,
})

Utils.Keymap2('Inspect LSP diagnostic', {
  lhs = '<Leader>ll',
  mode = 'n',
  rhs = function()
    local diagnostic = vim.diagnostic
    diagnostic.open_float({ border = 'rounded' })
  end,
})

Utils.Keymap2('Rename LSP symbol under cursor', {
  lhs = '<Leader>ln',
  mode = 'n',
  rhs = function()
    local lsp = vim.lsp.buf
    lsp.rename()
  end,
})

Utils.Keymap2('Go to definition', {
  lhs = '<leader>ld',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_definitions()
  end,
})

Utils.Keymap2('Go to implementation', {
  lhs = '<leader>li',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_implementations()
  end,
})

Utils.Keymap2('Go to references', {
  lhs = '<leader>lr',
  mode = 'n',
  nowait = true,
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_references()
  end,
})

Utils.Keymap2('List LSP symbols', {
  lhs = '<leader>ls',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_symbols()
  end,
})

Utils.Keymap2('List LSP diagnostics', {
  lhs = '<leader>lx',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.diagnostics()
  end,
})

Utils.Keymap2('Go to type definition', {
  lhs = '<leader>ly',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_type_definitions()
  end,
})

Utils.Keymap2('Inspect notification history', {
  lhs = '<leader>nn',
  mode = 'n',
  rhs = function()
    local notifier = Snacks.notifier
    notifier.show_history()
  end,
})

Utils.Keymap2('Clear all notifications', {
  lhs = '<leader>nc',
  mode = 'n',
  rhs = function()
    local notifier = Snacks.notifier
    notifier.hide()
  end,
})

vim.keymap.set('n', '<Leader>fc', '', {
  callback = function() print('hey') end,
  desc = 'callback test',
})

Utils.Keymap2('Send Visual Selection to REPL', {
  lhs = '<leader>ra',
  mode = 'v',
  rhs = '<Plug>(REPLSendVisual)',
})

Utils.Keymap2('Clean up REPLs', {
  lhs = '<leader>rc',
  mode = 'n',
  rhs = '<Cmd>REPLCleanup<CR>',
})

Utils.Keymap2('Start REPL', {
  lhs = '<leader>rs',
  mode = 'n',
  rhs = '<Plug>(REPLStart)',
})

Utils.Keymap2('Toggle REPL', {
  lhs = '<leader>rt',
  mode = 'n',
  rhs = '<Plug>(REPLHideOrFocus)',
})
