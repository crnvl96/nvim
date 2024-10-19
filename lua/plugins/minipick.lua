require('mini.extra').setup()

require('mini.visits').setup()

require('mini.pick').setup({
    options = {
        use_cache = false,
    },
    window = {
        prompt_cursor = '█',
        prompt_prefix = '',
    },
})

vim.ui.select = MiniPick.ui_select

local function on_lsp_attach(client, bufnr)
    local lsp_methods = vim.lsp.protocol.Methods
    vim.bo[bufnr].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    client.server_capabilities.documentFormattingProvider = false

    local lsp_maps = {
        {
            method = lsp_methods.textDocument_codeAction,
            mode = 'n',
            lhs = 'ga',
            rhs = function() vim.lsp.buf.code_action() end,
            opts = {
                desc = 'Pick code action',
                buffer = bufnr,
            },
        },
        {
            method = lsp_methods.textDocument_rename,
            mode = 'n',
            lhs = 'gn',
            rhs = function() vim.lsp.buf.rename() end,
            opts = {
                desc = 'Rename current lsp symbol',
                buffer = bufnr,
            },
        },
        {
            method = lsp_methods.textDocument_definition,
            mode = 'n',
            lhs = 'gd',
            rhs = function() MiniExtra.pickers.lsp({ scope = 'definition' }) end,
            opts = {
                desc = 'Pick lsp definitions',
                buffer = bufnr,
            },
        },
        {
            method = lsp_methods.textDocument_references,
            mode = 'n',
            lhs = 'gR',
            rhs = function() MiniExtra.pickers.lsp({ scope = 'references' }) end,
            opts = {
                desc = 'Pick lsp references',
                buffer = bufnr,
            },
        },
        {
            method = lsp_methods.textDocument_implementation,
            mode = 'n',
            lhs = 'gi',
            rhs = function() MiniExtra.pickers.lsp({ scope = 'implementation' }) end,
            opts = {
                desc = 'Pick lsp implementations',
                buffer = bufnr,
            },
        },
        {
            method = lsp_methods.textDocument_typeDefinition,
            mode = 'n',
            lhs = 'gy',
            rhs = function() MiniExtra.pickers.lsp({ scope = 'type_definition' }) end,
            opts = {
                desc = 'Pick lsp type definitions',
                buffer = bufnr,
            },
        },
        {
            method = lsp_methods.textDocument_documentSymbol,
            mode = 'n',
            lhs = 'gs',
            rhs = function() MiniExtra.pickers.lsp({ scope = 'document_symbol' }) end,
            opts = {
                desc = 'Pick lsp document symbols',
                buffer = bufnr,
            },
        },
    }

    for _, map in ipairs(lsp_maps) do
        if client.supports_method(map.method) then vim.keymap.set(map.mode, map.lhs, map.rhs, map.opts) end
    end
end

local registerCapability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then return end
    on_lsp_attach(client, vim.api.nvim_get_current_buf())
    return registerCapability(err, res, ctx)
end

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('Crnvl96LspOnAttach', {}),
    callback = function(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client then return end
        on_lsp_attach(client, e.buf)
    end,
})

local keymaps = {
    {
        mode = 'n',
        lhs = '<leader>ff',
        rhs = function() MiniPick.builtin.files() end,
        opts = {
            desc = 'Pick files',
        },
    },
    {
        mode = 'n',
        lhs = '<leader>fg',
        rhs = function() MiniPick.builtin.grep_live() end,
        opts = {
            desc = 'Pick from live grep',
        },
    },
    {
        mode = 'n',
        lhs = '<leader>fh',
        rhs = function() MiniPick.builtin.help() end,
        opts = {
            desc = 'Pick help tags',
        },
    },
    {
        mode = 'n',
        lhs = '<leader>fb',
        rhs = function() MiniPick.builtin.buffers() end,
        opts = {
            desc = 'Pick buffers',
        },
    },
    {
        mode = 'n',
        lhs = '<leader>fc',
        rhs = function() MiniExtra.pickers.commands() end,
        opts = {
            desc = 'Pick from available commands',
        },
    },
    {
        mode = 'n',
        lhs = '<leader>fd',
        rhs = function() MiniExtra.pickers.diagnostics() end,
        opts = {
            desc = 'Pick from diagnostic list',
        },
    },
    {
        mode = 'n',
        lhs = '<leader>gb',
        rhs = function() MiniExtra.pickers.git_branches() end,
        opts = {
            desc = 'Pick git branch history',
        },
    },
    {
        mode = 'n',
        lhs = '<leader>gf',
        rhs = function() MiniExtra.pickers.git_files({ scope = 'ignored' }) end,
        opts = {
            desc = 'Pick from ignored git files',
        },
    },
    {
        mode = 'n',
        lhs = '<leader>gh',
        rhs = function() MiniExtra.pickers.git_hunks({ n_context = 6 }) end,
        opts = {
            desc = 'Pick from git hunks',
        },
    },
    {
        mode = 'n',
        lhs = '<leader>hc',
        rhs = function() MiniExtra.pickers.history({ scope = ':' }) end,
        opts = {
            desc = 'Pick from command history',
        },
    },
    {
        mode = 'n',
        lhs = '<leader>hs',
        rhs = function() MiniExtra.pickers.history({ scope = '/' }) end,
        opts = {
            desc = 'Pick from search history',
        },
    },
    {
        mode = 'n',
        lhs = '<leader>hs',
        rhs = function() MiniExtra.pickers.history({ scope = '/' }) end,
        opts = {
            desc = 'Pick from search history',
        },
    },
    {
        mode = 'n',
        lhs = '<leader>fl',
        rhs = function() MiniExtra.pickers.buf_lines({ scope = 'current' }) end,
        opts = {
            desc = 'Pick from buf lines',
        },
    },
    {
        mode = 'n',
        lhs = '<leader>fL',
        rhs = function() MiniExtra.pickers.hl_groups() end,
        opts = {
            desc = 'Pick from highlight groups',
        },
    },
    {
        mode = 'n',
        lhs = '<leader>fk',
        rhs = function() MiniExtra.pickers.keymaps() end,
        opts = {
            desc = 'Pick from keymaps',
        },
    },
    {
        mode = 'n',
        lhs = '<leader>fx',
        rhs = function() MiniExtra.pickers.list({ scope = 'quickfix' }) end,
        opts = {
            desc = 'Pick from quickfix list',
        },
    },
    {
        mode = 'n',
        lhs = '<leader>fm',
        rhs = function() MiniExtra.pickers.marks({ scope = 'buf' }) end,
        opts = {
            desc = 'Pick local marks',
        },
    },
    {
        mode = 'n',
        lhs = '<leader>fM',
        rhs = function() MiniExtra.pickers.marks({ scope = 'all' }) end,
        opts = {
            desc = 'Pick global marks',
        },
    },
    {
        mode = 'n',
        lhs = '<leader>fo',
        rhs = function() MiniExtra.pickers.visit_paths() end,
        opts = {
            desc = 'Pick from visit paths',
        },
    },
}

for _, map in ipairs(keymaps) do
    vim.keymap.set(map.mode, map.lhs, map.rhs, map.opts)
end
