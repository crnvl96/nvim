local nx = { 'n', 'x' }
local nt = { 'n', 't' }
local nix = { 'n', 'i', 'x' }

local function grep_blines()
  local file = vim.fn.getreg('%')
  local left = vim.api.nvim_replace_termcodes('<Left>', true, false, true)
  vim.api.nvim_feedkeys(":sil grep '' -g=" .. file .. string.rep(left, 5 + #file), 'n', false)
end

local function grep_blines_fzf()
  local opts = {
    winopts = {
      height = 0.6,
      width = 0.5,
      preview = { vertical = 'up:70%' },
      -- Disable Treesitter highlighting for the matches.
      treesitter = {
        enabled = false,
        fzf_colors = { ['fg'] = { 'fg', 'CursorLine' }, ['bg'] = { 'bg', 'Normal' } },
      },
    },
    fzf_opts = {
      ['--layout'] = 'reverse',
    },
  }

  -- Use grep when in normal mode and blines in visual mode since the former doesn't support
  -- searching inside visual selections.
  -- See https://github.com/ibhagwan/fzf-lua/issues/2051
  local mode = vim.api.nvim_get_mode().mode
  if vim.startswith(mode, 'n') then
    require('fzf-lua').lgrep_curbuf(opts)
  else
    require('fzf-lua').blines(opts)
  end
end

local function file_completion_fzf()
  require('fzf-lua').complete_path({
    winopts = {
      height = 0.4,
      width = 0.5,
      relative = 'cursor',
    },
  })
end

Config.set(nix, '<Esc>', '<Esc><Cmd>noh<CR><Esc>', { noremap = true, desc = 'Clear hlsearch on <Esc>' })

Config.set('x', '>', '>gv', { desc = 'Indent' })
Config.set('x', '<', '<gv', { desc = 'Deindent' })

Config.set(nt, '<C-Left>', '<Cmd>vertical resize -20<CR>', { noremap = true, desc = 'Decrease window width' })
Config.set(nt, '<C-Down>', '<Cmd>resize -5<CR>', { noremap = true, desc = 'Decrease window height' })
Config.set(nt, '<C-Up>', '<Cmd>resize +5<CR>', { noremap = true, desc = 'Increase window height' })
Config.set(nt, '<C-Right>', '<Cmd>vertical resize +20<CR>', { noremap = true, desc = 'Increase window width' })

Config.set('n', '<C-h>', '<C-w>h', { noremap = true, desc = 'Go to left window' })
Config.set('n', '<C-j>', '<C-w>j', { noremap = true, desc = 'Go to window below' })
Config.set('n', '<C-k>', '<C-w>k', { noremap = true, desc = 'Go to window above' })
Config.set('n', '<C-l>', '<C-w>l', { noremap = true, desc = 'Go to right window' })

Config.set('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>', { noremap = true, desc = 'Go to left window' })
Config.set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>', { noremap = true, desc = 'Go to window below' })
Config.set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>', { noremap = true, desc = 'Go to window above' })
Config.set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>', { noremap = true, desc = 'Go to right window' })

Config.set('n', 'Y', 'yg_', { noremap = true, desc = 'Yank till end of current line' })
Config.set('x', 'p', 'P', { noremap = true, desc = 'Paste in visual mode without overriding register' })
Config.set(nx, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true, desc = 'Go down one visual line' })
Config.set(nx, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true, desc = 'Go up one visual line' })

