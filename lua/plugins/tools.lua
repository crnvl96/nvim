require('mason').setup()

require('mason-tool-installer').setup({
    ensure_installed = {
        'gofumpt',
        'goimports',
        'staticcheck',
        'gomodifytags',
        'impl',
        'delve',
        'prettierd',
        'js-debug-adapter',
        'stylua',
    },
    integrations = {
        ['mason-lspconfig'] = false,
        ['mason-null-ls'] = false,
        ['mason-nvim-dap'] = false,
    },
})
