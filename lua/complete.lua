vim.opt.completeopt = table.concat({
    'menuone',
    'noselect',
    'noinsert',
    'fuzzy',
    'nosort',
}, ',')

vim.opt.completefuzzycollect = table.concat({
    'keyword',
    'files',
    'whole_line',
}, ',')

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

---@param keys string
local function feedkeys(keys) vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), 'n', true) end

vim.keymap.set('i', '<C-n>', function() vim.lsp.completion.get() end)

vim.keymap.set('c', '<C-n>', function()
    if vim.fn.cmdcomplete_info().pum_visible then return feedkeys '<C-n>' end
    feedkeys '<Tab>'
end)

vim.keymap.set('c', '<C-p>', function()
    if vim.fn.cmdcomplete_info().pum_visible then return feedkeys '<C-p>' end
    return feedkeys '<S-Tab>'
end)

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client then return end

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
        end

        if client:supports_method 'textDocument/inlineCompletion' then vim.lsp.inline_completion.enable() end
    end,
})
