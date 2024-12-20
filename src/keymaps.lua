Config.open_lazygit = function()
  vim.cmd('tabedit')
  vim.cmd('setlocal nonumber signcolumn=no')

  vim.fn.termopen('VIMRUNTIME= VIM= lazygit --git-dir=$(git rev-parse --git-dir) --work-tree=$(realpath .)', {
    on_exit = function()
      vim.cmd('silent! :checktime')
      vim.cmd('silent! :bw')
    end,
  })
  vim.cmd('startinsert')
  vim.b.minipairs_disable = true
end

Config.toggle_quickfix = function()
  local quickfix_wins = vim.tbl_filter(
    function(win_id) return vim.fn.getwininfo(win_id)[1].quickfix == 1 end,
    vim.api.nvim_tabpage_list_wins(0)
  )

  local command = #quickfix_wins == 0 and 'copen' or 'cclose'
  vim.cmd(command)
end

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true })

vim.keymap.set('i', ',', ',<c-g>u')
vim.keymap.set('i', '.', '.<c-g>u')
vim.keymap.set('i', ';', ';<c-g>u')

vim.keymap.set('x', 'p', 'P')

vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')

vim.keymap.set('n', '<c-up>', '<cmd>resize +5<cr>')
vim.keymap.set('n', '<c-down>', '<cmd>resize -5<cr>')
vim.keymap.set('n', '<c-left>', '<cmd>vertical resize -20<cr>')
vim.keymap.set('n', '<c-right>', '<cmd>vertical resize +20<cr>')

vim.keymap.set({ 'n', 'v', 'i' }, '<esc>', '<esc><cmd>nohl<cr><esc>')
vim.keymap.set({ 'n', 'i', 'x' }, '<c-s>', '<esc><cmd>w<cr><esc>')

vim.keymap.set('t', [[<C-h>]], [[<C-\><C-N><C-w>h]])
vim.keymap.set('s', [[<BS>]], [[<BS>i]])

vim.keymap.set('n', '<c-t>', function() Snacks.terminal() end, { desc = 'term: toggle' })
vim.keymap.set({ 'n', 't' }, ']]', function() Snacks.words.jump(vim.v.count1) end, { desc = 'next reference' })
vim.keymap.set({ 'n', 't' }, '[[', function() Snacks.words.jump(-vim.v.count1) end, { desc = 'prev reference' })

--
-- b: buffer
--
vim.keymap.set('n', '<Leader>bb', '<Cmd>b#<CR>', { desc = 'buf: alternate' })
vim.keymap.set('n', '<Leader>bd', '<Cmd>lua MiniBufremove.delete()<CR>', { desc = 'buf: delete' })
vim.keymap.set('n', '<Leader>bD', '<Cmd>lua MiniBufremove.delete(0, true)<CR>', { desc = 'buf: delete!' })

--
-- c: code
--
local remap = function(mode, lhs_from, lhs_to)
  local keymap = vim.fn.maparg(lhs_from, mode, false, true)
  local rhs = keymap.callback or keymap.rhs
  if rhs == nil then error('Could not remap from ' .. lhs_from .. ' to ' .. lhs_to) end
  vim.keymap.set(mode, lhs_to, rhs, { desc = keymap.desc })
end

vim.keymap.set('n', '<leader>ch', '<cmd>lua MiniNotify.show_history()<CR>', { desc = 'notify: history' })
remap('n', 'gx', '<Leader>cx')
remap('x', 'gx', '<Leader>cx')

--
-- d: debug
--
local dap_widgets = require('dap.ui.widgets')
local vsplit = function(widget) dap_widgets.sidebar(widget, {}, 'vsplit').toggle() end
local hsplit = function(widget) dap_widgets.sidebar(widget, { height = 10 }, 'belowright split').toggle() end

