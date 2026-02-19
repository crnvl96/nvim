Config.later(function() require('mini.extra').setup() end)
Config.later(function() require('mini.visits').setup() end)
Config.later(function() require('mini.align').setup() end)
Config.later(function() require('mini.move').setup() end)
Config.later(function() require('mini.splitjoin').setup() end)
Config.later(function() require('mini.indentscope').setup() end)
Config.later(function() require('mini.comment').setup() end)
Config.later(function() require('mini.cmdline').setup() end)
Config.later(function() require('mini.bracketed').setup() end)

Config.now(function()
  -- We've setup this plugin at init.lua
  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
  MiniMisc.setup_termbg_sync()
end)

Config.now(function()
  vim.cmd.colorscheme('miniwinter')
  require('mini.colors').get_colorscheme():add_transparency({ general = false, float = true }):apply()
end)

Config.later(function()
  require('mini.completion').setup({
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = function(items, base)
        return MiniCompletion.default_process_items(items, base, { kind_priority = { Text = -1, Snippet = -1 } })
      end,
    },
  })
  vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })
  vim.api.nvim_create_autocmd('LspAttach', {
    group = Config.gr,
    callback = function(e) vim.bo[e.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end,
  })
end)

Config.later(
  function()
    require('mini.hipatterns').setup({
      highlighters = {
        hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
      },
    })
  end
)

Config.later(function()
  require('mini.jump2d').setup({
    spotter = require('mini.jump2d').gen_spotter.pattern('[^%s%p]+'),
    labels = 'asdfghjkl',
    view = {
      dim = true,
      n_steps_ahead = 2,
    },
  })
  vim.keymap.set({ 'n', 'x', 'o' }, 's', function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end)
end)

Config.later(
  function()
    require('mini.ai').setup({
      search_method = 'cover',
      custom_textobjects = {
        g = MiniExtra.gen_ai_spec.buffer(),
        f = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
        c = require('mini.ai').gen_spec.treesitter({ a = '@comment.outer', i = '@comment.inner' }),
        o = require('mini.ai').gen_spec.treesitter({ a = '@conditional.outer', i = '@conditional.inner' }),
        l = require('mini.ai').gen_spec.treesitter({ a = '@loop.outer', i = '@loop.inner' }),
      },
    })
  end
)

Config.later(function()
  require('mini.keymap').setup()
  MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
  MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
  MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept' })
end)

Config.later(function()
  require('mini.files').setup({
    mappings = {
      go_in = '',
      go_in_plus = '<CR>',
      go_out = '',
      go_out_plus = '-',
      mark_goto = 'g',
    },
    windows = {
      max_number = 3,
      preview = true,
      width_focus = 50,
      width_nofocus = 20,
      width_preview = 80,
    },
    content = {
      prefix = function() end,
    },
  })

  local show_dotfiles = true
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    group = Config.gr,
    callback = function(e)
      local buf = e.data.buf_id
      local filter_show = function() return true end
      local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, '.') end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        MiniFiles.refresh({ content = { filter = show_dotfiles and filter_show or filter_hide } })
      end

      vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf, desc = '[Un]show Dotfiles' })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesExplorerOpen',
    group = Config.gr,
    callback = function()
      MiniFiles.set_bookmark('c', vim.fn.stdpath('config'), { desc = 'Config' })
      MiniFiles.set_bookmark('@', vim.fn.stdpath('data') .. '/site/pack/core/opt', { desc = 'Plugins' })
      MiniFiles.set_bookmark('_', vim.fn.getcwd, { desc = 'Working directory' })
      MiniFiles.set_bookmark('n', vim.env.HOME .. '/Developer/personal/notes', { desc = 'Notes' })
      MiniFiles.set_bookmark('p', vim.env.HOME .. '/Developer/personal/presentations', { desc = 'Presentations' })
      MiniFiles.set_bookmark('e', vim.env.HOME .. '/Developer/personal', { desc = 'Personal projects' })
      MiniFiles.set_bookmark('w', vim.env.HOME .. '/Developer/work', { desc = 'Work projects' })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesExplorerClose',
    group = Config.gr,
    callback = function() MiniMisc.put('Root: ' .. MiniMisc.find_root() or nil) end,
  })

  -- stylua: ignore
  vim.keymap.set('n', '<Leader>ef', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<CR>', { desc = 'Explorer' })
end)

