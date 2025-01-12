_G.Clues = {
  clues = {
    { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
    { mode = 'n', keys = '<Leader>c', desc = '+CodeCompanion' },
    { mode = 'n', keys = '<Leader>c', desc = '+CodeCompanion' },
    { mode = 'n', keys = '<Leader>d', desc = '+Debug' },
    { mode = 'n', keys = '<Leader>f', desc = '+Files' },
    { mode = 'n', keys = '<Leader>g', desc = '+Git' },
    { mode = 'x', keys = '<Leader>g', desc = '+Git' },
    { mode = 'n', keys = '<Leader>i', desc = '+Iron' },
    { mode = 'x', keys = '<Leader>i', desc = '+Iron' },
    { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
    { mode = 'n', keys = '<Leader>n', desc = '+Notification' },
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
}

_G.Deck = {
  git = function() require('deck').start(require('deck.builtin.source.git')({ cwd = vim.uv.cwd() })) end,
  resume = function()
    local ctx = require('deck').get_history()[1]
    if ctx then ctx.show() end
  end,
  lines = function()
    require('deck').start(require('deck.builtin.source.lines')({
      bufnrs = { vim.api.nvim_get_current_buf() },
    }))
  end,
  files = function()
    require('deck').start({
      require('deck.builtin.source.files')({
        root_dir = vim.uv.cwd(),
        ignore_globs = {
          '**/node_modules/**',
          '**/.git/**',
        },
      }),
    })
  end,
  buffers = function()
    require('deck').start({
      require('deck.builtin.source.buffers')(),
    })
  end,
  help = function() require('deck').start(require('deck.builtin.source.helpgrep')()) end,
  oldfiles = function()
    require('deck').start({
      require('deck.builtin.source.recent_files')(),
    })
  end,
  grep = function()
    require('deck').start(require('deck.builtin.source.grep')({
      dynamic = true,
      root_dir = vim.uv.cwd(),
      ignore_globs = {
        '**/node_modules/**',
        '**/.git/**',
      },
    }))
  end,
  diagnostics = function()
    local bufnr = vim.api.nvim_get_current_buf()

    local severity = { 'ERROR', 'WARN', 'HINT', 'INFO' }

    local diags = vim.diagnostic.get(bufnr, severity)
    table.sort(diags, function(a, b) return a.severity < b.severity end)

    local filename = vim.api.nvim_buf_get_name(bufnr)

    if not diags or #diags == 0 then
      vim.print('No diagnostics for this buffer.')
      return
    end

    require('deck').start({
      name = 'buffer diagnostics',
      execute = function(ctx)
        local bufname = vim.fn.fnamemodify(filename, ':t')

        for _, diag in ipairs(diags) do
          ctx.item({
            data = {
              filename = filename,
              bufname = bufname,
              bufnr = diag.bufnr,
              lnum = diag.lnum + 1,
              col = diag.col,
              diagnostics = diag,
            },
            display_text = {
              { ('(%s:%s): %s'):format(diag.lnum + 1, diag.col + 1, diag.message) },
            },
          })
        end
        ctx.done()
      end,
      actions = {
        require('deck').alias_action('default', 'open'),
      },
      decorators = {
        {
          name = 'diagnostics',
          resolve = function(_, item) return item.data.diagnostics end,
          decorate = function(_, item, row)
            local icons = {
              [vim.diagnostic.severity.ERROR] = 'E',
              [vim.diagnostic.severity.WARN] = 'W',
              [vim.diagnostic.severity.HINT] = 'H',
              [vim.diagnostic.severity.INFO] = 'I',
            }

            local hls = {
              [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
              [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
              [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
              [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
            }

            local bufname = item.data.bufname
            local icon = icons[item.data.diagnostics.severity]
            local hl = hls[item.data.diagnostics.severity]

            return {
              {
                row = row,
                col = 0,
                virt_text = { { '  ' .. icon .. '  ', hl } },
                virt_text_pos = 'inline',
              },
              {
                row = row,
                col = 0,
                virt_text = { { bufname, 'Comment' } },
                virt_text_pos = 'right_align',
              },
            }
          end,
        },
      },
    })
  end,
  lsp = function()
    local deck = require('deck')

    local decorator = {
      name = 'lsp_decorator',
      decorate = function(_, item, row)
        local relfilename = vim.fn.fnamemodify(item.data.filename, ':~:.')
        local filename = vim.fn.fnamemodify(item.data.filename, ':t')
        local dirname = vim.fn.fnamemodify(relfilename, ':r')
        return {
          {
            row = row,
            virt_text = {
              { dirname .. '/', 'Comment' },
              { filename, 'Special' },
              { ':' .. item.data.lnum .. ':' .. item.data.col, 'Number' },
              { item.data.text, 'Normal' },
            },
            virt_text_pos = 'overlay',
          },
        }
      end,
    }

    local function create_lsp_references_source()
      return {
        name = 'lsp_references',
        dynamic = false,
        execute = function(ctx)
          local bufnr = vim.api.nvim_get_current_buf()
          local params = vim.lsp.util.make_position_params(0, vim.lsp.util._get_offset_encoding(bufnr))
          params.context = { includeDeclaration = true }

          local clients = vim.lsp.get_clients({ bufnr = 0, method = 'textDocument/references' })

          if #clients == 0 then
            vim.notify('No LSP clients support textDocument/references')
            ctx.done()
            return
          end

          clients[1].request('textDocument/references', params, function(_, result)
            if not result then
              ctx.done()
              return
            end

            for _, location in ipairs(result) do
              local filename = vim.uri_to_fname(location.uri)
              local range = location.range

              -- Get the line content if the file exists
              local line_text = ''
              local lines = vim.fn.readfile(filename)
              if lines and #lines >= (range.start.line + 1) then
                line_text = ' ' .. vim.trim(lines[range.start.line + 1])
              end

              ctx.item({
                display_text = string.format(
                  '%s:%d:%d',
                  vim.fn.fnamemodify(filename, ':~:.'),
                  range.start.line + 1,
                  range.start.character + 1
                ),
                data = {
                  filename = filename,
                  lnum = range.start.line + 1,
                  col = range.start.character + 1,
                  text = line_text,
                },
              })
            end
            ctx.done()
          end, bufnr)
        end,
        actions = { require('deck').alias_action('default', 'open') },
        decorators = { decorator },
      }
    end

    local function create_lsp_source(method, name)
      return {
        name = 'lsp_' .. name,
        dynamic = false,
        execute = function(ctx)
          local bufnr = vim.api.nvim_get_current_buf()
          local params = vim.lsp.util.make_position_params(0, vim.lsp.util._get_offset_encoding(bufnr))

          vim.lsp.buf_request_all(0, method, params, function(results)
            if not results or vim.tbl_isempty(results) then return ctx.done() end

            for _, result in pairs(results) do
              if result.result then
                local locations = vim.tbl_islist(result.result) and result.result or { result.result }

                for _, location in ipairs(locations) do
                  local uri = location.uri or location.targetUri
                  local range = location.range or location.targetRange
                  local filename = vim.uri_to_fname(uri)

                  -- Get the line content if the file exists
                  local line_text = ''
                  local lines = vim.fn.readfile(filename)
                  if lines and #lines >= (range.start.line + 1) then
                    line_text = ' ' .. vim.trim(lines[range.start.line + 1])
                  end

                  ctx.item({
                    display_text = string.format('%s:%d', vim.fn.fnamemodify(filename, ':~:.'), range.start.line + 1),
                    data = {
                      filename = filename,
                      lnum = range.start.line + 1,
                      col = range.start.character + 1,
                      text = line_text,
                    },
                  })
                end
              end
            end

            ctx.done()
          end)
        end,
        actions = {
          require('deck').alias_action('default', 'open'),
        },
        decorators = { decorator },
      }
    end

    local sources = {
      definitions = create_lsp_source('textDocument/definition', 'definitions'),
      implementations = create_lsp_source('textDocument/implementation', 'implementations'),
      type_definitions = create_lsp_source('textDocument/typeDefinition', 'type_definitions'),
    }

    local function show_references() deck.start(create_lsp_references_source(), { name = 'LSP References' }) end

    local function show_lsp_source(source, display_name)
      return function() deck.start(source, { name = 'LSP ' .. display_name }) end
    end

    return {
      definition = show_lsp_source(sources.definitions, 'Definitions'),
      implementations = show_lsp_source(sources.implementations, 'Implementations'),
      typedefinitions = show_lsp_source(sources.type_definitions, 'Type Definitions'),
      references = show_references,
    }
  end,
  keymaps = function()
    local function get_all_keymaps()
      local maps = {}
      local modes = { 'n', 'i', 'v', 'x', 'o' }

      for _, mode in ipairs(modes) do
        local mode_maps = vim.api.nvim_get_keymap(mode)
        for _, map in ipairs(mode_maps) do
          local lhs = map.lhs
          if lhs ~= nil and lhs:sub(1, 1) == ' ' then lhs = '<Leader>' .. lhs:sub(2) end

          map['display_text'] =
            string.format('%s | %s → %s %s', mode, lhs, map.rhs or '', map.desc and ('(' .. map.desc .. ')') or '')
          table.insert(maps, map)
        end
      end

      -- Get buffer-local keymaps for current buffer
      local bufnr = vim.api.nvim_get_current_buf()
      for _, mode in ipairs(modes) do
        local buf_maps = vim.api.nvim_buf_get_keymap(bufnr, mode)
        for _, map in ipairs(buf_maps) do
          local lhs = map.lhs
          if lhs ~= nil and lhs:sub(1, 1) == ' ' then lhs = '<Leader>' .. lhs:sub(2) end

          map['display_text'] = string.format(
            '%s | %s → %s %s (buffer)',
            mode,
            lhs,
            map.rhs or '',
            map.desc and ('(' .. map.desc .. ')') or ''
          )
          table.insert(maps, map)
        end
      end

      return maps
    end

    local ok, deck = pcall(require, 'deck')
    if not ok then
      vim.notify('nvim-deck is not installed', vim.log.levels.ERROR)
      return
    end

    local maps = get_all_keymaps()

    deck.start({
      name = 'Mappings',
      execute = function(ctx)
        for _, map in ipairs(maps) do
          ctx.item(map)
        end
        ctx.done()
      end,
      actions = {
        {
          name = 'default',
          resolve = function(ctx)
            -- Action is available only if there is exactly one action item with a key map.
            local is_resolve = #ctx.get_action_items() == 1 and ctx.get_action_items()[1].lhs
            return is_resolve
          end,
          execute = function(ctx)
            ctx.hide()
            local lhs = ctx.get_action_items()[1].lhs
            local keys = vim.api.nvim_replace_termcodes(lhs, true, true, true)
            vim.api.nvim_feedkeys(keys, 'm', false)
          end,
        },
      },
    })
  end,
}

_G.Treesitter = {
  parsers = {
    'c',
    'vim',
    'vimdoc',
    'query',
    'markdown',
    'markdown_inline',

    -- lua
    'lua',

    -- js/ts
    'javascript',
    'typescript',
    'tsx',

    -- python
    'python',
  },
}