-- stylua: ignore start
vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'dap: toggle breakpoint' })
vim.keymap.set('n', '<leader>dx', function() require('dap').clear_breakpoints() end, { desc = 'dap: clear breakpoints' })
vim.keymap.set('n', '<leader>da', function() require('dap.repl').toggle({}, 'belowright split') end, { desc = 'dap: repl' })
-- stylua: ignore end
vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { desc = 'dap: continue execution' })
vim.keymap.set('n', '<leader>dC', function() require('dap').run_to_cursor() end, { desc = 'dap: run to cursor' })
vim.keymap.set('n', '<leader>dt', function() require('dap').terminate() end, { desc = 'dap: terminate session' })
vim.keymap.set({ 'n', 'v' }, '<leader>de', function() require('dap.ui.widgets').hover() end, { desc = 'dap: hover' })
vim.keymap.set('n', '<leader>ds', function() vsplit(dap_widgets.scopes) end, { desc = 'dap: scopes' })
vim.keymap.set('n', '<leader>df', function() hsplit(dap_widgets.frames) end, { desc = 'dap: frames' })

--
-- e (-): explorer
--
vim.keymap.set('n', '<leader>e', function()
  local bufname = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.fnamemodify(bufname, ':p')
  if path and vim.uv.fs_stat(path) then MiniFiles.open(bufname, false) end
end, { desc = 'minifiles: file directory' })

-- 
-- f: files
--
-- stylua: ignore start
vim.keymap.set('n', '<Leader>fa', '<Cmd>Pick git_hunks path="%" scope="staged"<CR>', { desc = 'minipick: added hunks (current)' })
vim.keymap.set('n', '<Leader>fv', '<Cmd>Pick visit_paths preserve_order=true<CR>', { desc = 'minipick: visit paths (cwd)' })
-- stylua: ignore end
vim.keymap.set('n', '<Leader>f/', '<Cmd>Pick history scope="/"<CR>', { desc = 'minipick: "/" history' })
vim.keymap.set('n', '<Leader>f:', '<Cmd>Pick history scope=":"<CR>', { desc = 'minipick: ":" history' })

vim.keymap.set('n', 'z=', '<Cmd>Pick spellsuggest<CR>', { desc = 'minipick: spellsuggest' })

vim.keymap.set('n', '<Leader>fA', '<Cmd>Pick git_hunks scope="staged"<CR>', { desc = 'minipick: added hunks (all)' })
vim.keymap.set('n', '<Leader>fC', '<Cmd>Pick git_commits<CR>', { desc = 'minipick: commits (all)' })
vim.keymap.set('n', '<Leader>fD', '<Cmd>Pick diagnostic scope="current"<CR>', { desc = 'minipick: diagnostic buffer' })
vim.keymap.set('n', '<Leader>fG', '<Cmd>Pick grep pattern="<cword>"<CR>', { desc = 'minipick: grep current word' })
vim.keymap.set('n', '<Leader>fH', '<Cmd>Pick hl_groups<CR>', { desc = 'minipick: highlight groups' })
vim.keymap.set('n', '<Leader>fL', '<Cmd>Pick buf_lines scope="all"<CR>', { desc = 'minipick: lines (all)' })
vim.keymap.set('n', '<Leader>fM', '<Cmd>Pick git_hunks<CR>', { desc = 'minipick: modified hunks (all)' })

vim.keymap.set('n', '<Leader>fb', '<Cmd>Pick buffers<CR>', { desc = 'minipick: buffers' })
vim.keymap.set('n', '<Leader>fc', '<Cmd>Pick git_commits path="%"<CR>', { desc = 'minipick: commits (current)' })
vim.keymap.set('n', '<Leader>fd', '<Cmd>Pick diagnostic scope="all"<CR>', { desc = 'minipick: diagnostic workspace' })
vim.keymap.set('n', '<Leader>ff', '<Cmd>Pick files<CR>', { desc = 'minipick: files' })
-- vim.keymap.set('n', '<Leader>fg', '<Cmd>Pick grep_live<CR>', { desc = 'minipick: grep live' })
vim.keymap.set('n', '<leader>fg', '<cmd>Pick multigrep<CR>', { desc = 'minipick: multigrep' })
vim.keymap.set('n', '<Leader>fh', '<Cmd>Pick help<CR>', { desc = 'minipick: help tags' })
vim.keymap.set('n', '<Leader>fl', '<Cmd>Pick buf_lines scope="current"<CR>', { desc = 'minipick: lines (current)' })
vim.keymap.set('n', '<Leader>fm', '<Cmd>Pick git_hunks path="%"<CR>', { desc = 'minipick: modified hunks (current)' })
vim.keymap.set('n', '<Leader>fr', '<Cmd>Pick resume<CR>', { desc = 'minipick: resume' })

