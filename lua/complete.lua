local set = vim.keymap.set

set('c', '<C-n>', [[cmdcomplete_info().pum_visible ? "\<C-n>" : "\<Tab>"]], { expr = true })
set('c', '<C-p>', [[cmdcomplete_info().pum_visible ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

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

-- require('mini.completion').setup {
--     lsp_completion = {
--         source_func = 'omnifunc',
--         auto_setup = false,
--         process_items = function(items, base)
--             return MiniCompletion.default_process_items(items, base, { kind_priority = { Text = -1, Snippet = -1 } })
--         end,
--     },
-- }
--
-- vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })

vim.lsp.config('*', { capabilities = vim.lsp.protocol.make_client_capabilities() })

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client then return end

        if client:supports_method 'textDocument/completion' then
            local chars = { 'a', 'e', 'i', 'o', 'u', '.', ':', '_' }
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

        vim.bo[e.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    end,
})
