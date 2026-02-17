vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

require('mini.misc').setup()
MiniMisc.setup_auto_root()
MiniMisc.setup_restore_cursor()
MiniMisc.setup_termbg_sync()

require('mini.hues').setup({ background = '#002734', foreground = '#c0c8cc' })

require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()
MiniIcons.tweak_lsp_kind()

require('mini.extra').setup()
require('mini.visits').setup()
require('mini.align').setup()
require('mini.move').setup()
require('mini.splitjoin').setup()
require('mini.indentscope').setup()
require('mini.comment').setup()

require('mini.jump2d').setup({
  spotter = require('mini.jump2d').gen_spotter.pattern('[^%s%p]+'),
  labels = 'asdfghjkl;',
  view = {
    dim = true,
    n_steps_ahead = 2,
  },
})

vim.keymap.set({ 'n', 'x', 'o' }, 's', function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end)

require('mini.keymap').setup()
MiniKeymap.map_combo({ 'i', 'c', 'x', 's' }, 'jk', '<BS><BS><Esc>')
MiniKeymap.map_combo({ 'i', 'c', 'x', 's' }, 'kj', '<BS><BS><Esc>')
MiniKeymap.map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
MiniKeymap.map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')
MiniKeymap.map_combo({ 'n', 'i', 'x', 'c' }, '<Esc><Esc>', function() vim.cmd('nohlsearch') end)

require('mini.ai').setup({
  custom_textobjects = {
    g = MiniExtra.gen_ai_spec.buffer(),
    f = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
    c = require('mini.ai').gen_spec.treesitter({ a = '@comment.outer', i = '@comment.inner' }),
    o = require('mini.ai').gen_spec.treesitter({ a = '@conditional.outer', i = '@conditional.inner' }),
    l = require('mini.ai').gen_spec.treesitter({ a = '@loop.outer', i = '@loop.inner' }),
  },
  search_method = 'cover',
})

require('mini.files').setup({
  mappings = {
    go_in = '',
    go_in_plus = '<CR>',
    go_out = '',
    go_out_plus = '-',
  },
  windows = {
    max_number = 3,
    preview = true,
    width_focus = 50,
    width_nofocus = 20,
    width_preview = 80,
  },
})

local show_dotfiles = false
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(e)
    local buf = e.data.buf_id
    local filter_show = function() return true end
    local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, '.') end
    vim.keymap.set('n', 'g.', function()
      show_dotfiles = not show_dotfiles
      local new_filter = show_dotfiles and filter_show or filter_hide
      MiniFiles.refresh({ content = { filter = new_filter } })
    end, { buffer = buf, desc = 'Toggle dotfiles' })
  end,
})

local exp = function() MiniFiles.open(vim.api.nvim_buf_get_name(0), false) end
vim.keymap.set('n', '<Leader>ef', exp, { desc = 'Toggle file explorer' })

require('mini.pick').setup({
  window = {
    prompt_prefix = '  ',
  },
})

local cursor_based_display_opts = {
  window = {
    config = {
      relative = 'cursor',
      anchor = 'NW',
      row = 0,
      col = 0,
      width = 80,
      height = 20,
    },
  },
}

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(items, opts, on_choice)
  return MiniPick.ui_select(items, opts, on_choice, cursor_based_display_opts)
end

vim.keymap.set('n', '<Leader>ff', function() MiniPick.builtin.files() end, { desc = 'Find files' })
vim.keymap.set('n', '<Leader>fg', function() MiniPick.builtin.grep_live() end, { desc = 'Grep live' })
vim.keymap.set('n', '<Leader>fr', function() MiniPick.builtin.resume() end, { desc = 'Resume last picker' })
local bl = function() MiniExtra.pickers.buf_lines({ scope = 'current', preserve_order = true }) end
vim.keymap.set('n', '<Leader>fl', bl, { desc = 'Search on buffer lines' })
local qf = function() MiniExtra.pickers.list({ scope = 'quickfix' }) end
vim.keymap.set('n', '<Leader>fq', qf, { desc = 'Search on quickfix list' })
vim.keymap.set('n', '<Leader>fk', function() MiniExtra.pickers.keymaps() end, { desc = 'Search keymaps' })
vim.keymap.set('n', '<Leader>fH', function() MiniExtra.pickers.hl_groups() end, { desc = 'Search highlight groups' })
vim.keymap.set('n', '<Leader>fd', function() MiniExtra.pickers.diagnostic() end, { desc = 'Search diagnostics' })
vim.keymap.set('n', '<Leader>fc', function() MiniExtra.pickers.commands() end, { desc = 'Search commands' })
local help = function() MiniPick.builtin.help({ default_split = 'vertical' }) end
vim.keymap.set('n', '<Leader>fh', help, { desc = 'Search help files' })
local buffers = function() MiniPick.builtin.buffers({ include_current = false }, cursor_based_display_opts) end
vim.keymap.set('n', '<Leader>fb', buffers, { desc = 'Search buffers' })
vim.keymap.set('n', '<Leader>fm', function() MiniExtra.pickers.manpages() end, { desc = 'Search manpages' })
local oldfiles = function() MiniExtra.pickers.visit_paths({ preserve_order = true }, cursor_based_display_opts) end
vim.keymap.set('n', '<Leader>fo', oldfiles, { desc = 'Search on oldfiles' })

require('mini.clue').setup({
  triggers = {
    { mode = { 'n', 'x' }, keys = '<Leader>' },
    { mode = 'n', keys = '\\' },
    { mode = { 'n', 'x' }, keys = '[' },
    { mode = { 'n', 'x' }, keys = ']' },
    { mode = 'i', keys = '<C-x>' },
    { mode = { 'n', 'x' }, keys = 'g' },
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },
    { mode = 'n', keys = '<C-w>' },
    { mode = { 'n', 'x' }, keys = 'z' },
  },
  clues = {
    { mode = { 'n', 'x' }, keys = '<leader>f', desc = '+find' },
    { mode = { 'n', 'x' }, keys = '<leader>l', desc = '+lsp' },
    { mode = { 'n' }, keys = '<leader>e', desc = '+explorer' },
    require('mini.clue').gen_clues.builtin_completion(),
    require('mini.clue').gen_clues.g(),
    require('mini.clue').gen_clues.marks(),
    require('mini.clue').gen_clues.registers(),
    require('mini.clue').gen_clues.square_brackets(),
    require('mini.clue').gen_clues.windows(),
    require('mini.clue').gen_clues.z(),
  },
  window = {
    delay = 500,
    scroll_down = '<C-f>',
    scroll_up = '<C-b>',
    config = function(bufnr)
      local max_width = 0
      for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
        max_width = math.max(max_width, vim.fn.strchars(line))
      end
      max_width = max_width + 2
      return {
        width = math.min(70, max_width),
      }
    end,
  },
})
