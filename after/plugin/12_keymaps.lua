local set = vim.keymap.set

local function s(lhs, rhs, opts, mode)
  lhs = '<Leader>' .. lhs
  rhs = '<Cmd>' .. rhs .. '<CR>'
  mode = mode or 'n'
  set(mode, lhs, rhs, type(opts) == 'string' and { desc = opts } or opts)
end

set('n', '-', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>')

s('bb', 'b#', 'buffer: go to last')
s('bd', 'bd', 'buffer: delete current')

s('ch', 'lua MiniNotify.show_history()', 'mini.notify: show notification history')

s('dB', 'lua require("dap").clear_breakpoints()', 'dap: clear all breakpoints')
s('db', 'lua require("dap").toggle_breakpoint()', 'dap: toggle breakpoint')
s('dC', 'lua require("dap").run_to_cursor()', 'dap: run to cursor')
s('dc', 'lua require("dap").continue()', 'dap: continue execution')
s('de', 'lua require("dap.ui.widgets").hover()', 'dap: hover (eval)')
s('dR', 'lua require("dap.repl").toggle({}, "belowright split")', 'dap: repl')
s('ds', 'lua require("dap.ui.widgets").sidebar(require("dap.ui.widgets").scopes, {}, "vsplit").toggle()', 'dap: scopes')
s('dT', 'lua require("dap").terminate()', 'dap: terminate session')

s('f=', 'Pick spellsuggest', 'minipick: spellsuggest')
s('f:', 'Pick history scope=":"', 'minipick: ":" history')
s('f/', 'Pick history scope="/"', 'minipick: "/" history')

s('fb', 'Pick buffers', 'minipick: buffers')
s('ff', 'Pick files', 'minipick: files')
s('fg', 'Pick multigrep', 'minipick: multigrep')
s('fh', 'Pick help', 'minipick: help tags')
s('fH', 'Pick git_hunks', 'minipick: git hunks')
s('fk', 'Pick keymaps', 'minipick: keymaps')
s('fl', 'Pick buf_lines scope="current" preserve_order="true"', 'minipick: lines (current)')
s('fo', 'Pick visit_paths preserve_order=true', 'minipick: visit paths (cwd)')
s('fr', 'Pick resume', 'minipick: resume')
s('fX', 'Pick diagnostic scope="all"', 'minipick: diagnostic workspace')
s('fx', 'Pick diagnostic scope="current"', 'minipick: diagnostic buffer')

s('ga', 'Git commit --amend', 'minigit: amend last commit')
s('gc', 'Git commit', 'minigit: commit')
s('gD', 'Git diff --cached', 'minigit: show diff of added files')
s('gd', 'Git diff', 'minigit: diff')
s('gh', 'Pick git_hunks', 'minigit: git hunks')
s('gl', 'Git log --pretty=format:\\%h\\ \\%as\\ │\\ \\%s --topo-order --follow -- %', 'minigit: log buffer')
s('gL', 'Git log --pretty=format:\\%h\\ \\%as\\ │\\ \\%s --topo-order -256', 'minigit: log')
s('go', 'lua MiniDiff.toggle_overlay()', 'minidiff: toggle diff overlay')
s('gs', 'Git', 'minigit: status')
s('gx', 'lua vim.fn.setqflist(MiniDiff.export("qf"))', 'minidiff: setqflist')
-- s('gs', 'lua MiniGit.show_at_cursor()', 'minigit: show at cursor')
-- s('gs', 'lua MiniGit.show_at_cursor()', 'minigit: show at cursor', 'x')

s('ia', 'CodeCompanionChat Add', 'codecompanion: add to chat buffer', 'x')
s('ic', 'CodeCompanionChat Toggle', 'codecompanion: toggle chat buffer')
s('ic', 'CodeCompanionChat Toggle', 'codecompanion: toggle chat buffer', 'x')
s('ii', 'CodeCompanionActions', 'codecompanion: show actions')
s('ii', 'CodeCompanionActions', 'codecompanion: show actions', 'x')

function Config.on_attach_maps(bufnr)
  local function ls(lhs, rhs, desc, mode)
    lhs = '<Leader>' .. lhs
    rhs = '<Cmd>' .. rhs .. '<CR>'
    mode = mode or 'n'
    set(mode, lhs, rhs, { desc = desc, buffer = bufnr })
  end

  ls('la', 'lua vim.lsp.buf.code_action()', 'lsp: code action')
  ls('lc', 'Pick lsp scope="declaration"', 'lsp: declaration')
  ls('ld', 'Pick lsp scope="definition"', 'lsp: definition')
  ls('le', 'lua vim.lsp.buf.hover({border="single"})', 'lsp: hover on cursor')
  ls('lh', 'lua vim.lsp.buf.signature_help({border="single"})', 'lsp: arguments popup')
  ls('li', 'Pick lsp scope="implementation"', 'lsp: implementation')
  ls('lj', 'lua vim.diagnostic.goto_next()', 'lsp: next diagnostic')
  ls('lk', 'lua vim.diagnostic.goto_prev()', 'lsp: prev diagnostic')
  ls('ll', 'lua vim.diagnostic.open_float({boder="single"})', 'lsp: diagnostics popup')
  ls('ln', 'lua vim.lsp.buf.rename()', 'lsp: rename symbol under cursor')
  ls('lr', 'Pick lsp scope="references"', 'lsp: references')
  ls('ls', 'Pick lsp scope="document_symbol"', 'lsp: doc symbols')
  ls('lw', 'Pick lsp scope="workspace_symbol"', 'lsp: workspace symbols')
  ls('lx', 'lua vim.lsp.diagnostic.setqflist()', 'lsp: populate qf list with diagnocsits')
  ls('ly', 'Pick lsp scope="type_definition"', 'lsp: type definition')
end

s('xx', 'lua Config.toggle_quickfix()', 'quickfix list: toggle')
