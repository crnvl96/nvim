local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local Set, S, LSM = Config.Set, Config.S, Config.LSM

add({ name = 'mini.nvim' })

now(function() vim.cmd('colorscheme minigrey') end)

later(function() require('mini.extra').setup() end)
later(function() require('mini.indentscope').setup() end)
later(function() require('mini.doc').setup() end)
later(function() require('mini.align').setup() end)
later(function() require('mini.operators').setup() end)
later(function() require('mini.visits').setup() end)

later(function()
  require('mini.pick').setup()
  vim.ui.select = MiniPick.ui_select
end)

now(function() add({ source = 'nvim-lua/plenary.nvim' }) end)
later(function() add({ source = 'lambdalisue/vim-suda' }) end)
later(function() add({ source = 'HakonHarnes/img-clip.nvim' }) end)

later(function()
  add({ source = 'hat0uma/csvview.nvim' })
  require('csvview').setup()
end)

now(function()
  local function filter(el) return not vim.startswith(el.msg, 'lua_ls: Diagnosing') end
  local function sort(list)
    list = vim.tbl_filter(filter, list)
    return MiniNotify.default_sort(list)
  end

  require('mini.notify').setup({ content = { sort = sort } })
  vim.notify = MiniNotify.make_notify()
  S('nh', 'lua MiniNotify.show_history()', '[N]otification [H]istory')
end)

now(function() require('mini.misc').setup_termbg_sync() end)

now(function()
  require('mini.icons').setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
    end,
  })

  MiniIcons.mock_nvim_web_devicons()
  later(MiniIcons.tweak_lsp_kind)
end)

later(function()
  S('ba', 'b#', '[B]uffer [A]lternate')
  S('bd', 'bd', '[B]uffer [D]elete')
  S('xt', 'lua Config.toggle_quickfix()', 'Quickfi[x] [T]oggle')

  function Config.on_attach_maps(buf)
    LSM(buf, 'la', 'lua vim.lsp.buf.code_action()', '[L]SP Code [A]ction')
    LSM(buf, 'le', 'lua vim.lsp.buf.hover({border="single"})', '[L]SP [E]val')
    LSM(buf, 'lh', 'lua vim.lsp.buf.signature_help({border="single"})', '[L]SP Signature [H]elp')
    LSM(buf, 'lj', 'lua vim.diagnostic.goto_next()', 'lsp: next diagnostic')
    LSM(buf, 'lk', 'lua vim.diagnostic.goto_prev()', 'lsp: prev diagnostic')
    LSM(buf, 'll', 'lua vim.diagnostic.open_float({boder="single"})', 'lsp: diagnostics popup')
    LSM(buf, 'ln', 'lua vim.lsp.buf.rename()', 'lsp: rename symbol under cursor')
    LSM(buf, 'lx', 'lua vim.lsp.diagnostic.setqflist()', 'lsp: populate qf list with diagnocsits')
    LSM(buf, 'lc', 'lua vim.lsp.buf.declaration()', 'lsp: declaration')
    LSM(buf, 'ld', 'lua vim.lsp.buf.definition()', 'lsp: definition')
    LSM(buf, 'li', 'lua vim.lsp.buf.implementation()', 'lsp: implementation')
    LSM(buf, 'lr', 'lua vim.lsp.buf.references()', 'lsp: references')
    LSM(buf, 'ls', 'lua vim.lsp.buf.document_symbol()', 'lsp: document symbol')
    LSM(buf, 'lS', 'lua vim.lsp.buf.workspace_symbol()', 'lsp: workspace symbol')
    LSM(buf, 'ly', 'lua vim.lsp.buf.type_definition()', 'lsp: type definition')
  end

  local register_capability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
  vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then return end
    Config.on_attach(client, vim.api.nvim_get_current_buf())
    return register_capability(err, res, ctx)
  end

  vim.diagnostic.config({
    float = { border = 'single' },
    signs = { priority = 9999, severity = { min = 'WARN', max = 'ERROR' } },
    virtual_text = { severity = { min = 'ERROR', max = 'ERROR' } },
    update_in_insert = false,
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('crnvl96-on-lsp-attach', { clear = true }),
    callback = function(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)
      if not client then return end
      Config.on_attach(client, e.buf)
    end,
  })
end)

