MiniDeps.add({
    source = 'neovim/nvim-lspconfig',
    depends = {
        {
            source = 'williamboman/mason-lspconfig.nvim',
            depends = {
                { source = 'williamboman/mason.nvim' },
            },
        },
    },
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
local servers = Lang.get_servers()

require('mason-lspconfig').setup({
    ensure_installed = vim.tbl_keys(servers) or {},
    handlers = {
        function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = capabilities
            require('lspconfig')[server_name].setup(server)
        end,
    },
})
