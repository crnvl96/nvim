---@class Util.Lsp
local M = {}

--- Splits a string into arguments separated by spaces
---@param str string The string to split into arguments
---@return string[] List of arguments
local function split_args(str) return vim.iter(str:gmatch '%S+'):totable() end

--- Completes client names based on partial input
---@param arg string The partial client name to complete
---@return string[] List of matching client names
function M.complete_client(arg)
    local result = vim.iter(vim.lsp.get_clients())
        :map(function(client) return client.name end)
        :filter(function(name) return name:sub(1, #arg) == arg end)
        :totable()
    return result
end

--- Completes config names based on partial input and current filetype
---@param arg string The partial config name to complete
---@return string[] List of matching config names for current filetype
function M.complete_config(arg)
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

--- Validates server names and notifies invalid ones
---@param servers string[] List of server names to validate
---@return string[] List of valid server names
local function validate_servers(servers)
    return vim.iter(servers):filter(function(i) return vim.lsp.config[i] ~= nil end):totable()
end

--- Check if a server is lot marked to be always disabled.
---@param server string The server to be checked
---@return string|nil The result of the validation (nil means that the server won't be activated)
function M.filter_server(server)
    local name = vim.fn.fnamemodify(server, ':t:r')
    local ok = vim.iter({}):filter(function(i) return i == name end):totable()
    return #ok == 0 and name or nil
end

--- Enables or disables the given servers
---@param servers string[] List of server names to enable/disable
---@param enable boolean Whether to enable or disable the servers
local function enable_servers(servers, enable)
    vim.iter(servers):each(function(i) vim.lsp.enable(i, enable) end)
end

--- Wrapper over diagnostic jumps
---@param next boolean Whethen to go forward or backward on the search
---@param severity? 'ERROR'|'WARN' type of diagnostic to search
function M.diagnostic_goto(next, severity)
    return function()
        vim.diagnostic.jump {
            count = (next and 1 or -1) * vim.v.count1,
            severity = severity and vim.diagnostic.severity[severity] or nil,
            float = true,
        }
    end
end

--- Start Lsp server(s)
---@param info vim.api.keyset.create_user_command.command_args
function M.lspstart(info)
    local servers = split_args(info.args)
    if #servers == 0 then
        vim.notify 'You must provide at least one server'
        return
    end
    local valid_servers = validate_servers(servers)
    enable_servers(valid_servers, true)
end

--- Stop Lsp server(s)
---@param info vim.api.keyset.create_user_command.command_args
function M.lspstop(info)
    local servers = split_args(info.args)
    if #servers == 0 then
        vim.notify 'You must provide at least one server'
        return
    end
    local valid_servers = validate_servers(servers)
    enable_servers(valid_servers, false)
end

--- Restart Lsp server(s)
---@param info vim.api.keyset.create_user_command.command_args
function M.lsprestart(info)
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
end

return M
