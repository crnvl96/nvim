vim.opt.completeopt = table.concat({ 'menuone', 'noselect', 'noinsert', 'fuzzy', 'nosort' }, ',')
vim.opt.completefuzzycollect = table.concat({ 'keyword', 'files', 'whole_line' }, ',')
vim.opt.pummaxwidth = 100
vim.opt.wildoptions = table.concat({ 'pum', 'fuzzy' }, ',')
vim.opt.wildignore:append '.DS_Store'
vim.opt.wildignorecase = true
vim.opt.wildmode = 'noselect:lastused,full'
vim.opt.wildmenu = true

vim.api.nvim_create_autocmd('CmdlineChanged', {
    pattern = { ':', '/', '?', '@' },
    command = 'call wildtrigger()',
})

vim.lsp.config('*', { capabilities = vim.lsp.protocol.make_client_capabilities() })

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client then return end

        if client:supports_method 'textDocument/completion' then
            -- stylua: ignore
            local chars = { 'a', 'e', 'i', 'o', 'u',
                'A', 'E', 'I', 'O', 'U',
                '.', ':', '_', '-', }
            client.server_capabilities.completionProvider.triggerCharacters = chars
            vim.lsp.completion.enable(true, client.id, e.buf, {
                autotrigger = true,
                convert = function(item)
                    if not item.labelDetails then return {} end
                    if not item.labelDetails.description then return {} end
                    return {
                        menu = item.labelDetails.description,
                        info = item.labelDetails.description,
                    }
                end,
            })
        end

        if client:supports_method 'textDocument/inlineCompletion' then vim.lsp.inline_completion.enable() end
    end,
})
