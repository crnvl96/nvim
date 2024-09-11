local add = MiniDeps.add
local tools = require('config.tools')

add({
    source = 'williamboman/mason.nvim',
    hooks = { post_checkout = function() vim.cmd('MasonUpdate') end },
})

add('WhoIsSethDaniel/mason-tool-installer.nvim')

add({ source = 'williamboman/mason-lspconfig.nvim' })
add({ source = 'neovim/nvim-lspconfig' })

local mason = require('mason')

mason.setup()

require('mason-tool-installer').setup({
    ensure_installed = tools.formatters,
    integrations = {
        ['mason-lspconfig'] = false,
        ['mason-null-ls'] = false,
        ['mason-nvim-dap'] = false,
    },
})

local capabilities = vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities()
    -- require('cmp_nvim_lsp').default_capabilities()
)

local function on_attach(client, bufnr)
    local function set(lhs, rhs, desc, mode)
        local s = vim.keymap.set
        s(mode or 'n', lhs, rhs, { desc = desc, buffer = bufnr })
    end

    client.server_capabilities.documentFormattingProvider = false
    -- vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
    -- vim.bo[bufnr].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    vim.opt.omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

    local fzf = require('fzf-lua')

    set('grr', fzf.lsp_references, 'references')
    set('grd', fzf.lsp_definitions, 'definitions')
    set('gri', fzf.lsp_implementations, 'implementations')
    set('gry', fzf.lsp_typedefs, 'typedefs')
    set('gra', fzf.lsp_code_actions, 'code actions')
    set('grc', fzf.lsp_incoming_calls, 'incoming calls')
    set('grn', vim.lsp.buf.rename, 'rename symbol')
    set('grC', fzf.lsp_outgoing_calls, 'outgoing calls')
    set('grs', fzf.lsp_document_symbols, 'document symbols')
    set('grS', fzf.lsp_workspace_symbols, 'workspace symbols')
    set('grx', fzf.lsp_document_diagnostics, 'documet diagnostics')
    set('grX', fzf.lsp_workspace_diagnostics, 'workspace diagnostics')
    set('<C-k>', vim.lsp.buf.signature_help, 'signature help', 'i')
end

require('mason-lspconfig').setup({
    ensure_installed = vim.tbl_keys(tools.servers),
    handlers = {
        function(server_name)
            local server = tools.servers[server_name] or {}
            server.capabilities = capabilities
            require('lspconfig')[server_name].setup(server)
        end,
    },
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client then return end
        on_attach(client, e.buf)
    end,
})
