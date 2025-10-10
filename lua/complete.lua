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
vim.cmd [[set wc=^N]]

vim.api.nvim_create_autocmd('CmdlineChanged', {
    pattern = { ':', '/', '?', '@' },
    command = 'call wildtrigger()',
})

require('mini.completion').setup {
    lsp_completion = {
        source_func = 'omnifunc',
        auto_setup = false,
        process_items = function(items, base)
            return require('mini.completion').default_process_items(items, base, {
                kind_priority = {
                    Text = -1,
                    Snippet = 99,
                },
            })
        end,
    },
}

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client then return end

        ---@note
        --- if we get rid of mini.completion, revert this change
        vim.bo[e.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

        -- ```lua
        -- vim.bo[e.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        --
        -- if client:supports_method 'textDocument/completion' then
        --     -- stylua: ignore
        --     local chars = { 'a', 'e', 'i', 'o', 'u',
        --                     'A', 'E', 'I', 'O', 'U',
        --                     '.', ':', '_', '-' }
        --
        --     client.server_capabilities.completionProvider.triggerCharacters = chars
        --
        --     vim.lsp.completion.enable(true, client.id, e.buf, {
        --         autotrigger = true,
        --         convert = function(item)
        --             local desc = item.labelDetails and item.labelDetails.description
        --             if not desc then return {} end
        --             return {
        --                 menu = item.labelDetails.description,
        --                 info = item.labelDetails.description,
        --             }
        --         end,
        --     })
        -- end
        -- ```

        ---@note
        --- I don't know exactly the purpose of this in addition to providing
        --- copilot suggestions
        -- if client:supports_method 'textDocument/inlineCompletion' then vim.lsp.inline_completion.enable() end
    end,
})
