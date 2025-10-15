vim.diagnostic.config {
    update_in_insert = false,
    virtual_lines = false,
    underline = {
        severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
        },
    },
    signs = false,
    virtual_text = false,
}

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
    once = true,
    callback = function()
        local function filter_server(server)
            local name = vim.fn.fnamemodify(server, ':t:r')
            local ok = vim.iter({ 'efm' }):filter(function(i) return i == name end):totable()
            return #ok == 0 and name or nil
        end

        local files = vim.api.nvim_get_runtime_file('after/lsp/*.lua', true)
        local server_configs = vim.iter(files):map(filter_server):totable()
        vim.lsp.enable(server_configs)
    end,
})

local function split_args(str) return vim.iter(str:gmatch '%S+'):totable() end

local function validate_servers(servers)
    return vim.iter(servers):filter(function(i) return vim.lsp.config[i] ~= nil end):totable()
end

local function enable_servers(servers, enable)
    vim.iter(servers):each(function(i) vim.lsp.enable(i, enable) end)
end

vim.api.nvim_create_user_command('LspEnable', function(info)
    local servers = split_args(info.args)
    if #servers == 0 then
        vim.notify 'You must provide at least one server'
        return
    end
    local valid_servers = validate_servers(servers)
    enable_servers(valid_servers, true)
end, {
    nargs = '+',
    complete = function(arg)
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
    end,
})

vim.api.nvim_create_user_command('LspDisable', function(info)
    local servers = split_args(info.args)
    if #servers == 0 then
        vim.notify 'You must provide at least one server'
        return
    end
    local valid_servers = validate_servers(servers)
    enable_servers(valid_servers, false)
end, {
    nargs = '+',
    complete = function(arg)
        local result = vim.iter(vim.lsp.get_clients())
            :map(function(client) return client.name end)
            :filter(function(name) return name:sub(1, #arg) == arg end)
            :totable()
        return result
    end,
})

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
end, {
    nargs = '?',
    complete = function(arg)
        local result = vim.iter(vim.lsp.get_clients())
            :map(function(client) return client.name end)
            :filter(function(name) return name:sub(1, #arg) == arg end)
            :totable()
        return result
    end,
})
