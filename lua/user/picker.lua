local files_cache = {}

local function getcmd()
    local cmds = {
        { tool = 'fd', cmd = 'fd . --path-separator / --type f --hidden --follow --exclude .git' },
        { tool = 'fdfind', cmd = 'fdfind . --path-separator / --type f --hidden --follow --exclude .git' },
        { tool = 'rg', cmd = 'rg --path-separator / --files --hidden --glob !.git' },
        { tool = 'ugrep', cmd = 'ugrep "" -Rl -I --ignore-files' },
        { tool = 'find', cmd = 'find ! ( -path "*/.git" -prune -o -name "*.swp" ) -type f -follow' },
    }

    return vim.iter(cmds):find(function(c) return vim.fn.executable(c.tool) == 1 end)
end

local function default_cache()
    return vim.iter(vim.fn.globpath('.', '**', true, true))
        :filter(function(v) return vim.fn.isdirectory(v) == 0 end)
        :map(function(v) return vim.fn.substitute(v, '^.[/]', '', '') end)
        :flatten()
        :totable()
end

function _G.Find(cmdarg, _cmdcomplete)
    if #files_cache == 0 then
        local findcmd = getcmd()
        local cmd = findcmd and findcmd.cmd

        if not cmd then
            files_cache = default_cache()
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

vim.api.nvim_create_autocmd('CmdlineEnter', {
    callback = function() files_cache = {} end,
})

vim.keymap.set('n', '<Leader>f', ':find<space>', { desc = 'Find files' })
vim.keymap.set('n', '<Leader>g', ":sil<space>grep!<space>''<left>", { desc = 'Grep' })