later(function()
  require('mini.diff').setup({
    view = { style = 'sign' },
  })
end)

later(function()
  local miniclue = require('mini.clue')

  miniclue.setup({
    clues = {
      { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
      { mode = 'n', keys = '<Leader>d', desc = '+Debug' },
      { mode = 'n', keys = '<Leader>f', desc = '+Files' },
      { mode = 'n', keys = '<Leader>g', desc = '+Git' },
      { mode = 'x', keys = '<Leader>g', desc = '+Git' },
      { mode = 'n', keys = '<Leader>i', desc = '+IA' },
      { mode = 'x', keys = '<Leader>i', desc = '+IA' },
      { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
      { mode = 'n', keys = '<Leader>n', desc = '+Notification' },
      { mode = 'n', keys = '<Leader>x', desc = '+List' },

      { mode = 'n', keys = '<Leader>wj', postkeys = '<Leader>w', desc = 'Down' },
      { mode = 'n', keys = '<Leader>wk', postkeys = '<Leader>w', desc = 'Up' },
      { mode = 'n', keys = '<Leader>wh', postkeys = '<Leader>w', desc = 'Left' },
      { mode = 'n', keys = '<Leader>wl', postkeys = '<Leader>w', desc = 'Right' },

      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },
    triggers = {
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = '<Localleader>' },
      { mode = 'x', keys = '<Localleader>' },
      { mode = 'n', keys = [[\]] },
      { mode = 'n', keys = '[' },
      { mode = 'x', keys = '[' },
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' },
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },
      { mode = 'x', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },
    window = { delay = 200, config = { width = 'auto' } },
  })
end)

later(function()
  local minifiles = require('mini.files')

  minifiles.setup({
    mappings = {
      go_in = '',
      go_in_plus = '<CR>',
      go_out = '',
      go_out_plus = '-',
    },
    windows = { width_nofocus = 25, preview = true, width_preview = 50 },
    options = { permanent_delete = false },
  })

  Set('n', '-', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>')
end)

later(function()
  add({ source = 'mfussenegger/nvim-lint' })

  ---@class LinterConfig
  ---@field cond? fun(buf: number): boolean
  ---@field linters string[]

  --- Returns a list of linters grouped by the filetype they should run on
  ---@return table<string, LinterConfig>
  local function linters_by_ft()
    return {
      lua = {
        cond = function(buf) return vim.fs.root(buf, { 'selene.toml' }) ~= nil end,
        linters = { 'selene' },
      },
      python = { linters = { 'ruff' } },
      javascript = { linters = { 'eslint_d' } },
      typescript = { linters = { 'eslint_d' } },
      javascriptreact = { linters = { 'eslint_d' } },
      typescriptreact = { linters = { 'eslint_d' } },
      ['javascript.tsx'] = { linters = { 'eslint_d' } },
      ['typescript.tsx'] = { linters = { 'eslint_d' } },
    }
  end

  local linters = linters_by_ft()

  vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
    group = vim.api.nvim_create_augroup('crnvl96-nvim-lint', { clear = true }),
    callback = function(e)
      local buf = e.buf
      local ft = vim.bo[buf].filetype
      local conf = linters[ft]

      if conf and (not conf.cond or conf.cond(buf)) then require('lint').try_lint(conf.linters) end
    end,
  })
end)

