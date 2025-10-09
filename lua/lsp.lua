local util = require 'util.lsp'

local s = vim.diagnostic.severity
vim.diagnostic.config {
    update_in_insert = false,
    virtual_lines = false,
    ---@want?
    --- We rely on the BufWritePre (see below) autocmd to put the diagnostics of the
    --- current buffer in the qflist
    ---
    --- If for some reason we change or remove it, restore this section
    ---
    -- underline = { severity = { min = s.HINT, max = s.ERROR } },
    -- signs = { priority = 9999, severity = { min = s.WARN, max = s.ERROR } },
    -- virtual_text = { current_line = true, severity = { min = s.ERROR, max = s.ERROR } },
    underline = false,
    signs = false,
    virtual_text = false,
}

--- Creates a user command to start LSP servers
vim.api.nvim_create_user_command(
    'LspStart',
    function(info) util.lspstart(info) end,
    { nargs = '+', complete = util.complete_config }
)
--- Creates a user command to stop LSP servers
vim.api.nvim_create_user_command(
    'LspStop',
    function(info) util.lspstop(info) end,
    { nargs = '+', complete = util.complete_client }
)
--- Creates a user command to restart LSP clients
vim.api.nvim_create_user_command(
    'LspRestart',
    function(info) util.lsprestart(info) end,
    { nargs = '?', complete = util.complete_client }
)

--- Autoformats on buffer write
vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function(e)
        vim.lsp.buf.format { bufnr = e.buf }
        vim.diagnostic.setloclist {
            open = true,
            { severity = { min = s.WARN, max = s.ERROR } },
        }
    end,
})

--- Enables LSP servers on buffer read/new file
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
    once = true,
    callback = function()
        local files = vim.api.nvim_get_runtime_file('lsp/*.lua', true)
        local server_configs = vim.iter(files):map(util.filter_server):totable()
        vim.lsp.enable(server_configs)
    end,
})

--- Sets up keymaps and options when LSP attaches
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
        local set = vim.keymap.set
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client then return end
        local buf = e.buf

        vim.bo[e.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        set('n', 'E', function() vim.diagnostic.open_float() end, { buffer = buf })
        set('n', 'K', function() vim.lsp.buf.hover() end, { buffer = buf })
        set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = buf })
        set('n', 'ga', function() vim.lsp.buf.code_action() end, { buffer = buf })
        set('n', 'gn', function() vim.lsp.buf.rename() end, { buffer = buf })
        set('n', 'gd', function() vim.lsp.buf.definition { reuse_win = true } end, { buffer = buf })
        set('n', 'gD', function() vim.lsp.buf.declaration() end, { buffer = buf })
        set('n', 'gr', function() vim.lsp.buf.references() end, { buffer = buf, nowait = true })
        set('n', 'gi', function() vim.lsp.buf.implementation { reuse_win = true } end, { buffer = buf })
        set('n', 'gy', function() vim.lsp.buf.type_definition { reuse_win = true } end, { buffer = buf })
        set('n', 'ge', function() vim.diagnostic.setqflist { open = true } end, { buffer = buf })
        set('n', ']d', util.diagnostic_goto(true), { buffer = buf })
        set('n', '[d', util.diagnostic_goto(false), { buffer = buf })
        set('n', ']e', util.diagnostic_goto(true, 'ERROR'), { buffer = buf })
        set('n', '[e', util.diagnostic_goto(false, 'ERROR'), { buffer = buf })
        set('n', ']w', util.diagnostic_goto(true, 'WARN'), { buffer = buf })
        set('n', '[w', util.diagnostic_goto(false, 'WARN'), { buffer = buf })
    end,
})