--
-- g: git
--
local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]

vim.keymap.set('n', '<leader>gA', '<cmd>Git diff --cached -- %<CR>', { desc = 'minigit: added diff buffer' })
vim.keymap.set('n', '<leader>gC', '<cmd>Git commit --amend<CR>', { desc = 'minigit: commit amend' })
vim.keymap.set('n', '<leader>gD', '<cmd>Git diff -- %<CR>', { desc = 'minigit: diff buffer' })
vim.keymap.set('n', '<leader>gL', '<cmd>' .. git_log_cmd .. ' --follow -- %<CR>', { desc = 'minigit: log buffer' })
vim.keymap.set('n', '<leader>ga', '<cmd>Git diff --cached<CR>', { desc = 'minigit: added diff' })
vim.keymap.set('n', '<leader>gc', '<cmd>Git commit<CR>', { desc = 'minigit: commit' })
vim.keymap.set('n', '<leader>gd', '<cmd>Git diff<CR>', { desc = 'minigit: diff' })
-- vim.keymap.set('n', '<leader>gg', '<cmd>lua Config.open_lazygit()<CR>', { desc = 'lzg: open' })
vim.keymap.set('n', '<leader>gl', '<cmd>' .. git_log_cmd .. '<CR>', { desc = 'minigit: log' })
vim.keymap.set('n', '<leader>go', '<cmd>lua MiniDiff.toggle_overlay()<CR>', { desc = 'minidiff: toggle overlay' })
-- stylua: ignore
vim.keymap.set('n', '<leader>gx', '<cmd>lua vim.fn.setqflist(MiniDiff.export("qf"))<CR>', { desc = 'minidiff: setqflist' })
-- stylua: ignore
vim.keymap.set( { 'n', 'v' }, '<Leader>gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', { desc = 'minigit: show at cursor' })
vim.keymap.set('n', '<leader>gB', function() Snacks.gitbrowse() end, { desc = 'git: browse' })
vim.keymap.set('n', '<leader>gb', function() Snacks.git.blame_line() end, { desc = 'git: blame line' })
vim.keymap.set('n', '<leader>gf', function() Snacks.lazygit.log_file() end, { desc = 'lzg: current file history' })
vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end, { desc = 'lzg: open' })
vim.keymap.set('n', '<leader>gl', function() Snacks.lazygit.log() end, { desc = 'lzg: log (cwd)' })

--
-- i: ia
--
vim.keymap.set({ 'n', 'v' }, '<leader>ii', '<cmd>CodeCompanionActions<cr>', { desc = 'codecomp: actions' })
vim.keymap.set({ 'n', 'v' }, '<leader>ic', '<cmd>CodeCompanionChat Toggle<cr>', { desc = 'codecomp: chat' })
vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>', { desc = 'codecomp: add to chat' })

