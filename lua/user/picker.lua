---@class Util.Find
local M = {}

---@class Util.Find.Cmd
---@field tool string name of the formatting tool
---@field cmd string format command of the tool

---@type Util.Find.Cmd[]
local cmds = {
    { tool = 'fd', cmd = 'fd . --path-separator / --type f --hidden --follow --exclude .git' },
    { tool = 'fdfind', cmd = 'fdfind . --path-separator / --type f --hidden --follow --exclude .git' },
    { tool = 'rg', cmd = 'rg --path-separator / --files --hidden --glob !.git' },
    { tool = 'ugrep', cmd = 'ugrep "" -Rl -I --ignore-files' },
    { tool = 'find', cmd = 'find ! ( -path "*/.git" -prune -o -name "*.swp" ) -type f -follow' },
}

--- Return the first formatting tool available
---@return Util.Find.Cmd
function M.findcmd()
    return vim.iter(cmds):find(
        ---@param c Util.Find.Cmd
        function(c) return vim.fn.executable(c.tool) == 1 end
    )
end

-- Default method for building the "findable" files
function M.default_cache()
    return vim.iter(vim.fn.globpath('.', '**', true, true))
        :filter(function(v) return vim.fn.isdirectory(v) == 0 end)
        :map(function(v) return vim.fn.substitute(v, '^.[/]', '', '') end)
        :flatten()
        :totable()
end

local files_cache = {}

local f = function() files_cache = {} end
_G.Config.new_autocmd('CmdlineEnter', nil, f)

function _G.Find(cmdarg, _cmdcomplete)
    if #files_cache == 0 then
        local findcmd = M.findcmd()
        local cmd = findcmd and findcmd.cmd

        if not cmd then
            files_cache = M.default_cache()
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
vim.keymap.set('n', '<Leader>g', ":sil<space>grep!<space>''<left>", { desc = 'Grep' })
