local U = require('utils')

local minipath = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
local __MiniPick_State = {}
local __MiniPickNS = vim.api.nvim_create_namespace('MiniPick FFFiles Picker')

--- Open MiniFiles at the current directory
---@return nil
local function open_file_explorer()
  local bufname = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.fnamemodify(bufname, ':p')
  if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
end

vim.api.nvim_set_hl(0, 'FFFileScore', { link = 'Identifier' })

--- Find items using FFF source
---@param query string Query used in search
---@return nil
local function find(query)
  local file_picker = require('fff.file_picker')

  query = query or ''
  local fff_result = file_picker.search_files(query, 100, 4, __MiniPick_State.current_file_cache, false)

  local items = {}
  for _, fff_item in ipairs(fff_result) do
    local item = {
      text = fff_item.relative_path,
      path = fff_item.path,
      score = fff_item.total_frecency_score,
    }
    table.insert(items, item)
  end

  return items
end

--- Render the file search results
---@param buf_id integer Buffer id
---@param items table Found items on search
---@return nil
local function show(buf_id, items)
  local icon_data = {}

  -- Show items
  local items_to_show = {}
  for i, item in ipairs(items) do
    local icon, hl, _ = MiniIcons.get('file', item.text)
    icon_data[i] = { icon = icon, hl = hl }
    items_to_show[i] = string.format('%s %s [%d]', icon, item.text, item.score)
  end

  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, items_to_show)
  vim.api.nvim_buf_clear_namespace(buf_id, __MiniPickNS, 0, -1)

  local icon_extmark_opts = { hl_mode = 'combine', priority = 200 }
  for i, item in ipairs(items) do
    -- Highlight Icons
    icon_extmark_opts.hl_group = icon_data[i].hl
    icon_extmark_opts.end_row, icon_extmark_opts.end_col = i - 1, 1
    vim.api.nvim_buf_set_extmark(buf_id, __MiniPickNS, i - 1, 0, icon_extmark_opts)

    -- Highlight score
    local col = #items_to_show[i] - #tostring(item.score) - 3
    icon_extmark_opts.hl_group = 'FFFileScore'
    icon_extmark_opts.end_row, icon_extmark_opts.end_col = i - 1, #items_to_show[i]
    vim.api.nvim_buf_set_extmark(buf_id, __MiniPickNS, i - 1, col, icon_extmark_opts)
  end
end

--- Execute the picker
---@return nil
local function run()
  -- Setup fff.nvim
  local file_picker = require('fff.file_picker')
  if not file_picker.is_initialized() then
    local setup_success = file_picker.setup()
    if not setup_success then
      vim.notify('Could not setup fff.nvim', vim.log.levels.ERROR)
      return
    end
  end

  -- Cache current file to deprioritize in fff.nvim
  if not __MiniPick_State.current_file_cache then
    local current_buf = vim.api.nvim_get_current_buf()
    if current_buf and vim.api.nvim_buf_is_valid(current_buf) then
      local current_file = vim.api.nvim_buf_get_name(current_buf)
      if current_file ~= '' and vim.fn.filereadable(current_file) == 1 then
        local relative_path = vim.fs.relpath(vim.uv.cwd() --[[@as string]], current_file)
        __MiniPick_State.current_file_cache = relative_path --[[@as string]]
      else
        __MiniPick_State.current_file_cache = nil
      end
    end
  end

  -- Start picker
  MiniPick.start({
    source = {
      name = 'FFFiles',
      items = find,
      match = function(_, _, query)
        local items = find(table.concat(query))
        MiniPick.set_picker_items(items, { do_match = false })
      end,
      show = show,
    },
  })

  __MiniPick_State.current_file_cache = nil -- Reset cache
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
  :add_transparency({
    float = true,
    statuscolumn = true,
    statusline = true,
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
}) do
  U.override_highlight(hl, { bg = 'none' })
end

require('mini.notify').setup()
require('mini.doc').setup()
require('mini.icons').setup()
require('mini.misc').setup()
require('mini.diff').setup()
require('mini.git').setup()
require('mini.extra').setup()
require('mini.pick').setup()
require('mini.keymap').setup()

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

require('mini.keymap').map_multistep('i', '<C-n>', { 'blink_next', 'pmenu_next' })
require('mini.keymap').map_multistep('i', '<C-p>', { 'blink_prev', 'pmenu_prev' })
require('mini.keymap').map_multistep('i', '<Tab>', { 'blink_next', 'pmenu_next' })
require('mini.keymap').map_multistep('i', '<S-Tab>', { 'blink_prev', 'pmenu_prev' })
require('mini.keymap').map_multistep('i', '<CR>', { 'blink_accept', 'pmenu_accept' })
require('mini.keymap').map_combo({ 'i', 'c', 'x', 's' }, 'jk', '<BS><BS><Esc>')
require('mini.keymap').map_combo({ 'i', 'c', 'x', 's' }, 'kj', '<BS><BS><Esc>')
-- require('mini.keymap').map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
-- require('mini.keymap').map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')

MiniPick.registry.fffiles = run

U.nmap('-', open_file_explorer, 'Open file explorer')
U.nmap('<Leader>f', MiniPick.registry.fffiles, 'Pick files')
U.nmap('<Leader>g', MiniPick.builtin.grep_live, 'Live grep')
U.nmap('<Leader>l', '<Cmd>Pick buf_lines scope="current"<CR>', 'Buf lines')
