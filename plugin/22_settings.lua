Utils.Req('tree-sitter')
Utils.Req('zoxide')
Utils.Req('ruff')
Utils.Req('prettierd')
Utils.Req('stylua')

local capabilities = Utils.lsp_capabilities()
local servers = Utils.lsp_get_servers()
local path = vim.fn.stdpath('config') .. '/anthropic'
local file = io.open(path, 'r')
local key

if file then
  key = file:read('*a'):gsub('%s+$', '')
  file:close()
  if not key then vim.notify('An `anthropic` key must be set for a proper config setup', vim.log.levels.ERROR) end
end

vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

require('snacks').setup({
  bigfile = { size = 1 * 1024 * 1024 },
  quickfile = { exclude = { 'latex' } },
  indent = { enabled = false },
  input = { enabled = true },
  notifier = { enabled = true },
  picker = {
    formatters = {
      file = {
        filename_first = true,
      },
    },
  },
  scratch = { ft = function() return 'markdown' end },
  scope = { enabled = true },
  statuscolumn = { enabled = true },
})

require('mini.colors').get_colorscheme():add_transparency({ float = true }):apply()
require('mini.icons').setup()
require('mini.doc').setup()
require('mini.align').setup()
require('mini.surround').setup()
require('mini.splitjoin').setup()
require('mini.operators').setup()
require('mini.diff').setup({ view = { style = 'sign' } })
require('csvview').setup()
require('contextindent').setup()

require('nvim-treesitter.configs').setup({
  highlight = { enable = true },
  indent = { enable = true, disable = { 'yaml' } },
  sync_install = false,
  auto_install = true,
  ensure_installed = Utils.get_parsers(),
})

require('mini.files').setup({
  mappings = {
    show_help = '?',
    go_in = '',
    go_out = '',
    go_in_plus = '<cr>',
    go_out_plus = '-',
  },
  windows = {
    preview = true,
    width_preview = 80,
  },
})

require('mini.ai').setup({
  n_lines = 300,
  custom_textobjects = {
    f = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
    g = function()
      local from = { line = 1, col = 1 }
      local to = { line = vim.fn.line('$'), col = math.max(vim.fn.getline('$'):len(), 1) }
      return { from = from, to = to }
    end,
  },
})

require('conform').setup({
  notify_on_error = true,
  formatters = { injected = { ignore_errors = true } },
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = { 'prettierd' },
    javascriptreact = { 'prettierd' },
    typescript = { 'prettierd' },
    typescriptreact = { 'prettierd' },
    json = { 'prettierd' },
    jsonc = { 'prettierd' },
    markdown = { 'prettierd', 'injected' },
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
  },
  format_on_save = {
    timeout_ms = 3000,
    async = false,
    quiet = false,
    lsp_format = 'fallback',
  },
})

require('iron.core').setup({
  config = {
    scratch_repl = true,
    repl_definition = {
      sh = { command = { 'bash' } },
      python = {
        command = { 'uv', 'run', 'python' },
        format = require('iron.fts.common').bracketed_paste_python,
      },
    },
    repl_open_cmd = require('iron.view').right(80),
  },
  highlight = { italic = true },
  ignore_blank_lines = false,
  keymaps = {
    send_motion = '<Leader>is',
    visual_send = '<Leader>is',
    send_file = '<Leader>if',
    send_line = '<Leader>il',
    send_paragraph = '<Leader>ip',
    send_until_cursor = '<Leader>iu',
    send_mark = '<Leader>im',
    mark_motion = '<Leader>ic',
    mark_visual = '<Leader>ic',
    remove_mark = '<Leader>id',
    cr = '<Leader>i<CR>',
    interrupt = '<Leader>i<Space>',
    exit = '<Leader>iq',
    clear = '<Leader>ix',
  },
})

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
  keymap = {
    preset = 'default',
    ['<C-n>'] = { 'select_next' },
    ['<C-p>'] = { 'select_prev' },
    ['<Tab>'] = { 'select_next' },
    ['<S-Tab>'] = { 'select_prev' },
    cmdline = {
      ['<C-n>'] = { 'show', 'select_next' },
      ['<C-p>'] = { 'select_prev' },
      ['<Tab>'] = { 'select_next' },
      ['<S-Tab>'] = { 'select_prev' },
    },
  },
  completion = {
    ghost_text = { enabled = false },
    trigger = { show_on_insert_on_trigger_character = false },
    keyword = { range = 'full' },
    accept = { auto_brackets = { enabled = false } },
    list = {
      selection = {
        preselect = function(ctx) return ctx.mode ~= 'cmdline' end,
        auto_insert = function(ctx) return ctx.mode == 'cmdline' end,
      },
    },
    menu = {
      border = 'rounded',
      scrollbar = false,
      draw = {
        treesitter = { 'lsp' },
        columns = { { 'kind_icon' }, { 'label', gap = 1 } },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
      window = {
        border = 'rounded',
        scrollbar = false,
      },
    },
  },
  sources = {
    transform_items = function(_, items)
      return vim.tbl_filter(
        function(item) return item.kind ~= require('blink.cmp.types').CompletionItemKind.Snippet end,
        items
      )
    end,
  },
  signature = {
    enabled = true,
    window = { border = 'rounded' },
  },
})

require('codecompanion').setup({
  strategies = {
    chat = {
      adapter = 'anthropic',
      keymaps = {
        completion = {
          modes = {
            i = '<C-t>',
          },
          index = 1,
          callback = 'keymaps.completion',
          description = 'Completion Menu',
        },
      },
    },
    inline = { adapter = 'anthropic' },
    cmd = { adapter = 'anthropic' },
  },
  adapters = {
    anthropic = require('codecompanion.adapters').extend('anthropic', {
      env = { api_key = key },
      schema = {
        model = {
          default = 'claude-3-5-haiku-20241022',
        },
      },
    }),
  },
})

require('dap-view').setup()
require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })

require('dap.ext.vscode').json_decode = function(data)
  local decode = vim.json.decode
  local strip_comments = require('plenary.json').json_strip_comments
  data = strip_comments(data)

  return decode(data)
end

require('dap-python').setup('uv')

for server, config in pairs(servers) do
  config = config or {}
  local opts = { capabilities = capabilities }
  config = vim.tbl_deep_extend('force', config, opts)
  require('lspconfig')[server].setup(config)
end

local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },

    -- Registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
  },
  clues = {
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),

    { mode = 'n', keys = '<Leader>b', desc = '+Buffers' },
    { mode = 'n', keys = '<Leader>c', desc = '+Code' },
    { mode = 'n', keys = '<Leader>d', desc = '+DAP' },
    { mode = 'n', keys = '<Leader>f', desc = '+Files' },
    { mode = 'n', keys = '<Leader>g', desc = '+Git' },
    { mode = 'n', keys = '<Leader>i', desc = '+Iron' },
    { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
    { mode = 'n', keys = '<Leader>u', desc = '+Toggle' },

    { mode = 'x', keys = '<Leader>c', desc = '+Code' },
    { mode = 'x', keys = '<Leader>f', desc = '+Files' },
    { mode = 'x', keys = '<Leader>g', desc = '+Git' },
    { mode = 'x', keys = '<Leader>i', desc = '+Iron' },
  },
  window = {
    config = {
      width = 'auto',
    },
    delay = 200,
    scroll_down = '<C-f>',
    scroll_up = '<C-b>',
  },
})
