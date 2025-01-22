Utils.Keymap('Explorer', {
  lhs = '<Leader>e',
  rhs = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local path = vim.fn.fnamemodify(bufname, ':p')
    if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
  end,
})

---
--- Toggling features
---

Snacks.toggle.indent():map('<Leader>ui', { desc = 'Indentation' })
Snacks.toggle.option('wrap'):map('<leader>uw', { desc = 'Wrap' })
Snacks.toggle.option('relativenumber'):map('<leader>ur', { desc = 'Relnum' })

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
}):map('<Leader>ua', { desc = 'Autoformat' })

---
--- [B]uffers keymaps
---

Utils.Keymap('Last', {
  lhs = '<Leader>bl',
  mode = 'n',
  rhs = '<Cmd>b#<CR>',
})

Utils.Keymap('Delete', {
  lhs = '<Leader>bd',
  mode = 'n',
  rhs = function()
    local bufdelete = Snacks.bufdelete
    bufdelete()
  end,
})

Utils.Keymap('Others', {
  lhs = '<Leader>bo',
  mode = 'n',
  rhs = function()
    local bufdelete = Snacks.bufdelete.other
    bufdelete()
  end,
})

---
--- AI [C]oding keymaps
---

Utils.Keymap('Actions', {
  lhs = '<Leader>ca',
  mode = { 'n', 'v' },
  rhs = '<Cmd>CodeCompanionActions<CR>',
})

Utils.Keymap('Toggle', {
  lhs = '<Leader>ct',
  mode = { 'n', 'v' },
  rhs = '<Cmd>CodeCompanionChat Toggle<CR>',
})

Utils.Keymap('Chat', {
  lhs = '<Leader>cc',
  mode = 'v',
  rhs = ':CodeCompanionChat Add<CR>',
})

---
--- [D]AP Keymaps
---

Utils.Keymap('REPL', {
  lhs = '<Leader>dR',
  mode = 'n',
  rhs = function()
    local dap = require('dap.repl')
    dap.toggle({}, 'belowright split')
  end,
})

Utils.Keymap('Breakpoint', {
  lhs = '<Leader>db',
  mode = 'n',
  rhs = function()
    local dap = require('dap')
    dap.toggle_breakpoint()
  end,
})

Utils.Keymap('Clear breakpoints', {
  lhs = '<Leader>dc',
  mode = 'n',
  rhs = function()
    local dap = require('dap')
    dap.clear_breakpoints()
  end,
})

Utils.Keymap('Eval', {
  lhs = '<Leader>de',
  mode = { 'n', 'x' },
  rhs = function()
    local dap_widgets = require('dap.ui.widgets')
    dap_widgets.hover()
  end,
})

Utils.Keymap('Run', {
  lhs = '<Leader>dr',
  mode = 'n',
  rhs = function()
    local dap = require('dap')
    dap.continue()
  end,
})

Utils.Keymap('Scopes', {
  lhs = '<Leader>ds',
  mode = 'n',
  rhs = function()
    local dap_widgets = require('dap.ui.widgets')
    dap_widgets.sidebar(dap_widgets.scopes, {}, 'vsplit').toggle()
  end,
})

Utils.Keymap('Quit', {
  lhs = '<Leader>dq',
  mode = 'n',
  rhs = function()
    local dap = require('dap')
    dap.terminate()
  end,
})

---
--- [F]ind keymaps
---

Utils.Keymap('Keymaps', {
  lhs = '<Leader>fk',
  mode = { 'n', 'v' },
  rhs = function()
    local keymaps = Snacks.picker
    keymaps()
  end,
})

Utils.Keymap('Buffers', {
  lhs = '<Leader>fb',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.buffers()
  end,
})

Utils.Keymap('Files', {
  lhs = '<Leader>ff',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.files()
  end,
})

Utils.Keymap('Grep', {
  lhs = '<Leader>fg',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.grep({ hidden = true })
  end,
})

Utils.Keymap('Help', {
  lhs = '<Leader>fh',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.help()
  end,
})

Utils.Keymap('Lines', {
  lhs = '<Leader>fl',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lines()
  end,
})

