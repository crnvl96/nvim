local H = {}

vim.ui.select = function(items, opts, on_choice)
  local win = vim.api.nvim_get_current_win()
  local format_fn = opts.format_item or H.item_to_string

  local list = {}
  for i = 1, #items do
    table.insert(list, { text = format_fn(items[i]), index = i, item = items[i] })
  end

  require('deck').start({
    name = 'UI select',
    execute = function(ctx)
      for _, item in ipairs(list) do
        ctx.item({
          display_text = item.text,
          index = item.index,
          item = item.item,
        })
      end

      ctx.done()
    end,
    actions = {
      {
        name = 'default',
        resolve = function(ctx) return #ctx.get_action_items() == 1 and ctx.get_action_items()[1].index end,
        execute = function(ctx)
          local item = ctx.get_cursor_item()
          if item == nil then return end
          vim.api.nvim_win_call(win, function() on_choice(item.item, item.index) end)
          ctx.hide()
        end,
      },
    },
    previewers = {
      {
        name = 'UI select',
        resolve = function(ctx) return #ctx.get_action_items() == 1 and ctx.get_action_items()[1].index end,
        preview = function(_, item, env)
          vim.api.nvim_win_call(env.win, function()
            local buf = vim.api.nvim_win_get_buf(env.win)
            local preview_item = vim.is_callable(opts.preview) and opts.preview
              or function(x) return vim.split(vim.inspect(x), '\n') end
            pcall(vim.api.nvim_buf_set_lines, buf, 0, -1, false, preview_item(item.item))
          end)
        end,
      },
    },
  })
end

--
-- Helpers
--

function H.expand(x, ...)
  if vim.is_callable(x) then return x(...) end
  return x
end

function H.item_to_string(item)
  item = H.expand(item)
  if type(item) == 'string' then return item end
  if type(item) == 'table' and type(item.text) == 'string' then return item.text end
  return vim.inspect(item, { newline = ' ', indent = '' })
end
