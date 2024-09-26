local M = {}

function M.setup()
    local mr = require('mason-registry')
    mr:on('package:install:success', function()
        vim.defer_fn(
            function()
                require('lazy.core.handler.event').trigger({
                    event = 'FileType',
                    buf = vim.api.nvim_get_current_buf(),
                })
            end,
            100
        )
    end)

    mr.refresh(function()
        for _, tool in ipairs({
            'stylua',
            'prettierd',
            'js-debug-adapter',
            'debugpy',
            'black',
        }) do
            local p = mr.get_package(tool)
            if not p:is_installed() then p:install() end
        end
    end)
end

return M
