return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
  opts = function()
    return {
      notify_on_error = true,
      formatters_by_ft = {
        ['_'] = { 'trim_whitespace' },
        ['markdown.mdx'] = { 'prettierd', 'injected' },
        markdown = { 'prettierd', 'injected' },
        css = { 'prettierd' },
        scss = { 'prettierd' },
        less = { 'prettierd' },
        tex = { 'tex-fmt' },
        html = { 'prettierd' },
        yaml = { 'prettierd' },
        json = { 'prettierd' },
        jsonc = { 'prettierd' },
        json5 = { 'prettierd' },
        toml = { 'taplo' },
        lua = { 'stylua' },
        javascript = { 'deno_fmt', 'prettierd' },
        typescript = { 'deno_fmt', 'prettierd' },
        javascriptreact = { 'deno_fmt', 'prettierd' },
        typescriptreact = { 'deno_fmt', 'prettierd' },
        ['javascript.tsx'] = { 'deno_fmt', 'prettierd' },
        ['typescript.tsx'] = { 'deno_fmt', 'prettierd' },
        python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
      },
      format_on_save = function()
        return {
          timeout_ms = 3000,
          async = false,
          quiet = false,
          lsp_format = 'fallback',
        }
      end,
      formatters = {
        injected = { ignore_errors = true },
        prettierd = {
          condition = function()
            local buf = vim.api.nvim_get_current_buf()
            return (
              vim.tbl_contains(
                { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
                vim.bo[buf].filetype
              ) and not vim.fs.root(buf, { 'package.json' })
            ) or true
          end,
        },
        deno_fmt = {
          condition = function()
            return vim.fs.root(vim.api.nvim_get_current_buf(), { 'deno.json', 'deno.jsonc' }) and true or false
          end,
        },
      },
    }
  end,
}
