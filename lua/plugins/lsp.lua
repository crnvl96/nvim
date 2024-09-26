return {
    { 'williamboman/mason-lspconfig.nvim' },
    { 'williamboman/mason.nvim', build = ':MasonUpdate' },
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        init = function() require('lsp-dynamic-capabilities').setup() end,
        config = function()
            local servers = require('lsp-servers').setup()

            require('mason').setup()
            require('mason-auto-install').setup()

            require('mason-lspconfig').setup({
                ensure_installed = vim.tbl_keys(servers),
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.lsp.protocol.make_client_capabilities()
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            })

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(e)
                    local client = vim.lsp.get_client_by_id(e.data.client_id)
                    if not client then return end
                    require('lsp-on-attach').setup(client, e.buf)
                end,
            })
        end,
    },
}
