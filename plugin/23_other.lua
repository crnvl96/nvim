local function build_cargo(p)
  vim.notify('Building ' .. p.name, vim.log.levels.INFO)
  local cmd = { 'cargo', '+nightly', 'build', '--release' }
  local opts = { cwd = p.path }
  local obj = vim.system(cmd, opts):wait()
  if obj.code == 0 then
    vim.notify('Done!', vim.log.levels.INFO)
  else
    vim.notify('A Fail occurred!', vim.log.levels.ERROR)
  end
end

vim.cmd('colorscheme ham')

local cargo_hooks = { post_install = build_cargo, post_checkout = build_cargo }

MiniDeps.add({ source = 'tpope/vim-fugitive' })
MiniDeps.add({ source = 'Saghen/blink.cmp', hooks = cargo_hooks })
MiniDeps.add({ source = 'stevearc/conform.nvim' })
MiniDeps.add({ source = 'junegunn/fzf.vim' })

vim.g.autoformat = true
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set('n', '<Leader>f', '<Cmd>Files<CR>')
vim.keymap.set('n', '<Leader>g', '<Cmd>Rg<CR>')
vim.keymap.set('n', '<Leader>l', '<Cmd>BLines<CR>')

vim.cmd([[
let g:fzf_vim = {}
let g:fzf_vim.preview_window = []

function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
    copen
    cc
endfunction

let g:fzf_action = {
    \ 'ctrl-q': function('s:build_quickfix_list'),
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit'
    \ }

let g:fzf_layout = { 'window': { 'width': 0.45, 'height': 0.45 } }

let g:fzf_colors = { 
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'query':   ['fg', 'Normal'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment']
    \ }
]])

require('blink.cmp').setup({
  appearance = { nerd_font_variant = 'mono' },
  keymap = { preset = 'default', ['<C-n>'] = { 'show', 'select_next', 'fallback_to_mappings' } },
  cmdline = {
    enabled = true,
    keymap = { preset = 'cmdline' },
    completion = {
      list = { selection = { preselect = false } },
      menu = { auto_show = function() return vim.fn.getcmdtype() == ':' end },
      ghost_text = { enabled = true },
    },
  },
  completion = {
    list = { selection = { preselect = false, auto_insert = true } },
    documentation = { auto_show = true },
    menu = {
      scrollbar = false,
      draw = {
        columns = { { 'kind_icon' }, { 'label', 'label_description', 'source_name', gap = 1 } },
        components = {
          kind_icon = {
            text = function(ctx)
              if ctx.source_id == 'cmdline' then return end
              return ctx.kind_icon .. ctx.icon_gap
            end,
          },
          source_name = {
            text = function(ctx)
              if ctx.source_id == 'cmdline' then return end
              return ctx.source_name:sub(1, 4)
            end,
          },
        },
      },
    },
  },
})

require('conform').setup({
  notify_on_error = true,
  format_on_save = function()
    if not vim.g.autoformat then return nil end
    return { timeout_ms = 500, lsp_format = 'fallback' }
  end,
  formatters = { prettier = { require_cwd = true } },
  formatters_by_ft = {
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
    javascript = { 'prettier', name = 'dprint' },
    javascriptreact = { 'prettier', name = 'dprint' },
    typescript = { 'prettier', name = 'dprint' },
    typescriptreact = { 'prettier', name = 'dprint' },
    json = { name = 'dprint' },
    jsonc = { name = 'dprint' },
    lua = { 'stylua' },
    markdown = { name = 'dprint' },
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format', name = 'dprint' },
    rust = { lsp_format = 'prefer' },
    go = { lsp_format = 'prefer' },
    toml = { name = 'dprint' },
    yaml = { lsp_format = 'prefer' },
  },
})

vim.api.nvim_create_user_command('PluginToggleFormat', function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify(('%s formatting...'):format(vim.g.autoformat and 'Enabling' or 'Disabling'), vim.log.levels.INFO)
end, { nargs = 0 })

vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities(nil, true) })
