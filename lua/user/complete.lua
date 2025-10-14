vim.o.completefuzzycollect = 'keyword,files,whole_line'
vim.o.pummaxwidth = 100
vim.o.pumheight = 10
vim.o.wildoptions = table.concat({ 'pum', 'fuzzy' }, ',')
vim.o.wildignorecase = true
vim.o.wildmode = 'noselect:lastused,full'
vim.o.wildmenu = true
vim.o.complete = '.,w,b,kspell'
vim.o.completeopt = 'menuone,noselect,fuzzy,nosort'

vim.cmd [[set wc=^N]]

vim.opt.wildignore:append '.DS_Store'

local ft = { ':', '/', '?', '@' }
local f = function() vim.cmd 'call wildtrigger()' end
_G.Config.new_autocmd('CmdlineChanged', ft, f)

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client then return end

        vim.bo[e.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        if client:supports_method 'textDocument/completion' then
            ---@note
            --- A test to see if we're ok with manually triggering via
            --- <C-x><C-o>
            ---
            -- -- stylua: ignore
            -- local chars = { 'a', 'e', 'i', 'o', 'u',
            --                 'A', 'E', 'I', 'O', 'U',
            --                 '.', ':', '_', '-' }
            --
            -- client.server_capabilities.completionProvider.triggerCharacters = chars

            vim.lsp.completion.enable(true, client.id, e.buf, {
                -- Manual trigger with `<C-x><C-o>`
                autotrigger = false,
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
    end,
})
