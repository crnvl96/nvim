vim.pack.add({ 'https://github.com/ibhagwan/fzf-lua' })

local actions = require('fzf-lua.actions')

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(items, opts, on_choice)
  local ui_select = require('fzf-lua.providers.ui_select')
  if not ui_select.is_registered() then
    ui_select.register(function(ui_opts)
      ui_opts.winopts = { height = 0.5, width = 0.4 }
      -- Use the kind (if available) to set the previewer's title.
      if ui_opts.kind then ui_opts.winopts.title = string.format(' %s ', ui_opts.kind) end
      -- Ensure that there's a space at the end of the prompt.
      if ui_opts.prompt and not vim.endswith(ui_opts.prompt, ' ') then ui_opts.prompt = ui_opts.prompt .. ' ' end
      return ui_opts
    end)
  end
  -- Don't show the picker if there's nothing to pick.
  if #items > 0 then return vim.ui.select(items, opts, on_choice) end
end

require('fzf-lua').setup({
  { 'border-fused', 'hide' },
  -- Make stuff better combine with the editor.
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
    ['--cycle'] = '',
  },
  keymap = {
    builtin = {
      ['<C-/>'] = 'toggle-help',
      ['<C-a>'] = 'toggle-fullscreen',
      ['<C-i>'] = 'toggle-preview',
    },
    fzf = {
      ['alt-s'] = 'toggle',
      ['alt-a'] = 'toggle-all',
      ['ctrl-i'] = 'toggle-preview',
    },
  },
  winopts = {
    height = 0.7,
    width = 0.55,
    preview = {
      scrollbar = false,
      layout = 'vertical',
      vertical = 'up:40%',
    },
  },
  defaults = { git_icons = false },
  previewers = {
    codeaction = { toggle_behavior = 'extend' },
  },
  -- Configuration for specific commands.
  files = {
    winopts = {
      preview = { hidden = true },
    },
  },
  grep = {
    -- Search in hidden files by default.
    hidden = true,
    rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g "!.git" -e',
    rg_glob_fn = function(query, opts)
      local regex, flags = query:match(string.format('^(.*)%s(.*)$', opts.glob_separator))
      -- Return the original query if there's no separator.
      return (regex or query), flags
    end,
  },
  helptags = {
    actions = {
      -- Open help pages in a vertical split.
      ['enter'] = actions.help_vert,
    },
  },
  lsp = {
    code_actions = {
      winopts = {
        width = 70,
        height = 20,
        relative = 'cursor',
        preview = {
          hidden = true,
          vertical = 'down:50%',
        },
      },
    },
  },
  diagnostics = {
    -- Remove the dashed line between diagnostic items.
    multiline = 1,
    actions = {
      ['ctrl-e'] = {
        fn = function(_, opts)
          -- If not filtering by severity, show all diagnostics.
          if opts.severity_only then
            opts.severity_only = nil
          else
            -- Else only show errors.
            opts.severity_only = vim.diagnostic.severity.ERROR
          end
          require('fzf-lua').resume(opts)
        end,
        noclose = true,
        desc = 'toggle-all-only-errors',
        header = function(opts) return opts.severity_only and 'show all' or 'show only errors' end,
      },
    },
  },
  oldfiles = {
    include_current_session = true,
    winopts = {
      preview = { hidden = true },
    },
  },
})

Config.set('i', '<C-x><C-f>', Config.file_completion_fzf, { desc = 'Fuzzy complete path' })
Config.set('n', '<leader>fH', '<cmd>FzfLua highlights<cr>', { desc = 'Highlights' })
Config.set('n', '<leader>fb', '<cmd>FzfLua buffers<cr>', { desc = 'Buffers' })
Config.set('n', '<leader>fd', '<cmd>FzfLua lsp_document_diagnostics<cr>', { desc = 'Document diagnostics' })
Config.set('n', '<leader>fD', '<cmd>FzfLua lsp_workspace_diagnostics<cr>', { desc = 'Workspace diagnostics' })
Config.set('n', '<leader>ff', '<cmd>FzfLua files<cr>', { desc = 'Files [fzf]' })
Config.set('n', '<leader>fg', '<cmd>FzfLua live_grep<cr>', { desc = 'Grep [fzf]' })
Config.set('n', '<leader>fh', '<cmd>FzfLua help_tags<cr>', { desc = 'Help [fzf]' })
Config.set('n', '<leader>fo', '<cmd>FzfLua oldfiles<cr>', { desc = 'Recently opened files' })
Config.set('n', '<leader>fr', '<cmd>FzfLua resume<cr>', { desc = 'Resume last fzf command' })
Config.set('x', '<leader>fg', '<cmd>FzfLua grep_visual<cr>', { desc = 'Grep [fzf]' })
Config.set({ 'n', 'x' }, '<Leader>fl', Config.grep_blines_fzf, { desc = 'Grep buffer [fzf]' })

Config.set('n', '<leader>lr', '<cmd>FzfLua lsp_references<cr>', { desc = 'LSP references' })
Config.set('n', '<leader>ld', '<cmd>FzfLua lsp_definitions<cr>', { desc = 'LSP definitions' })
Config.set('n', '<leader>lt', '<cmd>FzfLua lsp_typedefs<cr>', { desc = 'LSP typedefs' })
Config.set('n', '<leader>li', '<cmd>FzfLua lsp_implementations<cr>', { desc = 'LSP implementations' })
Config.set('n', '<leader>lO', '<cmd>FzfLua lsp_document_symbols<cr>', { desc = 'LSP document symbols' })
