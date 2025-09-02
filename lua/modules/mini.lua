local U = require('utils')

local minipath = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'

--- Open MiniFiles at the current directory
---@return nil
local function open_file_explorer()
  local bufname = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.fnamemodify(bufname, ':p')
  if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
end

if not vim.loop.fs_stat(minipath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    minipath,
  })
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup()

MiniDeps.add({ name = 'mini.nvim' })

local hues, colors = require('mini.hues'), require('mini.colors')
hues.apply_palette(hues.make_palette({
  background = vim.o.background == 'dark' and '#212223' or '#e1e2e3',
  foreground = vim.o.background == 'dark' and '#d5d4d3' or '#2f2e2d',
  saturation = vim.o.background == 'dark' and 'lowmedium' or 'mediumhigh',
  accent = 'bg',
}))

colors
  .get_colorscheme()
  :add_terminal_colors()
  :add_cterm_attributes()
  :add_transparency({
    float = true,
    statuscolumn = true,
    statusline = false,
    tabline = true,
    winbar = true,
  })
  :apply()

for _, hl in ipairs({
  'MiniFilesBorder',
  'MiniFilesBorderModified',
  'MiniFilesDirectory',
  'MiniFilesFile',
  'MiniFilesNormal',
  'MiniFilesTitle',
  'MiniFilesTitleFocused',
  'MiniClueBorder',
  'MiniClueDescGroup',
  'MiniClueDescSingle',
  'MiniClueNextKey',
  'MiniClueNextKeyWithPostkeys',
  'MiniClueSeparator',
  'MiniClueTitle',
  'MiniPickBorder',
  'MiniPickBorderBusy',
  'MiniPickBorderText',
  'MiniPickCursor',
  'MiniPickIconDirectory',
  'MiniPickIconFile',
  'MiniPickHeader',
  'MiniPickNormal',
  'MiniPickPreviewLine',
  'MiniPickPreviewRegion',
  'MiniPickPrompt',
  'MiniPickPromptCaret',
  'MiniPickPromptPrefix',
  'MiniStatuslineFilename',
  'MiniStatuslineFileinfo',
  'MiniStatuslineInactive',
}) do
  U.override_highlight(hl, { bg = 'none' })
end

require('mini.notify').setup({
  content = {
    sort = function(notif_arr)
      return MiniNotify.default_sort(vim.tbl_filter(function(notif)
        if not (notif.data.source == 'lsp_progress' and notif.data.client_name == 'lua_ls') then return true end
        -- Filter out some LSP progress notifications from 'lua_ls'
        return notif.msg:find('Diagnosing') == nil and notif.msg:find('semantic tokens') == nil
      end, notif_arr))
    end,
  },
})

require('mini.doc').setup()
require('mini.icons').setup()
require('mini.misc').setup()
require('mini.diff').setup()
require('mini.extra').setup()
require('mini.statusline').setup()

require('mini.ai').setup({
  custom_textobjects = {
    B = MiniExtra.gen_ai_spec.buffer(),
    F = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
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

require('mini.pick').setup({
  options = {
    use_cache = true,
  },
  window = {
    prompt_caret = '▏',
    prompt_prefix = '  ',
  },
})
require('mini.keymap').setup()
require('mini.align').setup()

require('mini.files').setup({
  mappings = {
    show_help = '?',
    go_in = '',
    go_out = '',
    go_in_plus = '<CR>',
    go_out_plus = '-',
  },
})

vim.notify = require('mini.notify').make_notify()
vim.ui.select = require('mini.pick').ui_select

vim.schedule(
  --- Ensure that the keymap clues are constructed lastly (So that all keymaps have already been set.
  ---@return nil
  function()
    require('mini.clue').setup({
      triggers = {
        -- Builtins.
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = '`' },
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },
        { mode = 'n', keys = '<C-w>' },
        { mode = 'i', keys = '<C-x>' },
        { mode = 'n', keys = 'z' },
        -- Leader triggers.
        { mode = 'n', keys = '<leader>' },
        { mode = 'x', keys = '<leader>' },
        -- Moving between stuff.
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },
      },
      clues = {
        -- Leader/movement groups.
        { mode = 'n', keys = '<leader>c', desc = '+Codecompanion' },
        { mode = 'x', keys = '<leader>c', desc = '+Codecompanion' },
        { mode = 'n', keys = '[', desc = '+prev' },
        { mode = 'n', keys = ']', desc = '+next' },
        -- Builtins.
        require('mini.clue').gen_clues.builtin_completion(),
        require('mini.clue').gen_clues.g(),
        require('mini.clue').gen_clues.marks(),
        require('mini.clue').gen_clues.registers(),
        require('mini.clue').gen_clues.windows(),
        require('mini.clue').gen_clues.z(),
      },
      window = {
        delay = 500,
        scroll_down = '<C-f>',
        scroll_up = '<C-b>',
        config = {
          width = 'auto',
        },
      },
    })
  end
)

require('mini.keymap').map_multistep({ 'i', 'c' }, '<C-n>', { 'blink_next', 'pmenu_next' })
require('mini.keymap').map_multistep({ 'i', 'c' }, '<C-p>', { 'blink_prev', 'pmenu_prev' })
require('mini.keymap').map_multistep({ 'i', 'c' }, '<Tab>', { 'blink_next', 'pmenu_next' })
require('mini.keymap').map_multistep({ 'i', 'c' }, '<S-Tab>', { 'blink_prev', 'pmenu_prev' })
require('mini.keymap').map_multistep({ 'i', 'c' }, '<CR>', { 'blink_accept', 'pmenu_accept' })
require('mini.keymap').map_combo({ 'i', 'c', 'x', 's' }, 'jk', '<BS><BS><Esc>')
require('mini.keymap').map_combo({ 'i', 'c', 'x', 's' }, 'kj', '<BS><BS><Esc>')
require('mini.keymap').map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
require('mini.keymap').map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')

U.nmap('-', open_file_explorer, 'Open file explorer')
U.nmap('<Leader>f', MiniPick.builtin.files, 'Pick files')
U.nmap('<Leader>g', MiniPick.builtin.grep_live, 'Live grep')
U.nmap('<Leader>l', '<Cmd>Pick buf_lines scope="current"<CR>', 'Buf lines')
