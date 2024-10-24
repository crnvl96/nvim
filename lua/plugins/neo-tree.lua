return {
  'nvim-neo-tree/neo-tree.nvim',
  cmd = 'Neotree',
  branch = 'v3.x',
  init = function()
    -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
    -- because `cwd` is not set up properly.
    au('BufEnter', {
      group = group('Neotree_start_directory', { clear = true }),
      desc = 'Start Neo-tree with directory',
      once = true,
      callback = function()
        if package.loaded['neo-tree'] then
          return
        else
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats and stats.type == 'directory' then require('neo-tree') end
        end
      end,
    })
  end,
  opts = function()
    return {
      sources = { 'filesystem', 'buffers', 'git_status' },
      open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf' },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      event_handlers = {
        -- Auto rename file imports/usages on these events
        {
          event = require('neo-tree.events').FILE_MOVED,
          handler = function(data) Snacks.rename.on_rename_file(data.source, data.destination) end,
        },
        {
          event = require('neo-tree.events').FILE_RENAMED,
          handler = function(data) Snacks.rename.on_rename_file(data.source, data.destination) end,
        },
      },
      window = {
        mappings = {
          ['l'] = 'open',
          ['h'] = 'close_node',
          ['<space>'] = 'none',
          ['Y'] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg('+', path, 'c')
            end,
            desc = 'Copy Path to Clipboard',
          },
          ['O'] = {
            function(state) require('lazy.util').open(state.tree:get_node().path, { system = true }) end,
            desc = 'Open with System Application',
          },
          ['P'] = { 'toggle_preview', config = { use_float = true } },
        },
      },
    }
  end,
  config = function(_, opts)
    require('neo-tree').setup(opts)

    vim.api.nvim_create_autocmd('TermClose', {
      pattern = '*lazygit',
      callback = function()
        if package.loaded['neo-tree.sources.git_status'] then require('neo-tree.sources.git_status').refresh() end
      end,
    })
  end,
  keys = {
    {
      '-',
      function()
        local exec = require('neo-tree.command').execute
        local opts = { toggle = true, dir = vim.uv.cwd() }

        exec(opts)
      end,
      desc = 'explorer',
    },
    {
      '<leader>gs',
      function()
        local exec = require('neo-tree.command').execute
        local opts = { toggle = true, source = 'git_status' }

        exec(opts)
      end,
      desc = 'git',
    },
  },
}