Config.later(function()
  require('mini.pick').setup({
    window = {
      prompt_prefix = '  ',
    },
    source = {
      show = require('mini.pick').default_show,
    },
  })

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(items, opts, on_choice)
    return MiniPick.ui_select(items, opts, on_choice, {
      window = {
        config = {
          relative = 'cursor',
          anchor = 'NW',
          row = 0,
          col = 0,
          width = 80,
          height = 15,
        },
      },
    })
  end

  MiniPick.registry.personal = function()
    local cwd = vim.fn.expand('~/Developer/personal')
    local choose = function(item)
      vim.schedule(function() MiniPick.builtin.files(nil, { source = { cwd = item.path } }) end)
    end
    return MiniExtra.pickers.explorer({ cwd = cwd }, { source = { choose = choose } })
  end

  MiniPick.registry.work = function()
    local cwd = vim.fn.expand('~/Developer/work')
    local choose = function(item)
      vim.schedule(function() MiniPick.builtin.files(nil, { source = { cwd = item.path } }) end)
    end
    return MiniExtra.pickers.explorer({ cwd = cwd }, { source = { choose = choose } })
  end

  -- stylua: ignore start
  vim.keymap.set('n', 'E', '<Cmd>lua vim.diagnostic.open_float()<CR>')
  vim.keymap.set('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
  vim.keymap.set('i', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
  vim.keymap.set('t', '<M-o>', '<Cmd>lua MiniPick.builtin.buffers({ include_current = false })<CR>')
  vim.keymap.set('n', '<Leader>fe', '<Cmd>Pick personal<CR>', { desc = 'Personal projects' })
  vim.keymap.set('n', '<Leader>fw', '<Cmd>Pick work<CR>', { desc = 'Work projects' })
  vim.keymap.set('n', '<Leader>ff', '<Cmd>Pick files<CR>', { desc = 'Files' })
  vim.keymap.set('n', '<Leader>fg', '<Cmd>Pick grep_live<CR>', { desc = 'Grep live' })
  vim.keymap.set('n', '<Leader>fr', '<Cmd>Pick resume<CR>', { desc = 'Resume' })
  vim.keymap.set('n', '<Leader>fb', '<Cmd>Pick buffers include_current=false<CR>', { desc = 'Buffers' })
  vim.keymap.set('n', '<Leader>fl', "<Cmd>Pick buf_lines scope='current' preserve_order=true<CR>", { desc = 'Lines' })
  vim.keymap.set('n', '<Leader>fq', "<Cmd>Pick list scope='quickfix'<CR>", { desc = 'Quickfix' })
  vim.keymap.set('n', '<Leader>fk', '<Cmd>Pick keymaps<CR>', { desc = 'Keymaps' })
  vim.keymap.set('n', '<Leader>fH', '<Cmd>Pick hl_groups<CR>', { desc = 'Highlights' })
  vim.keymap.set('n', '<Leader>fd', '<Cmd>Pick diagnostic<CR>', { desc = 'Diagnostics' })
  vim.keymap.set('n', '<Leader>fc', '<Cmd>Pick commands<CR>', { desc = 'Commands' })
  vim.keymap.set('n', '<Leader>fh', "<Cmd>Pick help default_split='vertical'<CR>", { desc = 'Help files' })
  vim.keymap.set('n', '<Leader>fm', '<Cmd>Pick manpages<CR>', { desc = 'Search manpages' })
  vim.keymap.set('n', '<Leader>fo', '<Cmd>Pick visit_paths preserve_order=true<CR>', { desc = 'Oldfiles' })
  vim.keymap.set('n', '<Leader>lD', "<Cmd>Pick lsp scope='declaration'<CR>", { desc = 'Declarations' })
  vim.keymap.set('n', '<Leader>ld', "<Cmd>Pick lsp scope='definition'<CR>", { desc = 'Definitions' })
  vim.keymap.set('n', '<Leader>ls', "<Cmd>Pick lsp scope='document_symbol'<CR>", { desc = 'Document Symbols' })
  vim.keymap.set('n', '<Leader>lS', "<Cmd>Pick lsp scope='workspace_symbol_live'<CR>", { desc = 'Workspace symbols' })
  vim.keymap.set('n', '<Leader>li', "<Cmd>Pick lsp scope='implementation'<CR>", { desc = 'Implementations' })
  vim.keymap.set('n', '<Leader>lr', "<Cmd>Pick lsp scope='references'<CR>", { desc = 'References' })
  vim.keymap.set('n', '<Leader>lt', "<Cmd>Pick lsp scope='type_definition'<CR>", { desc = 'Typedefs' })
  vim.keymap.set('n', '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'Code actions' })
  vim.keymap.set('n', '<Leader>ln', '<Cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'Rename' })
  -- stylua: ignore end
end)

Config.later(
  function()
    require('mini.clue').setup({
      triggers = {
        { mode = 'n', keys = '\\' },
        { mode = 'i', keys = '<C-x>' },
        { mode = 'n', keys = '<C-w>' },
        { mode = { 'n', 'x' }, keys = '<Leader>' },
        { mode = { 'n', 'x' }, keys = '[' },
        { mode = { 'n', 'x' }, keys = ']' },
        { mode = { 'n', 'x' }, keys = 'g' },
        { mode = { 'n', 'x' }, keys = "'" },
        { mode = { 'n', 'x' }, keys = '`' },
        { mode = { 'n', 'x' }, keys = '"' },
        { mode = { 'i', 'c' }, keys = '<C-r>' },
        { mode = { 'n', 'x' }, keys = 'z' },
      },
      clues = {
        { mode = { 'n' }, keys = '<leader>e', desc = '+explorer' },
        { mode = { 'n', 'x' }, keys = '<leader>f', desc = '+find' },
        { mode = { 'n', 'x' }, keys = '<leader>l', desc = '+lsp' },
        require('mini.clue').gen_clues.builtin_completion(),
        require('mini.clue').gen_clues.g(),
        require('mini.clue').gen_clues.marks(),
        require('mini.clue').gen_clues.registers(),
        require('mini.clue').gen_clues.square_brackets(),
        require('mini.clue').gen_clues.windows(),
        require('mini.clue').gen_clues.z(),
      },
      window = {
        delay = 500,
        scroll_down = '<C-f>',
        scroll_up = '<C-b>',
        config = {
          width = 'auto',
        },
      },
    })
  end
)
