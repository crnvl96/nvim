local util = require 'util.lsp'

--- Creates a user command to start LSP servers
vim.api.nvim_create_user_command('LspStart', function(info)
    local servers = util.split_args(info.args)
    if #servers == 0 then
        vim.notify 'You must provide at least one server'
        return
    end
    local valid_servers = util.validate_servers(servers)
    util.enable_servers(valid_servers, true)
end, { nargs = '+', complete = util.complete_config })

--- Creates a user command to stop LSP servers
vim.api.nvim_create_user_command('LspStop', function(info)
    local servers = util.split_args(info.args)
    if #servers == 0 then
        vim.notify 'You must provide at least one server'
        return
    end
    local valid_servers = util.validate_servers(servers)
    util.enable_servers(valid_servers, false)
end, { nargs = '+', complete = util.complete_client })

--- Creates a user command to restart LSP clients
vim.api.nvim_create_user_command('LspRestart', function(info)
    local clients = info.fargs
    if #clients == 0 then
        clients = vim.iter(vim.lsp.get_clients()):map(function(client) return client.name end):totable()
    end
    local valid_clients = util.validate_servers(clients)
    util.enable_servers(valid_clients, false)
    local timer = assert(vim.uv.new_timer())
    timer:start(500, 0, function()
        vim.schedule(function() util.enable_servers(valid_clients, true) end)
    end)
end, { nargs = '?', complete = util.complete_client })

--- Autoformats on buffer write
vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function(e) vim.lsp.buf.format { bufnr = e.buf } end,
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

        set('n', 'E', vim.diagnostic.open_float, { buffer = buf })
        set('n', 'K', vim.lsp.buf.hover, { buffer = buf })
        set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = buf })

        set('n', 'ga', vim.lsp.buf.code_action, { buffer = buf })
        set('n', 'gn', vim.lsp.buf.rename, { buffer = buf })
        set('n', 'gd', vim.lsp.buf.definition, { buffer = buf })
        set('n', 'gD', vim.lsp.buf.declaration, { buffer = buf })
        set('n', 'gr', vim.lsp.buf.references, { buffer = buf, nowait = true })
        set('n', 'gi', vim.lsp.buf.implementation, { buffer = buf })
        set('n', 'gy', vim.lsp.buf.type_definition, { buffer = buf })
        set('n', 'ge', vim.diagnostic.setqflist, { buffer = buf })

        set('n', ']d', util.diagnostic_goto(true), { buffer = buf })
        set('n', '[d', util.diagnostic_goto(false), { buffer = buf })
        set('n', ']e', util.diagnostic_goto(true, 'ERROR'), { buffer = buf })
        set('n', '[e', util.diagnostic_goto(false, 'ERROR'), { buffer = buf })
        set('n', ']w', util.diagnostic_goto(true, 'WARN'), { buffer = buf })
        set('n', '[w', util.diagnostic_goto(false, 'WARN'), { buffer = buf })
    end,
})
