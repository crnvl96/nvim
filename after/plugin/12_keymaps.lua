vim.g.autoformat = true

local autoformat = {
  name = 'Auto format (conform.nvim)',
  get = function() return vim.g.autoformat end,
  set = function(e)
    if e then
      vim.g.autoformat = true
    else
      vim.g.autoformat = false
    end
  end,
}

local hlword = {
  name = 'Words',
  get = function() return Snacks.words.is_enabled() end,
  set = function(e)
    if e then
      Snacks.words.enable()
    else
      Snacks.words.disable()
    end
  end,
}

local function open_file_explorer()
  local bufname = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.fnamemodify(bufname, ':p')
  if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
end

local function dap_scopes() require('dap.ui.widgets').sidebar(require('dap.ui.widgets').scopes, {}, 'vsplit').toggle() end

-- stylua: ignore start
Snacks.toggle.diagnostics():map('<leader>ud')
Snacks.toggle.dim():map('<leader>uD')
Snacks.toggle.indent():map('<leader>ui')
Snacks.toggle.inlay_hints():map('<leader>uh')
Snacks.toggle.line_number():map('<leader>ul')
Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')
Snacks.toggle.option('conceallevel', { off = 0, on = 2 }):map('<leader>uc')
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>uS')
Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
Snacks.toggle.treesitter():map('<leader>uT')
Snacks.toggle(autoformat):map('<leader>uf')
Snacks.toggle(hlword):map('<leader>uW')

Utils.Set('n', '-', open_file_explorer, { desc = 'Open file explorer' })
Utils.Set('n', '<C-t>', function() Snacks.terminal() end, { desc = 'Open terminal' })
Utils.Set('t', '<C-t>', '<cmd>close<cr>', { desc = 'Hide Terminal' })


Utils.Set({ 'n', 't' }, '[[', function() Snacks.words.jump(-vim.v.count1) end, { desc = 'Hlword previous reference' })
Utils.Set({ 'n', 't' }, ']]', function() Snacks.words.jump(vim.v.count1) end, { desc = 'Hlword next reference' })
Utils.Set({ 'n', 'v' }, '<Leader>ct', '<Cmd>CodeCompanionChat Toggle<CR>', { desc = 'Toggle codecompanion chat' })
Utils.Set({ 'n', 'v' }, '<leader>fk', function() Snacks.picker.keymaps() end, { desc = 'Find keymaps' })
Utils.Set({ 'n', 'v' }, '<leader>gB', function() Snacks.gitbrowse() end, { desc = 'Git Browse' })

