local util = require 'util.find'

local files_cache = {}

vim.api.nvim_create_autocmd('CmdlineEnter', {
    callback = function() files_cache = {} end,
})

function _G.Find(cmdarg, _cmdcomplete)
    if #files_cache == 0 then
        local findcmd = util.findcmd()
        local cmd = findcmd and findcmd.cmd

        if not cmd then
            files_cache = util.default_cache()
        else
            files_cache = vim.fn.systemlist(cmd)
        end
    end

    if #cmdarg == 0 then
        return files_cache
    else
        return vim.fn.matchfuzzy(files_cache, cmdarg)
    end
end

vim.o.findfunc = 'v:lua.Find'

vim.keymap.set('n', '<Leader>f', ':find<space>', { desc = 'Find files' })
