require 'opts'
require 'keymaps'
require 'autocmds'

vim.pack.add {
    { src = 'https://github.com/nvim-mini/mini.nvim' },
    { src = 'https://github.com/stevearc/conform.nvim' },
    { src = 'https://github.com/folke/snacks.nvim' },
}

vim.cmd.colorscheme 'minispring'
require('mini.colors').setup()
MiniColors.get_colorscheme():add_transparency({ float = true }):apply()

require('mini.icons').setup()
require('mini.extra').setup()
require('mini.misc').setup()
require('mini.align').setup()
require('mini.splitjoin').setup()

local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
local process_items = function(items, base) return MiniCompletion.default_process_items(items, base, process_items_opts) end
require('mini.completion').setup {
    lsp_completion = { source_func = 'omnifunc', auto_setup = false, process_items = process_items },
}
if vim.fn.has 'nvim-0.11' == 1 then vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() }) end

require('mini.files').setup { windows = { preview = true } }
vim.keymap.set('n', '-', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>')

require('mini.pick').setup()
vim.keymap.set('n', '<Leader>f', '<Cmd>Pick files<CR>', { desc = 'Find files' })
vim.keymap.set('n', '<Leader>g', '<Cmd>Pick grep_live<CR>', { desc = 'Grep' })
vim.keymap.set('n', '<Leader>b', '<Cmd>Pick buffers include_current=false<CR>', { desc = 'Buffers' })
vim.keymap.set('n', '<Leader>l', "<Cmd>Pick buf_lines scope='current'<CR>", { desc = 'Lines' })

require('snacks').setup {
    scratch = {
        name = 'Notes',
        ft = function() return 'markdown' end,
        filekey = { branch = false },
        win = { style = 'scratch' },
    },
    styles = {
        lazygit = { position = 'float', height = 0.9, width = 0.9, border = 'double' },
        scratch = { position = 'float', height = 0.9, width = 0.9 },
        terminal = {
            position = 'float',
            border = 'double',
            height = 0.9,
            width = 0.9,
            keys = {
                term_normal = { '<C-t>', '<C-\\><C-n><Cmd>close<CR>', mode = 't' },
            },
        },
    },
}

vim.keymap.set('n', '<Leader>.', function() Snacks.scratch() end, { desc = 'Scratch' })
vim.keymap.set('n', '<Leader><Space>', function() Snacks.lazygit() end, { desc = 'Toggle Lazygit' })
vim.keymap.set('n', '<C-t>', function() Snacks.terminal() end)

vim.g.autoformat = true
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require('conform').setup {
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
}

local function fmt() require('conform').format { bufnr = vim.api.nvim_get_current_buf() } end
vim.api.nvim_create_user_command('Fmt', fmt, { nargs = 0 })
vim.api.nvim_create_user_command('ToggleFmt', function()
    vim.g.autoformat = not vim.g.autoformat
    local suffix = vim.g.autoformat and 'Enabling' or 'Disabling'
    vim.notify(('%s formatting...'):format(suffix), vim.log.levels.INFO)
end, { nargs = 0 })

vim.keymap.set('n', '<Leader>x', function()
    local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
    if not success and err then vim.notify(err, vim.log.levels.ERROR) end
end, { desc = 'Toggle Quickfix List' })

require('mini.clue').setup {
    triggers = {
        { mode = 'n', keys = '<leader>' },
        { mode = 'x', keys = '<leader>' },
    },
    window = { delay = 500 },
}
