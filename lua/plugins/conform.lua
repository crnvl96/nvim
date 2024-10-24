return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
  opts = function()
    local Constants = require('config.constants')

    local function get_first_formatter(bufnr, ...)
      for i = 1, select('#', ...) do
        local formatter = select(i, ...)
        if require('conform').get_formatter_info(formatter, bufnr).available then return formatter end
      end

      return select(1, ...)
    end

    local function is_web_project(ctx) return vim.fs.find({ 'package.json' }, { path = ctx.filename, upward = true })[1] end

    local function is_json_or_markdown(ctx)
      local ext = vim.fn.fnamemodify(ctx.filename, ':t:e')
      return ext:match('json') or ext:match('md') or ext:match('markdown')
    end

    return {
      notify_on_error = false,
      formatters_by_ft = {
        ['_'] = { 'trim_whitespace' },
        markdown = function(buf) return { get_first_formatter(buf, 'prettierd'), 'injected' } end,
        json = { 'prettierd', stop_after_first = true },
        jsonc = { 'prettierd', stop_after_first = true },
        json5 = { 'prettierd', stop_after_first = true },
        toml = { 'taplo' },
        lua = { 'stylua' },
        rust = { 'rustfmt' },
        javascript = { 'deno_fmt', 'prettierd', stop_after_first = true },
        typescript = { 'deno_fmt', 'prettierd', stop_after_first = true },
        javascriptreact = { 'deno_fmt', 'prettierd', stop_after_first = true },
        typescriptreact = { 'deno_fmt', 'prettierd', stop_after_first = true },
        ['javascript.tsx'] = { 'deno_fmt', 'prettierd', stop_after_first = true },
        ['typescript.tsx'] = { 'deno_fmt', 'prettierd', stop_after_first = true },
        python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
      },
      format_on_save = function(buf)
        if not Constants.autoformat then return end
        if vim.tbl_contains({ 'sql' }, vim.bo[buf].filetype) then return end
        if vim.api.nvim_buf_get_name(buf):match('/node_modules/') then return end

        return {
          timeout_ms = 3000,
          async = false,
          quiet = false,
          lsp_format = 'fallback',
        }
      end,
      formatters = {
        rustfmt = { default_edition = '2021' },
        injected = { ignore_errors = true },
        prettierd = { condition = function(_, ctx) return is_web_project(ctx) or is_json_or_markdown(ctx) end },
        deno_fmt = {
          condition = function(_, ctx)
            return vim.fs.find({ 'deno.json', 'deno.jsonc' }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    }
  end,
}
