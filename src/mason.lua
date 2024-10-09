MiniDeps.add({ source = 'williamboman/mason.nvim', hooks = { post_checkout = function() vim.cmd('MasonUpdate') end } })

require('mason').setup()

local tools = {
    'stylua',
    'prettierd',
    'js-debug-adapter',
    'debugpy',
    'black',
}

local function auto_install_tools()
    for _, tool in ipairs(tools) do
        local pkg = require('mason-registry').get_package(tool)
        if not pkg:is_installed() then pkg:install() end
    end
end

require('mason-registry').refresh(auto_install_tools)
