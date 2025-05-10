local default_nodejs = vim.env.HOME .. '/.local/share/mise/installs/node/22.14.0/bin/'

vim.g.node_host_prog = default_nodejs .. 'node'
vim.env.PATH = default_nodejs .. ':' .. vim.env.PATH

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

vim.o.guicursor = ''
vim.o.scrolloff = 8
vim.o.wrap = false
vim.o.ignorecase = true
vim.o.wildignorecase = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.signcolumn = 'yes'
vim.o.virtualedit = 'block'
vim.o.winborder = 'single'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.undofile = true
vim.o.writebackup = false

vim.opt.diffopt = {
  'internal',
  'filler',
  'closeoff',
  'context:4',
  'algorithm:histogram',
  'linematch:60',
  'indent-heuristic',
  'inline:char', -- also accept inline:word
}

vim.keymap.set('x', 'p', 'P')
vim.keymap.set('x', 'Y', 'yg_')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>p', '"+p')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>P', '"+P')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>y', '"+y')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>Y', '"+yg_')
vim.keymap.set({ 'n', 'x', 'o', 'i' }, '<C-s>', '<Esc><Cmd>nohl<CR><Cmd>w<CR><Esc>')
vim.keymap.set('n', 'gc', ':<C-U>let @+ = expand(\'%:.\')<CR>')
vim.keymap.set('n', 'gp', '`[v`]')
vim.keymap.set({ 'n', 'x', 'i', 's' }, '<Esc>', '<Cmd>noh<CR><Esc>')
vim.keymap.set({ 'n', 'x' }, 'j', 'v:count == 0 ? \'gj\' : \'j\'', { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', 'v:count == 0 ? \'gk\' : \'k\'', { expr = true })
vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')
vim.keymap.set('n', 'gQ', 'mzgggqG`z<cmd>delmarks z<cr>zz')

vim.keymap.set(
  { 'n', 't' },
  '<C-t>',
  (function()
    local buf, win = nil, nil
    local was_insert = true
    local cfg = function()
      return {
        relative = 'editor',
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        row = math.floor(vim.o.lines * 0.1),
        col = math.floor(vim.o.columns * 0.1),
        style = 'minimal',
        border = 'rounded',
      }
    end
    return function()
      buf = (buf and vim.api.nvim_buf_is_valid(buf)) and buf or nil
      win = (win and vim.api.nvim_win_is_valid(win)) and win or nil
      if not buf and not win then
        vim.cmd 'split | terminal'
        buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
        win = vim.api.nvim_open_win(buf, true, cfg())
      elseif not win and buf then
        win = vim.api.nvim_open_win(buf, true, cfg())
      elseif win then
        was_insert = vim.api.nvim_get_mode().mode == 't'
        return vim.api.nvim_win_close(win, true)
      end
      if was_insert then vim.cmd 'startinsert' end
    end
  end)()
)

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('crnvl96-restore-cursor', {}),
  callback = function(e)
    pcall(
      vim.api.nvim_win_set_cursor,
      vim.fn.bufwinid(e.buf),
      vim.api.nvim_buf_get_mark(e.buf, [["]])
    )
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('crnvl96-big-file', { clear = true }),
  pattern = 'bigfile',
  callback = function(args)
    vim.schedule(
      function() vim.bo[args.buf].syntax = vim.filetype.match { buf = args.buf } or '' end
    )
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-yank-hl', { clear = true }),
  callback = function() vim.hl.on_yank { higroup = 'Visual', priority = 250 } end,
})
