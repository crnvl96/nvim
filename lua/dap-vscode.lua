local M = {}

function M.setup()
    require('dap.ext.vscode').json_decode = function(str)
        return vim.json.decode(require('plenary.json').json_strip_comments(str))
    end

    if vim.fn.filereadable('.vscode/launch.json') then require('dap.ext.vscode').load_launchjs() end
end

return M
