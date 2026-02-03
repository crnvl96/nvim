---@diagnostic disable: undefined-global, unused-local

local ltr = MiniDeps.later

ltr(function()
    if vim.fn.executable 'rg' == 1 then
        function _G.FindFunc(cmdarg, _cmdcomplete)
            local fnames = vim.fn.systemlist 'rg --files --hidden --color=never --glob="!.git"'
            return #cmdarg == 0 and fnames or vim.fn.matchfuzzy(fnames, cmdarg)
        end
        vim.o.findfunc = 'v:lua.FindFunc'
    end
end)