Config.set('n', 'E', '<Cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'Open Current Diagnostic' })
Config.set('n', 'grD', '<Cmd>lua vim.diagnostic.setqflist()<CR>', { desc = 'vim.diagnostic.setqflist()' })
Config.set('n', 'grd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'vim.lsp.buf.definition()' })

Config.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
Config.set('n', 'S', '<Plug>(leap-from-window)')

Config.set('n', '<C-d>', '<C-d>zz', { noremap = true, desc = 'Scroll down' })
Config.set('n', '<C-u>', '<C-u>zz', { noremap = true, desc = 'Scroll up' })

Config.set('c', '<C-a>', '<Home>', { noremap = true, desc = 'Move cursor to start of line' })
Config.set('c', '<C-b>', '<Left>', { noremap = true, desc = 'Move cursor to the left char' })
Config.set('c', '<C-e>', '<End>', { noremap = true, desc = 'Move cursor to end of line' })
Config.set('c', '<C-f>', '<Right>', { noremap = true, desc = 'Move cursor to the right char' })
Config.set('c', '<C-g>', '<C-c>', { noremap = true, desc = 'Quit/Exit from cmdline' })
Config.set('c', '<M-b>', '<C-Left>', { noremap = true, desc = 'Move cursor to right word' })
Config.set('c', '<M-f>', '<C-Right>', { noremap = true, desc = 'Move cursor to left word' })
Config.set('c', '<M-h>', '<C-f>', { noremap = true, desc = 'Access cmdline history' })

Config.set('n', '<leader>ef', '<Cmd>Oil<CR>', { desc = 'File explorer' })

Config.set('n', '<Leader>uC', '<Cmd>setlocal cursorcolumn! cursorcolumn?<CR>', { desc = "Toggle 'cursorcolumn'" })
Config.set('n', '<Leader>uF', '<Cmd>lua print("No formatter configured for this ft")<CR>', { desc = 'Format project' })
Config.set('n', '<Leader>uc', '<Cmd>setlocal cursorline! cursorline?<CR>', { desc = "Toggle 'cursorline'" })
Config.set('n', '<Leader>ud', '<Cmd>lua print(M.toggle_diagnostic())<CR>', { desc = 'Toggle diagnostic' })
Config.set('n', '<Leader>uf', '<Cmd>lua print("No formatter configured for this ft")<CR>', { desc = 'Format file' })
Config.set('n', '<Leader>ui', '<Cmd>setlocal ignorecase! ignorecase?<CR>', { desc = "Toggle 'ignorecase'" })
Config.set('n', '<Leader>ul', '<Cmd>setlocal list! list?<CR>', { desc = "Toggle 'list'" })
Config.set('n', '<Leader>un', '<Cmd>setlocal number! number?<CR>', { desc = "Toggle 'number'" })
Config.set('n', '<Leader>ur', '<Cmd>setlocal relativenumber! relativenumber?<CR>', { desc = "Toggle 'relativenumber'" })
Config.set('n', '<Leader>us', '<Cmd>setlocal spell! spell?<CR>', { desc = "Toggle 'spell'" })
Config.set('n', '<Leader>uw', '<Cmd>setlocal wrap! wrap?<CR>', { desc = "Toggle 'wrap'" })

Config.set('n', '<leader>ff', ':find<space>', { desc = 'Files' })
Config.set('n', '<leader>fg', ":sil<space>grep<space>''<left>", { desc = 'Grep' })
Config.set('n', '<leader>fh', ':help<space>', { desc = 'Help' })
Config.set('n', '<leader>fl', grep_blines, { desc = 'Grep buffer' })

Config.set('i', '<C-x><C-f>', file_completion_fzf, { desc = 'Fuzzy complete path' })
Config.set('n', '<leader>fH', '<cmd>FzfLua highlights<cr>', { desc = 'Highlights' })
Config.set('n', '<leader>fb', '<cmd>FzfLua buffers<cr>', { desc = 'Buffers' })
Config.set('n', '<leader>fd', '<cmd>FzfLua lsp_document_diagnostics<cr>', { desc = 'Document diagnostics' })
Config.set('n', '<leader>fD', '<cmd>FzfLua lsp_workspace_diagnostics<cr>', { desc = 'Workspace diagnostics' })
Config.set('n', '<leader>ff', '<cmd>FzfLua files<cr>', { desc = 'Files [fzf]' })
Config.set('n', '<leader>fg', '<cmd>FzfLua live_grep<cr>', { desc = 'Grep [fzf]' })
Config.set('n', '<leader>fh', '<cmd>FzfLua help_tags<cr>', { desc = 'Help [fzf]' })
Config.set('n', '<leader>fo', '<cmd>FzfLua oldfiles<cr>', { desc = 'Recently opened files' })
Config.set('n', '<leader>fr', '<cmd>FzfLua resume<cr>', { desc = 'Resume last fzf command' })
Config.set('x', '<leader>fg', '<cmd>FzfLua grep_visual<cr>', { desc = 'Grep [fzf]' })
Config.set({ 'n', 'x' }, '<Leader>fl', grep_blines_fzf, { desc = 'Grep buffer [fzf]' })

Config.set('n', '<leader>lr', '<cmd>FzfLua lsp_references<cr>', { desc = 'LSP references' })
Config.set('n', '<leader>ld', '<cmd>FzfLua lsp_definitions<cr>', { desc = 'LSP definitions' })
Config.set('n', '<leader>lt', '<cmd>FzfLua lsp_typedefs<cr>', { desc = 'LSP typedefs' })
Config.set('n', '<leader>li', '<cmd>FzfLua lsp_implementations<cr>', { desc = 'LSP implementations' })
Config.set('n', '<leader>lO', '<cmd>FzfLua lsp_document_symbols<cr>', { desc = 'LSP document symbols' })
Config.set('n', '<leader>la', '<cmd>FzfLua lsp_code_actions<cr>', { desc = 'LSP code actions' })

require('mini.clue').setup({
  triggers = {
    { mode = { 'n', 'x' }, keys = '<Leader>' },
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
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
    { mode = 'n', keys = '<leader>l', desc = '+lsp' },
    { mode = 'n', keys = '<leader>u', desc = '+toggle' },
    require('mini.clue').gen_clues.square_brackets(),
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
