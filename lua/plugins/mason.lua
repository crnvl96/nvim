local deps = require('mini.deps')
local add = deps.add

add({
    source = 'williamboman/mason.nvim',
    hooks = { post_checkout = function() vim.cmd('MasonUpdate') end },
})

local mason = require('mason')
mason.setup()

local ensure_installed = {
    'stylua',
    'prettierd',
    'js-debug-adapter',
    'debugpy',
    'black',
}

local mason_registry = require('mason-registry')
mason_registry.refresh(function()
    for _, tool in ipairs(ensure_installed) do
        local pkg = mason_registry.get_package(tool)
        if not pkg:is_installed() then pkg:install() end
    end
end)
