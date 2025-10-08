--- Completes client names based on partial input
---@param arg string The partial client name to complete
---@return string[] List of matching client names
local complete_client = function(arg)
    local result = vim.iter(vim.lsp.get_clients())
        :map(function(client) return client.name end)
        :filter(function(name) return name:sub(1, #arg) == arg end)
        :totable()
    return result
end

--- Completes config names based on partial input and current filetype
---@param arg string The partial config name to complete
---@return string[] List of matching config names for current filetype
local complete_config = function(arg)
    local result = vim.iter(vim.api.nvim_get_runtime_file(('lsp/%s*.lua'):format(arg), true))
        :map(function(path)
            local file_name = path:match '[^/]*.lua$'
            return file_name:sub(0, #file_name - 4)
        end)
        :filter(function(name)
            local filetype = vim.bo.filetype
            if not filetype then return false end
            local filetypes = vim.lsp.config[name].filetypes
            if not filetypes then return false end
            return vim.tbl_contains(filetypes, filetype)
        end)
        :totable()
    return result
end

--- Splits a string into arguments separated by spaces
---@param str string The string to split into arguments
---@return string[] List of arguments
local function split_args(str)
    local t = {}
    for word in string.gmatch(str, '%S+') do
        table.insert(t, word)
    end
    return t
end

--- Validates server names and notifies invalid ones
---@param servers string[] List of server names to validate
---@return string[] List of valid server names
local function validate_servers(servers)
    local valid_servers = {}
    for _, name in ipairs(servers) do
        if vim.lsp.config[name] == nil then
            vim.notify(("Invalid server name '%s'"):format(name))
        else
            table.insert(valid_servers, name)
        end
    end
    return valid_servers
end

--- Enables or disables the given servers
---@param servers string[] List of server names to enable/disable
---@param enable boolean Whether to enable or disable the servers
local function enable_servers(servers, enable)
    for _, name in ipairs(servers) do
        vim.lsp.enable(name, enable)
        vim.notify(("%s server '%s'"):format(enable and 'Enabled' or 'Disabled', name))
    end
end

--- Creates a user command to start LSP servers
vim.api.nvim_create_user_command('LspStart', function(info)
    local servers = split_args(info.args)
    if #servers == 0 then
        vim.notify 'You must provide at least one server'
        return
    end
    local valid_servers = validate_servers(servers)
    enable_servers(valid_servers, true)
end, { nargs = '+', complete = complete_config })

--- Creates a user command to stop LSP servers
vim.api.nvim_create_user_command('LspStop', function(info)
    local servers = split_args(info.args)
    if #servers == 0 then
        vim.notify 'You must provide at least one server'
        return
    end
    local valid_servers = validate_servers(servers)
    enable_servers(valid_servers, false)
end, { nargs = '+', complete = complete_client })

--- Creates a user command to restart LSP clients
vim.api.nvim_create_user_command('LspRestart', function(info)
    local clients = info.fargs
    if #clients == 0 then
        clients = vim.iter(vim.lsp.get_clients()):map(function(client) return client.name end):totable()
    end
    local valid_clients = validate_servers(clients)
    enable_servers(valid_clients, false)
    local timer = assert(vim.uv.new_timer())
    timer:start(500, 0, function()
        vim.schedule(function() enable_servers(valid_clients, true) end)
    end)
end, { nargs = '?', complete = complete_client })

--- Autoformats on buffer write
vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function(e) vim.lsp.buf.format { bufnr = e.buf } end,
})

--- Enables LSP servers on buffer read/new file
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
    once = true,
    callback = function()
        local files = vim.api.nvim_get_runtime_file('lsp/*.lua', true)
        local function mapfunc(file)
            local disabled_servers = {}
            local filename = vim.fn.fnamemodify(file, ':t:r')
            for _, server in ipairs(disabled_servers) do
                if filename == server then return nil end
            end
            return filename
        end
        local server_configs = vim.iter(files):map(mapfunc):totable()
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

        local diagnostic_goto = function(next, severity)
            return function()
                vim.diagnostic.jump {
                    count = (next and 1 or -1) * vim.v.count1,
                    severity = severity and vim.diagnostic.severity[severity] or nil,
                    float = true,
                }
            end
        end

        set('n', ']d', diagnostic_goto(true), { buffer = buf })
        set('n', '[d', diagnostic_goto(false), { buffer = buf })
        set('n', ']e', diagnostic_goto(true, 'ERROR'), { buffer = buf })
        set('n', '[e', diagnostic_goto(false, 'ERROR'), { buffer = buf })
        set('n', ']w', diagnostic_goto(true, 'WARN'), { buffer = buf })
        set('n', '[w', diagnostic_goto(false, 'WARN'), { buffer = buf })
    end,
})
