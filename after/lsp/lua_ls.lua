---@type vim.lsp.Config
return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = {
        '.luarc.json',
        '.luarc.jsonc',
        '.luacheckrc',
        '.stylua.toml',
        'stylua.toml',
        'selene.toml',
        'selene.yml',
        '.git',
    },
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
            completion = { callSnippet = 'Disable' },
            -- Disable formatting
            format = { enable = false },
            hint = { enable = false },
            diagnostics = {
                -- Don't analyze whole workspace, as it consumes too much CPU and RAM
                workspaceDelay = -1,
            },
            workspace = {
                checkThirdParty = false,
                telemetry = { enable = false },
                ignoreSubmodules = true,
                library = {
                    vim.env.VIMRUNTIME,
                    '${3rd}/luv/library',
                },
            },
        },
    },
}
