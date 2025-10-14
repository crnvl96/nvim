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

        local files = vim.api.nvim_get_runtime_file('after/lsp/*.lua', true)
        local server_configs = vim.iter(files):map(filter_server):totable()
        vim.lsp.enable(server_configs)
    end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
        local set = vim.keymap.set
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client then return end
        local buf = e.buf

        if not client then return end

        vim.bo[e.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        if client:supports_method 'textDocument/completion' then
            -- stylua: ignore
            local chars = { 'a', 'e', 'i', 'o', 'u',
                            'A', 'E', 'I', 'O', 'U',
                            '.', ':', '_', '-' }

            client.server_capabilities.completionProvider.triggerCharacters = chars

            vim.lsp.completion.enable(true, client.id, e.buf, {
                autotrigger = true,
                convert = function(item)
                    local desc = item.labelDetails and item.labelDetails.description
                    if not desc then return {} end
                    return {
                        menu = item.labelDetails.description,
                        info = item.labelDetails.description,
                    }
                end,
            })

            local function feedkeys(keys)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
            end

            local function pumvisible() return tonumber(vim.fn.pumvisible()) ~= 0 end

            local function handle_c_n_trigger()
                if pumvisible() then
                    feedkeys '<C-n>'
                else
                    if next(vim.lsp.get_clients { bufnr = 0 }) then
                        vim.lsp.completion.get()
                    else
                        if vim.bo.omnifunc == '' then
                            feedkeys '<C-x><C-n>'
                        else
                            feedkeys '<C-x><C-o>'
                        end
                    end
                end
            end

            set('i', '<C-n>', handle_c_n_trigger, { buffer = buf })

            local function diagnostic_goto(next, severity)
                return function()
                    vim.diagnostic.jump {
                        count = (next and 1 or -1) * vim.v.count1,
                        severity = severity and vim.diagnostic.severity[severity] or nil,
                        float = true,
                    }
                end
            end

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
            set('n', ']d', diagnostic_goto(true), { buffer = buf })
            set('n', '[d', diagnostic_goto(false), { buffer = buf })
            set('n', ']e', diagnostic_goto(true, 'ERROR'), { buffer = buf })
            set('n', '[e', diagnostic_goto(false, 'ERROR'), { buffer = buf })
            set('n', ']w', diagnostic_goto(true, 'WARN'), { buffer = buf })
            set('n', '[w', diagnostic_goto(false, 'WARN'), { buffer = buf })
        end
    end,
})

local function split_args(str) return vim.iter(str:gmatch '%S+'):totable() end

local function validate_servers(servers)
    return vim.iter(servers):filter(function(i) return vim.lsp.config[i] ~= nil end):totable()
end

local function enable_servers(servers, enable)
    vim.iter(servers):each(function(i) vim.lsp.enable(i, enable) end)
end

--- Creates a user command to start LSP servers
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

--- Creates a user command to stop LSP servers
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
