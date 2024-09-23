local methods = vim.lsp.protocol.Methods

local function on_attach(client, bufnr)
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local def = methods.textDocument_definition
    local ref = methods.textDocument_implementation
    local impl = methods.textDocument_implementation
    local typedef = methods.textDocument_typeDefinition
    local codeactions = methods.textDocument_codeAction
    local rename = methods.textDocument_rename
    local inlayhint = methods.textDocument_inlayHint

    local function toggle_inlayhints()
        local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
        vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = bufnr })
    end

    local maps = {
        { def, 'grd', '<cmd>FzfLua lsp_definitions<cr>', 'Definitions' },
        { ref, 'grr', '<cmd>FzfLua lsp_implementations<cr>', 'References' },
        { impl, 'gri', '<cmd>FzfLua lsp_implementations<cr>', 'Implementations' },
        { typedef, 'gry', '<cmd>FzfLua lsp_typedefs<cr>', 'Type Definitions' },
        { codeactions, 'gra', '<cmd>FzfLua lsp_code_actions<cr>', 'Code Actions' },
        { rename, 'grn', vim.lsp.buf.rename, 'Rename Symbol' },
        { inlayhint, '<leader>ci', toggle_inlayhints, 'Toggle Inlay Hints' },
    }

    for _, map in ipairs(maps) do
        if client.supports_method(map[1]) then
            vim.keymap.set('n', map[2], map[3], { desc = map[4], buffer = bufnr })
        end
    end
end

vim.diagnostic.config({
    virtual_text = {
        prefix = '',
        spacing = 2,
        format = function(diagnostic)
            return string.format(
                '%s %s[%s] ',
                vim.g.diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]],
                diagnostic.source,
                diagnostic.code
            )
        end,
    },
    float = {
        border = 'rounded',
        source = 'if_many',
        prefix = function(diag)
            local level = vim.diagnostic.severity[diag.severity]
            return string.format(' %s ', vim.g.diagnostic_icons[level]), 'Diagnostic' .. level:gsub('^%l', string.upper)
        end,
    },
    signs = false,
})

vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then return end
    on_attach(client, vim.api.nvim_get_current_buf())
    return vim.lsp.handlers[methods.client_registerCapability](err, res, ctx)
end

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client then return end
        on_attach(client, e.buf)
    end,
})