later(function()
  add({ source = 'tpope/vim-fugitive' })

  S('ga', 'Git commit --amend', '[G]it [A]mend Commit')
  S('gc', 'Git commit', '[G]it [C]ommit')
  S('gh', 'Git diff --cached', '[G]it Diff cac[h]ed')
  S('gd', 'Git diff', '[G]it [D]iff')
  S('gl', 'Git log --pretty=format:\\%h\\ \\%as\\ │\\ \\%s --topo-order --follow -- %', '[G]it [L]og (buffer)')
  S('gL', 'Git log --pretty=format:\\%h\\ \\%as\\ │\\ \\%s --topo-order -256', '[G]it [L]og')
  S('go', 'lua MiniDiff.toggle_overlay()', '[G]it Toggle [O]verlay')
  S('gs', 'Git', '[G]it [S]tatus')
  S('gx', 'lua vim.fn.setqflist(MiniDiff.export("qf"))', '[G]it E[x]port (QF)')
end)

later(function()
  add({
    source = 'iamcco/markdown-preview.nvim',
    hooks = {
      post_checkout = function()
        later(function() vim.fn['mkdp#util#install']() end)
      end,
      post_install = function()
        later(function() vim.fn['mkdp#util#install']() end)
      end,
    },
  })

  vim.g.mkdp_filetypes = { 'markdown', 'md' }
end)

later(function()
  add({
    source = 'williamboman/mason.nvim',
    hooks = { post_checkout = function() vim.cmd('MasonUpdate') end },
  })

  require('mason').setup()

  later(function()
    local mr = require('mason-registry')

    mr.refresh(function()
      for _, tool in ipairs(Mason_tools) do
        local p = mr.get_package(tool)
        if not p:is_installed() then p:install() end
      end
    end)
  end)
end)

later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })

  require('nvim-treesitter.configs').setup({
    highlight = { enable = true },
    indent = {
      enable = true,
    },
    sync_install = false,
    auto_install = true,
    ensure_installed = Treesitter_parsers,
  })
end)

later(function()
  add({
    source = 'junegunn/fzf',
    hooks = {
      post_checkout = function()
        later(function() vim.fn['fzf#install']() end)
      end,
      post_install = function()
        later(function() vim.fn['fzf#install']() end)
      end,
    },
  })

  add({ source = 'kevinhwang91/nvim-bqf' })

  require('bqf').setup({
    auto_enable = true,
    auto_resize_height = false,
    preview = {
      win_height = 20,
      win_vheight = 20,
      delay_syntax = 80,
      border = 'single',
      show_title = false,
      should_preview_cb = function(bufnr)
        local ret = true
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local fsize = vim.fn.getfsize(bufname)
        if fsize > 100 * 1024 then
          -- skip file size greater than 100k
          ret = false
        elseif bufname:match('^fugitive://') then
          -- skip fugitive buffer
          ret = false
        end
        return ret
      end,
    },
    filter = {
      fzf = {
        action_for = { ['ctrl-s'] = 'split', ['ctrl-t'] = 'tab drop' },
        extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ', '--delimiter', '│' },
      },
    },
  })
end)

later(function()
  add({ source = 'aaronik/treewalker.nvim' })

  require('treewalker').setup({
    highlight = true,
    highlight_duration = 250,
    highlight_group = 'CursorLine',
  })

  S('wj', 'Treewalker Down', 'Down (Treewalker)')
  S('wk', 'Treewalker Up', 'Up (Treewalker)')
  S('wh', 'Treewalker Left', 'Left (Treewalker)')
  S('wl', 'Treewalker Right', 'Right (Treewalker)')
end)

later(function()
  add({ source = 'saghen/blink.compat' })

  add({
    source = 'Saghen/blink.cmp',
    hooks = {
      post_checkout = function(params) Config.build(params, { 'cargo', 'build', '--release' }) end,
      post_install = function(params) Config.build(params, { 'cargo', 'build', '--release' }) end,
    },
  })

  require('blink.compat').setup()

  require('blink.cmp').setup({
    enabled = function()
      return not vim.tbl_contains({ 'minifiles', 'markdown', 'deck' }, vim.bo.filetype)
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
        border = 'single',
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
          border = 'single',
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

      default = { 'lsp', 'path', 'buffer' },
      per_filetype = {
        codecompanion = { 'path' },
      },
    },
    signature = {
      enabled = true,
      window = { border = 'single' },
    },
  })

  vim.opt.completeopt:append('fuzzy')
  vim.opt.wildoptions:append('fuzzy')