Utils.Keymap('Oldfiles', {
  lhs = '<Leader>fo',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.recent()
  end,
})

Utils.Keymap('Resume', {
  lhs = '<Leader>fr',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.resume()
  end,
})

Utils.Keymap('Pickers', {
  lhs = '<Leader>fp',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.pickers()
  end,
})

---
--- [G]it keymaps
---

Utils.Keymap('Blame', {
  lhs = '<Leader>gb',
  mode = 'n',
  rhs = function()
    local git = Snacks.git
    git.blame_line()
  end,
})

Utils.Keymap('Browse', {
  lhs = '<Leader>gB',
  mode = { 'n', 'v' },
  rhs = function()
    local git = Snacks.gitbrowse
    git()
  end,
})

Utils.Keymap('Diff', {
  lhs = '<Leader>gd',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.git_diff()
  end,
})

Utils.Keymap('File', {
  lhs = '<Leader>glf',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.git_log_file()
  end,
})

Utils.Keymap('Line', {
  lhs = '<Leader>gll',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.git_log_line()
  end,
})

Utils.Keymap('Repo', {
  lhs = '<Leader>glr',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.git_log()
  end,
})

Utils.Keymap('Status', {
  lhs = '<Leader>gs',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.git_status()
  end,
})

---
--- [L]sp keymaps
---

Utils.Keymap('Actions', {
  lhs = '<Leader>la',
  mode = 'n',
  rhs = function()
    local lsp = vim.lsp.buf
    lsp.code_action()
  end,
})

Utils.Keymap('Eval', {
  lhs = '<Leader>le',
  mode = 'n',
  rhs = function()
    local lsp = vim.lsp.buf
    lsp.hover({ border = 'rounded' })
  end,
})

Utils.Keymap('Help', {
  lhs = '<Leader>lh',
  mode = 'n',
  rhs = function()
    local lsp = vim.lsp.buf
    lsp.signature_help({ border = 'rounded' })
  end,
})

Utils.Keymap('Eval Error', {
  lhs = '<Leader>lE',
  mode = 'n',
  rhs = function()
    local diagnostic = vim.diagnostic
    diagnostic.open_float({ border = 'rounded' })
  end,
})

Utils.Keymap('Rename', {
  lhs = '<Leader>lR',
  mode = 'n',
  rhs = function()
    local lsp = vim.lsp.buf
    lsp.rename()
  end,
})

Utils.Keymap('Definition', {
  lhs = '<Leader>ld',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_definitions({
      include_current = true,
      auto_confirm = false,
      jump = { reuse_win = false },
    })
  end,
})

Utils.Keymap('Implementation', {
  lhs = '<Leader>li',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_implementations({
      include_current = true,
      auto_confirm = false,
      jump = { reuse_win = false },
    })
  end,
})

Utils.Keymap('References', {
  lhs = '<Leader>lr',
  mode = 'n',
  nowait = true,
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_references({
      include_declaration = true,
      include_current = true,
      auto_confirm = false,
      jump = { reuse_win = false },
    })
  end,
})

Utils.Keymap('Symbols', {
  lhs = '<Leader>ls',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_symbols()
  end,
})

Utils.Keymap('Symbols (Project)', {
  lhs = '<Leader>lS',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_workspace_symbols()
  end,
})

Utils.Keymap('Diagnostics', {
  lhs = '<Leader>lD',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.diagnostics()
  end,
})

Utils.Keymap('Type definition', {
  lhs = '<Leader>lt',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_type_definitions({
      include_current = true,
      auto_confirm = false,
      jump = { reuse_win = false },
    })
  end,
})

---
--- [N]otifications keymaps
---

Utils.Keymap('History', {
  lhs = '<Leader>nh',
  mode = 'n',
  rhs = function()
    local notifier = Snacks.notifier
    notifier.show_history()
  end,
})

Utils.Keymap('Clear', {
  lhs = '<Leader>nc',
  mode = 'n',
  rhs = function()
    local notifier = Snacks.notifier
    notifier.hide()
  end,
})
