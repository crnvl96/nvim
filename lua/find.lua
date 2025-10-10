local files_cache = {}

vim.api.nvim_create_autocmd('CmdlineEnter', {
    callback = function() files_cache = {} end,
})

local function find_cmd()
    local cmd = ''

    if vim.fn.executable 'rg' then
        cmd = 'rg --path-separator / --files --hidden --glob !.git'
    elseif vim.fn.executable 'fd' then
        cmd = 'fd . --path-separator / --type f --hidden --follow --exclude .git'
    elseif vim.fn.executable 'fdfind' then
        cmd = 'fdfind . --path-separator / --type f --hidden --follow --exclude .git'
    elseif vim.fn.executable 'ugrep' then
        cmd = 'ugrep "" -Rl -I --ignore-files'
    elseif vim.fn.executable 'find' then
        cmd = 'find ! ( -path "*/.git" -prune -o -name "*.swp" ) -type f -follow'
    end

    return cmd
end

function _G.Find(cmdarg, _cmdcomplete)
    if #files_cache == 0 then
        local cmd = find_cmd()
        if cmd == '' then
            files_cache = vim.iter(vim.fn.globpath('.', '**', true, true))
                :filter(function(v) return vim.fn.isdirectory(v) == 0 end)
                :map(function(v) return vim.fn.substitute(v, '^.[/]', '', '') end)
                :flatten()
                :totable()
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
