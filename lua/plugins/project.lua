local project = require('project_nvim')
project.setup({
    -- patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json' },
    patterns = { '.git' },
    silent_chdir = false,
    scope_chdir = 'win',
})

local fzf_lua = require('fzf-lua')
vim.keymap.set('n', '<leader>fp', function()
    local history = require('project_nvim.utils.history')
    fzf_lua.fzf_exec(function(cb)
        local results = history.get_recent_projects()
        for _, e in ipairs(results) do
            cb(e)
        end
        cb()
    end, {
        actions = {
            ['default'] = {
                function(selected) fzf_lua.files({ cwd = selected[1] }) end,
            },
            ['ctrl-d'] = {
                function(selected) history.delete_project({ value = selected[1] }) end,
                fzf_lua.actions.resume,
            },
        },
    })
end, { silent = true, desc = 'Switch project' })