Utils.Set('n', '<leader>us', function() Snacks.scratch() end, { desc = 'Toggle Scratch Buffer' })
Utils.Set('n', '<Leader>ca', '<Cmd>CodeCompanionActions<CR>', { desc = 'Code Companion actions' })
Utils.Set('v', '<Leader>ca', ':CodeCompanionChat Add<CR>', { desc = 'Add to codecompanion chat' })
Utils.Set('n', '<Leader>dR', function() require('dap.repl').toggle({}, 'belowright split') end, { desc = 'Open dap repl' })
Utils.Set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'set dap breakpoint' })
Utils.Set('n', '<Leader>dc', function() require('dap').clear_breakpoints() end, { desc = 'Clear dap breakpoints' })
Utils.Set('n', '<Leader>de', function() require('dap.ui.widgets').hover() end, { desc = 'Eval' })
Utils.Set('n', '<Leader>dr', function() require('dap').continue() end, { desc = 'Continue' })
Utils.Set('n', '<Leader>ds', dap_scopes, { desc = 'Open dap scopes' })
Utils.Set('n', '<Leader>dt', function() require('dap').terminate() end, { desc = 'Terminate dap session' })
Utils.Set('n', '<Leader>go', function() MiniDiff.toggle_overlay() end, { desc = 'Toggle minidiff overlay' })
Utils.Set('n', '<Leader>bb', '<Cmd>b#<CR>', { desc = 'Goto last buffer' })
Utils.Set('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete Buffer' })
Utils.Set('n', '<leader>bo', function() Snacks.bufdelete.other() end, { desc = 'Delete Other Buffers' })
Utils.Set('n', '<leader>fb', function() Snacks.picker.buffers() end, { desc = 'Find buffers' })
Utils.Set('n', '<leader>ff', function() Snacks.picker.files() end, { desc = 'Find Files' })
Utils.Set('n', '<leader>fg', function() Snacks.picker.grep({ hidden = true }) end, { desc = 'Find grep' })
Utils.Set('n', '<leader>fh', function() Snacks.picker.help() end, { desc = 'Find in help tags' })
Utils.Set('n', '<leader>fl', function() Snacks.picker.lines() end, { desc = 'Find buffer Lines' })
Utils.Set('n', '<leader>fm', function() Snacks.picker.marks() end, { desc = 'Find Marks' })
Utils.Set('n', '<leader>fo', function() Snacks.picker.recent() end, { desc = 'Find Recent' })
Utils.Set('n', '<leader>fp', function() Snacks.picker.projects() end, { desc = 'Find Projects' })
Utils.Set('n', '<leader>fr', function() Snacks.picker.resume() end, { desc = 'Resume last picker' })
Utils.Set('n', '<leader>fs', function() Snacks.picker.pickers() end, { desc = 'Find Pickers' })
Utils.Set('n', '<leader>fx', function() Snacks.picker.qflist() end, { desc = 'Find inQuickfix List' })
Utils.Set('n', '<leader>fz', function() Snacks.picker.zoxide() end, { desc = 'Find Zoxide' })
Utils.Set('n', '<leader>gb', function() Snacks.git.blame_line() end, { desc = 'Git Blame Line' })
Utils.Set('n', '<leader>gf', function() Snacks.lazygit.log_file() end, { desc = 'Lazygit Current File History' })
Utils.Set('n', '<leader>gg', function() Snacks.lazygit() end, { desc = 'Lazygit' })
Utils.Set('n', '<leader>gl', function() Snacks.lazygit.log() end, { desc = 'Lazygit Log (cwd)' })
Utils.Set('n', '<leader>gl', function() Snacks.picker.git_log() end, { desc = 'Git Log' })
Utils.Set('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = 'Git Status' })
Utils.Set('n', '<Leader>la', function() vim.lsp.buf.code_action() end, { desc = 'Lsp code actions' })
Utils.Set('n', '<Leader>le', function() vim.lsp.buf.hover({ border = 'rounded' }) end, { desc = 'lsp hover (eval) expression' })
Utils.Set('n', '<Leader>lh', function() vim.lsp.buf.signature_help({ border = 'rounded' }) end, { desc = 'Lsp signature help' })
Utils.Set('n', '<Leader>lj', function() vim.diagnostic.goto_next() end, { desc = 'Next lsp diagnostic' })
Utils.Set('n', '<Leader>lk', function() vim.diagnostic.goto_prev() end, { desc = 'Previous lsp diagnostic' })
Utils.Set('n', '<Leader>ll', function() vim.diagnostic.open_float({ border = 'rounded' }) end, { desc = 'Inspect lsp diagnostic' })
Utils.Set('n', '<Leader>ln', function() vim.lsp.buf.rename() end, { desc = 'Rename lsp symbol under cursor' })
Utils.Set('n', '<leader>ld', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
Utils.Set('n', '<leader>li', function() Snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })
Utils.Set('n', '<leader>lr', function() Snacks.picker.lsp_references() end, { nowait = true, desc = 'References' })
Utils.Set('n', '<leader>ls', function() Snacks.picker.lsp_symbols() end, { desc = 'LSP Symbols' })
Utils.Set('n', '<leader>lx', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostics' })
Utils.Set('n', '<leader>ly', function() Snacks.picker.lsp_type_definitions() end, { desc = 'Goto T[y]pe Definition' })
Utils.Set('n', '<leader>un', function() Snacks.notifier.show_history() end, { desc = 'Toggle Notif History' })
Utils.Set('n', '<leader>uN', function() Snacks.notifier.hide() end, { desc = 'Dismiss All Notifications' })
