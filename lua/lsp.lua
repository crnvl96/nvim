local function on_attach(client, bufnr)
    local set = vim.keymap.set
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_definition) then
        set('n', 'gd', "<cmd>Pick lsp scope='definition'<CR>", { desc = 'Lsp: go to definitions', buffer = bufnr })
    end

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_references) then
        set('n', 'gr', "<cmd>Pick lsp scope='references'<CR>", { desc = 'Lsp: go to references', buffer = bufnr })
    end

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_implementation) then
        local cmd = "<cmd>Pick lsp scope='implementation'<CR>"
        set('n', 'gi', cmd, { desc = 'Lsp: go to implementations', buffer = bufnr })
    end

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_typeDefinition) then
        local cmd = "<cmd>Pick lsp scope='type_definition'<CR>"
        set('n', 'gy', cmd, { desc = 'Lsp: go to type definition', buffer = bufnr })
    end

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_codeAction) then
        set('n', 'ga', function() vim.lsp.buf.code_action() end, { desc = 'Lsp: code actions', buffer = bufnr })
    end

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_rename) then
        local cmd = function() vim.lsp.buf.rename() end
        set('n', 'gn', cmd, { desc = 'Lsp: rename symbol under cursor', buffer = bufnr })
    end

    if client.supports_method(vim.lsp.protocol.Methods.workspace_diagnostic) then
        set('n', '<leader>fd', '<cmd>Pick diagnostic<CR>', { desc = 'Lsp: Pick diagnostics', buffer = bufnr })
    end

    if client.supports_method(vim.lsp.protocol.Methods.document_symbol) then
        local cmd = "<cmd>Pick lsp scope='document_symbol'<CR>"
        set('n', '<leader>fs', cmd, { desc = 'Lsp: Pick document symbols', buffer = bufnr })
    end

    if client.supports_method(vim.lsp.protocol.Methods.workspace_symbol) then
        local cmd = "<cmd>Pick lsp scope='workspace_symbol'<CR>"
        set('n', '<leader>fS', cmd, { desc = 'Lsp: Pick workspace symbols', buffer = bufnr })
    end

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        local cmd = function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
        end

        vim.keymap.set('n', '<leader>ci', cmd, { desc = 'Lsp: toggle inlay hints', buffer = bufnr })
    end
end

local registerCapability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then return end
    on_attach(client, vim.api.nvim_get_current_buf())
    return registerCapability(err, res, ctx)
end

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client then return end
        on_attach(client, e.buf)
    end,
})