end)

now(function()
  add({ source = 'olimorris/codecompanion.nvim' })

  --- Retrieve a LLM (in this case, from anthropic) from a local file, and returns it
  --- to be integrated with relevant plugins.
  ---
  --- This is done this way to avoid exposing the private key in the running shell session via environment keys.
  ---@return string?
  local function retrieve_llm_key()
    ---@type string
    local path = vim.fn.stdpath('config') .. '/anthropic'
    ---@type file*?
    local file = io.open(path, 'r')
    ---@type string?
    local key

    if file then
      ---@type string?
      key = file:read('*a'):gsub('%s+$', '')
      file:close()
    end

    return key or nil
  end

  local key = retrieve_llm_key()

  if not key then
    vim.notify('An `anthropic` key must be set for a proper config setup', vim.log.levels.ERROR)
    return
  end

  require('codecompanion').setup({
    strategies = {
      chat = { adapter = 'anthropic' },
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

  S('ic', 'CodeCompanionChat Add', 'A[I] Add to [C]hat Buffer', 'x')
  S('it', 'CodeCompanionChat Toggle', 'A[I] [T]oggle Chat Buffer')
  S('ia', 'CodeCompanionActions', 'A[I] Show [A]ctions')
end)

later(function()
  add({ source = 'stevearc/conform.nvim' })

  require('conform').setup({
    notify_on_error = true,
    formatters_by_ft = Formatters.by_ft,
    formatters = Formatters.specs,
  })

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

  vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function(e)
      require('conform').format({
        bufnr = e.buf,
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = 'fallback',
      })
    end,
  })
end)

later(function()
  add({ source = 'neovim/nvim-lspconfig' })

  local ok = pcall(require, 'blink.cmp')
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  if not ok then
    vim.notify('blink.cmp must be installed to have access to full capabilities.', vim.log.levels.ERROR)
  end

  capabilities = require('blink.cmp').get_lsp_capabilities(vim.tbl_deep_extend('force', capabilities, {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false,
        },
      },
    },
  }))

  for server, config in pairs(Servers) do
    config = vim.tbl_deep_extend('force', config or {}, { capabilities = capabilities })
    require('lspconfig')[server].setup(config)
  end
end)

later(function()
  add({ source = 'theHamsta/nvim-dap-virtual-text' })
  add({ source = 'mfussenegger/nvim-dap' })

  vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })
  require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })

  local function json_decode(data)
    local decode = vim.json.decode
    local strip_comments = require('plenary.json').json_strip_comments
    data = strip_comments(data)

    return decode(data)
  end

  require('dap.ext.vscode').json_decode = json_decode

  Debuggers_by_ft()

  local cmd = 'lua require("dap.ui.widgets").sidebar(require("dap.ui.widgets").scopes, {}, "vsplit").toggle()'

  S('dc', 'lua require("dap").clear_breakpoints()', '[D]ap Clear')
  S('db', 'lua require("dap").toggle_breakpoint()', '[D]ap Breakpoint')
  S('du', 'lua require("dap").run_to_cursor()', '[D]ap run to [C]ursor')
  S('dr', 'lua require("dap").continue()', '[D]ap [R]un execution')
  S('de', 'lua require("dap.ui.widgets").hover()', '[D]ap [E]val')
  S('dR', 'lua require("dap.repl").toggle({}, "belowright split")', '[D]ap [R]epl')
  S('ds', cmd, '[D]ap [S]copes')
  S('dt', 'lua require("dap").terminate()', '[D]ap [T]erminate')
end)

later(function()
  add({ source = 'kevinhwang91/promise-async' })
  add({ source = 'chrisgrieser/nvim-origami' })
  add({ source = 'kevinhwang91/nvim-ufo' })

  require('origami').setup({
    keepFoldsAcrossSessions = false,
  })

  require('ufo').setup({
    provider_selector = function(_, ft, _)
      local lspWithOutFolding = { 'markdown', 'sh', 'css', 'html', 'python' }
      if vim.tbl_contains(lspWithOutFolding, ft) then return { 'treesitter', 'indent' } end
      return { 'lsp', 'indent' }
    end,
    open_fold_hl_timeout = 800,
  })
end)

