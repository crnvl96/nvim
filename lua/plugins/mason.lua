MiniDeps.add({
    source = 'williamboman/mason.nvim',
    hooks = {
        post_checkout = function() vim.cmd('MasonUpdate') end,
    },
})

require('mason').setup()

require('mason-registry').refresh(function()
    for _, tool in ipairs({
        'stylua',
        'prettierd',
        'js-debug-adapter',
    }) do
        local pkg = require('mason-registry').get_package(tool)
        if not pkg:is_installed() then pkg:install() end
    end
end)
