require('blink.compat').setup()

require('blink.cmp').setup({
  enabled = function()
    return not vim.tbl_contains({ 'minifiles', 'markdown' }, vim.bo.filetype)
      and vim.bo.buftype ~= 'prompt'
      and vim.b.completion ~= false
  end,
  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = 'mono',
  },
  completion = {
    list = {
      selection = function(ctx) return ctx.mode == 'cmdline' and 'auto_insert' or 'preselect' end,
    },
    trigger = {
      show_on_insert_on_trigger_character = false,
    },
    accept = {
      auto_brackets = { enabled = false },
    },
    menu = {
      border = 'double',
      draw = {
        treesitter = { 'lsp' },
        components = {
          kind_icon = {
            ellipsis = false,
            text = function(ctx)
              local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
              return kind_icon
            end,
            highlight = function(ctx)
              local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
              return hl
            end,
          },
        },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = {
        border = 'double',
      },
    },
    ghost_text = { enabled = false },
  },
  signature = {
    enabled = true,
    window = {
      border = 'double',
    },
  },
  sources = {
    default = function()
      local success, node = pcall(vim.treesitter.get_node)
      local src = { 'lsp', 'path', 'snippets', 'buffer' }

      if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
        return { 'buffer' }
      else
        return src
      end
    end,
    per_filetype = {
      codecompanion = { 'codecompanion', 'path' },
    },
    providers = {
      codecompanion = {
        name = 'CodeCompanion',
        module = 'codecompanion.providers.completion.blink',
        enabled = true,
      },
    },
  },
})
