---@type vim.lsp.Config
return {
    cmd = { 'vscode-eslint-language-server', '--stdio' },
    filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
        'vue',
        'svelte',
        'astro',
        'htmlangular',
    },
    workspace_required = true,
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
    root_dir = function(bufnr, on_dir)
        local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
        root_markers = { root_markers, { '.git' } }
        local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
        on_dir(project_root)
    end,
    settings = {
        validate = 'on',
        format = false,
        run = 'onType',
        workingDirectory = { mode = 'auto' },
    },
}