--
-- l: lsp
--
function Config.on_attach(client)
  local formatting_cmd =
    '<Cmd>lua require("conform").format({ timeout_ms = 3000, async = false, quiet = false, lsp_format = "fallback" })<CR>'

  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  vim.o.omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

  vim.keymap.set('n', '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'lsp: code action' })
  vim.keymap.set('n', '<Leader>lh', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', { desc = 'lsp: arguments popup' })
  vim.keymap.set('n', '<Leader>ld', '<Cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'lsp: diagnostics popup' })
  vim.keymap.set('n', '<Leader>li', '<Cmd>lua vim.lsp.buf.hover()<CR>', { desc = 'lsp: information' })
  vim.keymap.set('n', '<Leader>lj', '<Cmd>lua vim.diagnostic.goto_next()<CR>', { desc = 'lsp: next diagnostic' })
  vim.keymap.set('n', '<Leader>lk', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', { desc = 'lsp: prev diagnostic' })
  vim.keymap.set('n', '<Leader>ln', '<Cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'lsp: rename' })

  vim.keymap.set('n', '<Leader>lD', '<Cmd>Pick lsp scope="declaration"<CR>', { desc = 'lsp: declaration' })
  vim.keymap.set('n', '<Leader>ld', '<Cmd>Pick lsp scope="definition"<CR>', { desc = 'lsp: definition' })
  vim.keymap.set('n', '<Leader>ls', '<Cmd>Pick lsp scope="document_symbol"<CR>', { desc = 'lsp: doc symbols' })
  vim.keymap.set('n', '<Leader>li', '<Cmd>Pick lsp scope="implementation"<CR>', { desc = 'lsp: implementation' })
  vim.keymap.set('n', '<Leader>lr', '<Cmd>Pick lsp scope="references"<CR>', { desc = 'lsp: references' })
  vim.keymap.set('n', '<Leader>ly', '<Cmd>Pick lsp scope="type_definition"<CR>', { desc = 'lsp: type definition' })
  vim.keymap.set('n', '<Leader>lS', '<Cmd>Pick lsp scope="workspace_symbol"<CR>', { desc = 'lsp: workspace symbols' })

  vim.keymap.set({ 'n', 'x' }, '<Leader>lf', formatting_cmd, { desc = 'lsp: format' })

  local diagnostic_opts = {
    float = { border = 'double' },
    signs = {
      priority = 9999,
      severity = { min = 'WARN', max = 'ERROR' },
    },
    virtual_text = { severity = { min = 'ERROR', max = 'ERROR' } },
    update_in_insert = false,
  }

  vim.diagnostic.config(diagnostic_opts)

  local has_mini_clue = pcall(require, 'mini.clue')

  if has_mini_clue then
    vim.b.miniclue_config = Config.extend_local_opts(vim.b.miniclue_config, {
      clues = {
        { mode = 'n', keys = '<leader>l', desc = '+lsp' },
        { mode = 'x', keys = '<leader>l', desc = '+lsp' },
      },
    })
  end
end

--
-- m: map
--
vim.keymap.set('n', [[\h]], ':let v:hlsearch = 1 - v:hlsearch<CR>', { desc = 'Toggle hlsearch' })
vim.keymap.set('n', '<leader>mc', '<Cmd>lua MiniMap.close()<CR>', { desc = 'minimap: close' })
vim.keymap.set('n', '<leader>mf', '<Cmd>lua MiniMap.toggle_focus()<CR>', { desc = 'minimap: focus (toggle)' })
vim.keymap.set('n', '<leader>mo', '<Cmd>lua MiniMap.open()<CR>', { desc = 'minimap: open' })
vim.keymap.set('n', '<leader>mr', '<Cmd>lua MiniMap.refresh()<CR>', { desc = 'minimap: refresh' })
vim.keymap.set('n', '<leader>ms', '<Cmd>lua MiniMap.toggle_side()<CR>', { desc = 'minimap: side (toggle)' })
vim.keymap.set('n', '<leader>mt', '<Cmd>lua MiniMap.toggle()<CR>', { desc = 'minimap: toggle' })
vim.keymap.set('n', '<leader>xx', '<Cmd>lua Config.toggle_quickfix()<CR>', { desc = 'qf: toggle' })

for _, key in ipairs({ 'n', 'N', '*' }) do
  vim.keymap.set('n', key, key .. 'zv<Cmd>lua MiniMap.refresh({}, { lines = false, scrollbar = false })<CR>')
end

vim.keymap.set('n', '<leader>fo', function() MiniExtra.pickers.visit_paths() end, { desc = 'minvisits: oldfiles' })