later(function()
  add({ source = 'hrsh7th/nvim-deck' })

  local deck = require('deck')

  vim.api.nvim_create_autocmd('User', {
    pattern = 'DeckStart',
    callback = function(e)
      local ctx = e.data.ctx

      ctx.keymap('n', '<CR>', deck.action_mapping('default'))
      ctx.keymap('n', '<Tab>', deck.action_mapping('choose_action'))
      ctx.keymap('n', '<C-l>', deck.action_mapping('refresh'))
      ctx.keymap('n', 'i', deck.action_mapping('prompt'))
      ctx.keymap('n', 'a', deck.action_mapping('prompt'))
      ctx.keymap('n', '@', deck.action_mapping('toggle_select'))
      ctx.keymap('n', '*', deck.action_mapping('toggle_select_all'))
      ctx.keymap('n', 'p', deck.action_mapping('toggle_preview_mode'))
      ctx.keymap('n', 'q', function() ctx.hide() end)

      ctx.keymap('n', 's', deck.action_mapping('open_split'))
      ctx.keymap('n', 'v', deck.action_mapping('open_vsplit'))

      ctx.keymap('n', '<C-u>', deck.action_mapping('scroll_preview_up'))
      ctx.keymap('n', '<C-d>', deck.action_mapping('scroll_preview_down'))

      if ctx.name == 'buf_lines' then ctx.keymap('n', '<CR>', deck.action_mapping('goto_line')) end
    end,
  })

  function _G.files()
    deck.start({
      require('deck.builtin.source.files')({
        root_dir = vim.fn.getcwd(),
        ignore_globs = {
          '**/node_modules/**',
          '**/.git/**',
        },
      }),
    })
  end

  function _G.oldfiles()
    deck.start({
      require('deck.builtin.source.recent_files')(),
    })
  end

  function _G.buffers()
    deck.start({
      require('deck.builtin.source.buffers')(),
    })
  end

  function _G.grep()
    local pattern = vim.fn.input('grep: ')
    if #pattern == 0 then return vim.notify('Canceled', vim.log.levels.INFO) end
    deck.start(require('deck.builtin.source.grep')({
      pattern = pattern,
      root_dir = vim.fn.getcwd(),
      ignore_globs = {
        '**/node_modules/**',
        '**/.git/**',
      },
    }))
  end

  function _G.helpgrep() deck.start(require('deck.builtin.source.helpgrep')()) end

  function _G.buflines()
    local win = vim.api.nvim_get_current_win()
    local bufnr = vim.api.nvim_get_current_buf()

    require('deck').start({
      name = 'buf_lines',
      execute = function(ctx)
        for lnum, l in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
          ctx.item({ display_text = l, bufnr = bufnr, lnum = lnum })
        end

        ctx.done()
      end,
      actions = {
        {
          name = 'goto_line',
          resolve = function(ctx) return #ctx.get_action_items() > 0 end,
          execute = function(ctx)
            local item = ctx.get_cursor_item()

            local lnum = item.lnum

            pcall(vim.api.nvim_set_current_win, win)
            pcall(vim.api.nvim_win_set_cursor, win, { lnum or 1, 0 })

            ctx.hide()
          end,
        },
      },
    })
  end

  S('fl', 'lua _G.buflines()', '[F]ind Buf[l]ines')
  S('fb', 'lua _G.buffers()', '[F]ind [B]uffers')
  S('ff', 'lua _G.files()', '[F]ind [F]iles')
  S('fo', 'lua _G.oldfiles()', '[F]ind [O]ld Files')
  S('fg', 'lua _G.grep()', '[F]ind [G]rep')
  S('fh', 'lua _G.helpgrep()', '[F]ind [H]elp')
end)
