vim.cmd [[autocmd CmdlineChanged [:/\?@] call wildtrigger()]]

vim.api.nvim_create_autocmd('TextYankPost', { callback = function() (vim.hl or vim.highlight).on_yank() end })

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
    once = true,
    callback = function()
        local files = vim.api.nvim_get_runtime_file('lsp/*.lua', true)
        local function mapfunc(file)
            local disabled_servers = { 'stylua', 'copilot' }
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

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
        local set = vim.keymap.set
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client then return end
        local buf = e.buf
        vim.lsp.inline_completion.enable()
        vim.bo[e.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
        set('n', 'E', vim.diagnostic.open_float, { buffer = buf })
        set('n', 'K', vim.lsp.buf.hover, { buffer = buf })
        set('n', 'ga', vim.lsp.buf.code_action, { buffer = buf })
        set('n', 'gn', vim.lsp.buf.rename, { buffer = buf })
        set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = buf })
        set('n', 'gd', "<Cmd>Pick lsp scope='definition'<CR>", { buffer = buf })
        set('n', 'gD', "<Cmd>Pick lsp scope='declaration'<CR>", { buffer = buf })
        set('n', 'gr', "<Cmd>Pick lsp scope='references'<CR>", { buffer = buf })
        set('n', 'gi', "<Cmd>Pick lsp scope='implementation'<CR>", { buffer = buf })
        set('n', 'gy', "<Cmd>Pick lsp scope='type_definition'<CR>", { buffer = buf })
        set('n', 'ge', "<Cmd>Pick diagnostic scope='current'<CR>", { buffer = buf })
        set('n', 'gE', "<Cmd>Pick diagnostic scope='all'<CR>", { buffer = buf })
        set('n', 'gO', "<Cmd>Pick lsp scope='workspace_symbol'<CR>", { buffer = buf })
        set('n', 'gs', "<Cmd>Pick lsp scope='document_symbol'<CR>", { buffer = buf })

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
