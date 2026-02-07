MiniDeps.now(function()
  MiniDeps.add('sainnhe/gruvbox-material')

  vim.g.gruvbox_material_background = 'hard'
  vim.g.gruvbox_material_enable_bold = 1
  vim.g.gruvbox_material_enable_italic = 1
  vim.g.gruvbox_material_better_performance = 1

  vim.cmd.colorscheme('gruvbox-material')
end)

MiniDeps.later(function()
  MiniDeps.add('nvim-lualine/lualine.nvim')
  require('lualine').setup()
end)

MiniDeps.later(function() MiniDeps.add('tpope/vim-fugitive') end)

MiniDeps.later(function()
  local build = function(args)
    MiniMisc.put('Building dependencies of markdown-preview.nvim')
    local cmd = { 'npm', 'install', '--prefix', string.format('%s/app', args.path) }
    local obj = vim.system(cmd, { text = true }):wait()
    if obj.code ~= 0 then
      MiniMisc.put('An error occurred while building dependencies of markdown-preview.nvim')
    else
      vim.print(vim.inspect(obj))
    end
  end

  MiniDeps.add({
    source = 'iamcco/markdown-preview.nvim',
    hooks = {
      post_install = function(args)
        MiniDeps.later(function() build(args) end)
      end,
      post_checkout = function(args)
        MiniDeps.later(function() build(args) end)
      end,
    },
  })
end)

