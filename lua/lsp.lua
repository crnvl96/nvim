local util = require 'util.lsp'

vim.diagnostic.config {
    update_in_insert = false,
    virtual_lines = false,
    ---@note
    --- We rely on a BufWritePre autocmd to put the diagnostics of the
    --- current buffer in the qflist
    ---
    --- If for some reason we change or remove it, restore this section
    ---
    --- ```lua
    --- signs = { priority = 9999, severity = { min = s.WARN, max = s.ERROR } },
    --- virtual_text = { current_line = true, severity = { min = s.ERROR, max = s.ERROR } },
    --- ```
    underline = {
        severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
        },
    },
    signs = false,
    virtual_text = false,
}

--- Creates a user command to start LSP servers
vim.api.nvim_create_user_command(
    'LspEnable',
    function(info) util.lspstart(info) end,
    { nargs = '+', complete = util.complete_config }
)
--- Creates a user command to stop LSP servers
vim.api.nvim_create_user_command(
    'LspDisable',
    function(info) util.lspstop(info) end,
    { nargs = '+', complete = util.complete_client }
)
--- Creates a user command to restart LSP clients
vim.api.nvim_create_user_command(
    'LspRestart',
    function(info) util.lsprestart(info) end,
    { nargs = '?', complete = util.complete_client }
)

---@note
--- We're currently using conform.nvim to handle formatting.
--- If removed, reactivate this code
---
--- Autoformats on buffer write
-- vim.api.nvim_create_autocmd('BufWritePre', {
--     callback = function(_e)
--         vim.lsp.buf.format { bufnr = e.buf }
--
--         -- Since virtual_text diagnostics are a bit too much, we enable an auto
--         -- fill of the location list on every buffer write trigger.
--         -- This way, we can be aware of diagnostics of the current buffer we're
--         -- in without pollluting the screen too much
--         vim.diagnostic.setloclist {
--             open = true,
--             severity = { min = s.WARN, max = s.ERROR },
--             format = util.format_diagnostic,
--         }
--     end,
-- })

vim.lsp.config('*', { capabilities = vim.lsp.protocol.make_client_capabilities() })

--- Enables LSP servers on buffer read/new file
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
    once = true,
    callback = function()
        --- Check if a server is lot marked to be always disabled.
        ---@param server string The server to be checked
        ---@return string|nil The result of the validation (nil means that the server won't be activated)
        local function filter_server(server)
            local name = vim.fn.fnamemodify(server, ':t:r')
            -- Disable efm by defualt to avoid auto formatting
            local ok = vim.iter({ 'efm' }):filter(function(i) return i == name end):totable()
            return #ok == 0 and name or nil
        end

        local files = vim.api.nvim_get_runtime_file('lsp/*.lua', true)
        local server_configs = vim.iter(files):map(filter_server):totable()
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

        set('n', 'E', function() vim.diagnostic.open_float() end, { buffer = buf })
        set('n', 'K', function() vim.lsp.buf.hover() end, { buffer = buf })
        set('i', '<C-k>', function() vim.lsp.buf.signature_help() end, { buffer = buf })
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
