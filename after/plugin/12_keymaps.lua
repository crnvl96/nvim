local H = {}
local set = vim.keymap.set

---
--- Helpers
---

function H.minifiles_open()
  local bufname = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.fnamemodify(bufname, ':p')
  if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
end

function H.dap_scopes() require('dap.ui.widgets').sidebar(require('dap.ui.widgets').scopes, {}, 'vsplit').toggle() end

---
--- Keymaps
---

set({ 'n', 't' }, '[[', function() Snacks.words.jump(-vim.v.count1) end, { desc = 'Prev Reference' })
set({ 'n', 't' }, ']]', function() Snacks.words.jump(vim.v.count1) end, { desc = 'Next Reference' })
set({ 'n', 'v' }, '<leader>gB', function() Snacks.gitbrowse() end, { desc = 'Git Browse' })

set('n', '-', function() H.minifiles_open() end, { desc = 'File explorer' })

set('n', '<C-t>', function() Snacks.terminal() end, { desc = 'Terminal' })
set('t', '<C-t>', '<cmd>close<cr>', { desc = 'Hide Terminal' })

set('n', '<leader>.', function() Snacks.scratch() end, { desc = 'Toggle Scratch Buffer' })

set('n', '<Leader>dR', '<Cmd>lua require("dap.repl").toggle({}, "belowright split")<CR>', { desc = 'Repl' })
set('n', '<Leader>db', '<Cmd>lua require("dap").toggle_breakpoint()<CR>', { desc = 'Set breakpoint' })
set('n', '<Leader>dc', '<Cmd>lua require("dap").clear_breakpoints()<CR>', { desc = 'Clear breakpoints' })
set('n', '<Leader>de', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { desc = 'Eval' })
set('n', '<Leader>dr', '<Cmd>lua require("dap").continue()<CR>', { desc = 'Continue' })
set('n', '<Leader>ds', function() H.dap_scopes() end, { desc = 'Scopes' })
set('n', '<Leader>dt', '<Cmd>lua require("dap").terminate()<CR>', { desc = 'Terminate' })
set('n', '<Leader>du', '<Cmd>lua require("dap").run_to_cursor()<CR>', { desc = 'Run to cursor' })
set('n', '<Leader>go', function() MiniDiff.toggle_overlay() end, { desc = 'Toggle diff overlay' })
set('n', '<Leader>ia', '<cmd>IronAttach<cr>', { desc = 'Iron Attach' })
set('n', '<Leader>ie', '<cmd>IronRepl<cr>', { desc = 'Iron Repl' })
set('n', '<Leader>ih', '<cmd>IronHide<cr>', { desc = 'Iron Hide' })
set('n', '<Leader>io', '<cmd>IronFocus<cr>', { desc = 'Iron Focus' })
set('n', '<Leader>ir', '<cmd>IronRestart<cr>', { desc = 'Iron Restart' })
set('n', '<Leader>is', '<cmd>IronSend<cr>', { desc = 'Iron Send' })
set('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete Buffer' })
set('n', '<leader>fb', function() Snacks.picker.buffers() end, { desc = 'Buffers' })
set('n', '<leader>ff', function() Snacks.picker.files() end, { desc = 'Find Files' })
set('n', '<leader>fg', function() Snacks.picker.grep({ hidden = true }) end, { desc = 'Grep' })
set('n', '<leader>fh', function() Snacks.picker.help() end, { desc = 'Help Pages' })
set('n', '<leader>fk', function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })
set('n', '<leader>fl', function() Snacks.picker.lines() end, { desc = 'Buffer Lines' })
set('n', '<leader>fm', function() Snacks.picker.marks() end, { desc = 'Marks' })
set('n', '<leader>fo', function() Snacks.picker.recent() end, { desc = 'Recent' })
set('n', '<leader>fp', function() Snacks.picker.projects() end, { desc = 'Projects' })
set('n', '<leader>fr', function() Snacks.picker.resume() end, { desc = 'Resume' })
set('n', '<leader>fx', function() Snacks.picker.qflist() end, { desc = 'Quickfix List' })
set('n', '<leader>fz', function() Snacks.picker.zoxide() end, { desc = 'Z' })
set('n', '<leader>gb', function() Snacks.git.blame_line() end, { desc = 'Git Blame Line' })
set('n', '<leader>gf', function() Snacks.lazygit.log_file() end, { desc = 'Lazygit Current File History' })
set('n', '<leader>gg', function() Snacks.lazygit() end, { desc = 'Lazygit' })
set('n', '<leader>gl', function() Snacks.lazygit.log() end, { desc = 'Lazygit Log (cwd)' })
set('n', '<leader>gl', function() Snacks.picker.git_log() end, { desc = 'Git Log' })
set('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = 'Git Status' })
set('n', '<leader>ld', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
set('n', '<leader>li', function() Snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })
set('n', '<leader>lr', function() Snacks.picker.lsp_references() end, { nowait = true, desc = 'References' })
set('n', '<leader>ls', function() Snacks.picker.lsp_symbols() end, { desc = 'LSP Symbols' })
set('n', '<leader>lx', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostics' })
set('n', '<leader>ly', function() Snacks.picker.lsp_type_definitions() end, { desc = 'Goto T[y]pe Definition' })
set('n', '<leader>n', function() Snacks.notifier.show_history() end, { desc = 'Notification History' })
set('n', '<leader>un', function() Snacks.notifier.hide() end, { desc = 'Dismiss All Notifications' })
set('v', '<Leader>ca', ':CodeCompanionChat Add<CR>', { desc = 'Add to chat' })
set({ 'n', 'v' }, '<Leader>ca', ':CodeCompanionActions<CR>', { desc = 'Actions' })
set({ 'n', 'v' }, '<Leader>ct', ':CodeCompanionChat Toggle<CR>', { desc = 'Toggle chat' })