MiniDeps.later(function()
  MiniDeps.add('ibhagwan/fzf-lua')

  require('fzf-lua').setup({
    { 'border-fused', 'hide' },
    fzf_colors = {
      bg = { 'bg', 'Normal' },
      gutter = { 'bg', 'Normal' },
      info = { 'fg', 'Conditional' },
      scrollbar = { 'bg', 'Normal' },
      separator = { 'fg', 'Comment' },
    },
    fzf_opts = {
      ['--info'] = 'default',
      ['--layout'] = 'reverse-list',
    },
    keymap = {
      builtin = {
        ['<M-Esc>'] = 'hide',
        ['<C-/>'] = 'toggle-help',
        ['<C-i>'] = 'toggle-preview',
        ['<C-g>'] = 'preview-reset',
        ['<C-f>'] = 'preview-page-down',
        ['<C-b>'] = 'preview-page-up',
        ['<C-d>'] = 'preview-down',
        ['<C-u>'] = 'preview-up',
      },
      fzf = {
        ['ctrl-z'] = 'abort',
        ['ctrl-u'] = 'unix-line-discard',
        ['ctrl-d'] = 'half-page-down',
        ['ctrl-D'] = 'half-page-up',
        ['ctrl-a'] = 'beginning-of-line',
        ['ctrl-e'] = 'end-of-line',
        ['alt-a'] = 'toggle-all',
        ['alt-d'] = 'toggle+down',
        ['alt-u'] = 'toggle+up',
        ['alt-g'] = 'first',
        ['alt-G'] = 'last',
        ['ctrl-i'] = 'toggle-preview',
        ['ctrl-f'] = 'preview-page-down',
        ['ctrl-b'] = 'preview-page-up',
      },
    },
    winopts = {
      height = 0.85,
      width = 0.80,
      row = 0.50,
      preview = {
        hidden = true,
        scrollbar = false,
        layout = 'vertical',
        vertical = 'down:65%',
      },
    },
  })

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(items, opts, on_choice)
    local ui_select = require('fzf-lua.providers.ui_select')

    if not ui_select.is_registered() then
      ui_select.register(function(ui_opts)
        ui_opts.winopts = {
          width = 70,
          height = 20,
          relative = 'cursor',
        }
        if ui_opts.kind then ui_opts.winopts.title = string.format(' %s ', ui_opts.kind) end
        if ui_opts.prompt and not vim.endswith(ui_opts.prompt, ' ') then ui_opts.prompt = ui_opts.prompt .. ' ' end
        return ui_opts
      end)
    end
    if #items > 0 then return vim.ui.select(items, opts, on_choice) end
  end

  vim.keymap.set('n', '<leader>fl', function()
    local opts = {
      winopts = {
        height = 0.85,
        width = 0.5,
        preview = {
          hidden = true,
        },
        treesitter = {
          enabled = false,
          fzf_colors = {
            ['fg'] = { 'fg', 'CursorLine' },
            ['bg'] = { 'bg', 'Normal' },
          },
        },
      },
      fzf_opts = {
        ['--layout'] = 'reverse',
      },
    }
    -- Use grep when in normal mode and blines in visual mode since the former doesn't support
    -- searching inside visual selections.
    -- See https://github.com/ibhagwan/fzf-lua/issues/2051
    local mode = vim.api.nvim_get_mode().mode
    if vim.startswith(mode, 'n') then
      require('fzf-lua').lgrep_curbuf(opts)
    else
      require('fzf-lua').blines(opts)
    end
  end)
  vim.keymap.set('n', '<leader>fb', function() require('fzf-lua').buffers() end)
  vim.keymap.set('n', '<leader>fH', function() require('fzf-lua').highlights() end)
  vim.keymap.set('n', '<leader>fx', function() require('fzf-lua').lsp_document_diagnostics() end)
  vim.keymap.set('n', '<leader>ff', function() require('fzf-lua').files() end)
  vim.keymap.set('n', '<leader>fg', function() require('fzf-lua').live_grep() end)
  vim.keymap.set('x', '<leader>fg', function() require('fzf-lua').grep_visual() end)
  vim.keymap.set('n', '<leader>fh', function() require('fzf-lua').help_tags() end)
  vim.keymap.set('n', '<leader>fo', function() require('fzf-lua').oldfiles() end)
  vim.keymap.set('n', '<leader>fk', function() require('fzf-lua').keymaps() end)
  vim.keymap.set('n', '<leader>fr', function() require('fzf-lua').resume() end)
  vim.keymap.set(
    'i',
    '<C-x><C-f>',
    function()
      require('fzf-lua').complete_path({
        winopts = {
          height = 0.4,
          width = 0.5,
          relative = 'cursor',
        },
      })
    end
  )

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('crnvl96-on-lspattach-fzf-maps', { clear = true }),
    callback = function(e)
      local client = vim.lsp.get_client_by_id(e.data.client_id)

      if not client then return end

      if client:supports_method('textDocument/references') then
        vim.keymap.set('n', 'grr', function() require('fzf-lua').lsp_references() end, { buffer = e.buf })
      end

      if client:supports_method('textDocument/codeAction') then
        vim.keymap.set(
          'n',
          'gra',
          function()
            require('fzf-lua').lsp_code_actions({
              winopts = {
                width = 70,
                height = 20,
                relative = 'cursor',
              },
            })
          end,
          { buffer = e.buf }
        )
      end

      if client:supports_method('textDocument/typeDefinition') then
        vim.keymap.set('n', 'grt', function() require('fzf-lua').lsp_typedefs() end, { buffer = e.buf })
      end

      if client:supports_method('textDocument/implementation') then
        vim.keymap.set('n', 'gri', function() require('fzf-lua').lsp_implementations() end, { buffer = e.buf })
      end

      if client:supports_method('textDocument/documentSymbol') then
        vim.keymap.set('n', 'gO', function() require('fzf-lua').lsp_document_symbols() end, { buffer = e.buf })
      end

      if client:supports_method('workspace/symbol') then
        vim.keymap.set('n', 'grs', function() require('fzf-lua').lsp_workspace_symbols() end, { buffer = e.buf })
      end

      if client:supports_method('textDocument/definition') then
        vim.keymap.set(
          'n',
          'gd',
          function() require('fzf-lua').lsp_definitions({ jump1 = true }) end,
          { buffer = e.buf }
        )
        vim.keymap.set(
          'n',
          'gD',
          function() require('fzf-lua').lsp_definitions({ jump1 = false }) end,
          { buffer = e.buf }
        )
      end
    end,
  })
end)
