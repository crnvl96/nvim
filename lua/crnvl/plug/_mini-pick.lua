require('mini.pick').setup({
  window = {
    prompt_prefix = ' ',
  },
})

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(items, opts, on_choice)
  return MiniPick.ui_select(items, opts, on_choice, {
    window = {
      config = {
        relative = 'cursor',
        anchor = 'NW',
        row = 0,
        col = 0,
        width = 80,
        height = 15,
      },
    },
  })
end

vim.keymap.set('n', '<Leader>fb', '<Cmd>Pick buffers<CR>', { desc = 'Buffers' })
vim.keymap.set('n', '<Leader>fc', '<Cmd>Pick commands<CR>', { desc = 'Commands' })
vim.keymap.set('n', '<Leader>fd', '<Cmd>Pick diagnostic<CR>', { desc = 'Diagnostics' })
vim.keymap.set('n', '<Leader>fe', '<Cmd>Pick explorer<CR>', { desc = 'Explorer' })
vim.keymap.set('n', '<Leader>ff', '<Cmd>Pick files<CR>', { desc = 'Find Files' })
vim.keymap.set('n', '<Leader>fg', '<Cmd>Pick grep_live<CR>', { desc = 'Grep live' })
vim.keymap.set(
  'n',
  '<Leader>fh',
  "<Cmd>Pick help default_split='vertical'<CR>",
  { desc = 'Help files' }
)
vim.keymap.set('n', '<Leader>fH', '<Cmd>Pick hl_groups<CR>', { desc = 'Highlights' })
vim.keymap.set('n', '<Leader>fk', '<Cmd>Pick keymaps<CR>', { desc = 'Keymaps' })
vim.keymap.set(
  'n',
  '<Leader>fl',
  "<Cmd>Pick buf_lines scope='current' preserve_order=true<CR>",
  { desc = 'Lines' }
)
vim.keymap.set(
  'n',
  '<Leader>fm',
  '<Cmd>Pick manpages<CR>',
  { desc = 'Search manpages' }
)
vim.keymap.set(
  'n',
  '<Leader>fo',
  '<Cmd>Pick visit_paths preserve_order=true<CR>',
  { desc = 'Oldfiles' }
)
vim.keymap.set(
  'n',
  '<Leader>fq',
  "<Cmd>Pick list scope='quickfix'<CR>",
  { desc = 'Quickfix' }
)
vim.keymap.set(
  'n',
  '<Leader>fr',
  '<Cmd>Pick resume<CR>',
  { desc = 'Resume last picker' }
)
vim.keymap.set('n', '<Leader>fu', '<Cmd>Pick git_hunks<CR>', { desc = 'Git hunks' })
vim.keymap.set(
  'n',
  '<Leader>fU',
  '<Cmd>Pick git_hunks scope="staged"<CR>',
  { desc = 'Git hunks' }
)
vim.keymap.set(
  'n',
  '<Leader>lD',
  "<Cmd>Pick lsp scope='declaration'<CR>",
  { desc = 'Declarations' }
)
vim.keymap.set(
  'n',
  '<Leader>lS',
  "<Cmd>Pick lsp scope='workspace_symbol_live'<CR>",
  { desc = 'Workspace symbols' }
)
vim.keymap.set(
  'n',
  '<Leader>ld',
  "<Cmd>Pick lsp scope='definition'<CR>",
  { desc = 'Definitions' }
)
vim.keymap.set(
  'n',
  '<Leader>li',
  "<Cmd>Pick lsp scope='implementation'<CR>",
  { desc = 'Implementations' }
)
vim.keymap.set(
  'n',
  '<Leader>lr',
  "<Cmd>Pick lsp scope='references'<CR>",
  { desc = 'References' }
)
vim.keymap.set(
  'n',
  '<Leader>ls',
  "<Cmd>Pick lsp scope='document_symbol'<CR>",
  { desc = 'Document Symbols' }
)
vim.keymap.set(
  'n',
  '<Leader>lt',
  "<Cmd>Pick lsp scope='type_definition'<CR>",
  { desc = 'Typedefs' }
)
