MiniDeps.now(function()
  MiniDeps.add('folke/tokyonight.nvim')
  vim.cmd.colorscheme('tokyonight-storm')
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
  MiniDeps.add('stevearc/oil.nvim')

  require('oil').setup({
    default_file_explorer = true,
    columns = {
      'icon',
      'permissions',
      'size',
      'mtime',
    },
    watch_for_changes = true,
    keymaps = {
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<CR>'] = 'actions.select',
      ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
      ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
      ['<C-t>'] = { 'actions.select', opts = { tab = true } },
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = { 'actions.close', mode = 'n' },
      ['<C-l>'] = 'actions.refresh',
      ['-'] = { 'actions.parent', mode = 'n' },
      ['_'] = { 'actions.open_cwd', mode = 'n' },
      ['`'] = { 'actions.cd', mode = 'n' },
      ['g~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
      ['gs'] = { 'actions.change_sort', mode = 'n' },
      ['gx'] = 'actions.open_external',
      ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
      ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
    },
    view_options = {
      show_hidden = true,
    },
  })

  vim.keymap.set('n', '<leader>ef', '<Cmd>Oil<CR>', { desc = 'Open file explorer at current file path' })
end)

MiniDeps.later(function()
  MiniDeps.add('folke/which-key.nvim')

  require('which-key').setup({
    preset = 'helix',
    delay = 1000,
    spec = {},
    triggers = {
      { '<auto>', mode = 'nixsotc' },
      { 'a', mode = { 'n', 'v' } },
    },
    defer = function(ctx)
      if vim.list_contains({ 'd', 'y' }, ctx.operator) then return true end
      return vim.list_contains({ '<C-V>', 'V' }, ctx.mode)
    end,
    win = {
      title = false,
    },
    icons = {
      mappings = false,
    },
    show_help = false,
    show_keys = false,
  })
end)

MiniDeps.later(function()
  MiniDeps.add('ibhagwan/fzf-lua')

  require('fzf-lua').register_ui_select({
    winopts = {
      width = 70,
      height = 20,
      relative = 'cursor',
    },
  })

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
    winopts = {
      split = 'belowright new',
      -- "belowright new"  : split below
      -- "aboveleft new"   : split above
      -- "belowright vnew" : split right
      -- "aboveleft vnew   : split left
      height = 0.85,
      width = 0.80,
      row = 0.50,
      preview = {
        hidden = true,
        scrollbar = false,
        layout = 'horizontal',
        vertical = 'right:60%',
      },
    },
    keymap = {
      builtin = {
        ['<M-Esc>'] = 'hide',
        ['<C-/>'] = 'toggle-help',
        ['<C-i>'] = 'toggle-preview',
        ['<S-Left>'] = 'preview-reset',
        ['<S-down>'] = 'preview-page-down',
        ['<S-up>'] = 'preview-page-up',
        ['<M-S-down>'] = 'preview-down',
        ['<M-S-up>'] = 'preview-up',
      },
      fzf = {
        ['ctrl-z'] = 'abort',
        ['ctrl-u'] = 'unix-line-discard',
        ['ctrl-f'] = 'half-page-down',
        ['ctrl-b'] = 'half-page-up',
        ['ctrl-a'] = 'beginning-of-line',
        ['ctrl-e'] = 'end-of-line',
        ['alt-a'] = 'toggle-all',
        ['ctrl-space'] = 'toggle+down',
        ['shift-tab'] = 'toggle+up',
        ['alt-g'] = 'first',
        ['alt-G'] = 'last',
        ['f3'] = 'toggle-preview-wrap',
        ['f4'] = 'toggle-preview',
        ['shift-down'] = 'preview-page-down',
        ['shift-up'] = 'preview-page-up',
      },
    },
  })

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
  end, { desc = 'FZF search on lines' })

  vim.keymap.set('n', '<leader>fb', function() require('fzf-lua').buffers() end, { desc = 'FZF search on buffer list' })
  vim.keymap.set(
    'n',
    '<leader>fH',
    function() require('fzf-lua').highlights() end,
    { desc = 'FZF find highlight group' }
  )
  vim.keymap.set(
    'n',
    '<leader>fx',
    function() require('fzf-lua').lsp_document_diagnostics() end,
    { desc = 'FZF find document diagnostic' }
  )
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

      vim.keymap.set('n', 'grr', function() require('fzf-lua').lsp_references() end, { buffer = e.buf })
      vim.keymap.set('n', 'grt', function() require('fzf-lua').lsp_typedefs() end, { buffer = e.buf, remap = true })
      vim.keymap.set('n', 'gri', function() require('fzf-lua').lsp_implementations() end, { buffer = e.buf })
      vim.keymap.set('n', 'gO', function() require('fzf-lua').lsp_document_symbols() end, { buffer = e.buf })
      vim.keymap.set('n', 'grs', function() require('fzf-lua').lsp_workspace_symbols() end, { buffer = e.buf })
      vim.keymap.set('n', 'gd', function() require('fzf-lua').lsp_definitions({ jump1 = true }) end, { buffer = e.buf })

      vim.keymap.set(
        'n',
        'gD',
        function() require('fzf-lua').lsp_definitions({ jump1 = false }) end,
        { buffer = e.buf }
      )
    end,
  })
end)
