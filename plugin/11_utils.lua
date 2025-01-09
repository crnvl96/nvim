_G.Hooks = {}
_G.Config = {}

--
-- Hooks
--

Hooks.mkdp = {
  post_checkout = function()
    MiniDeps.later(function() vim.fn['mkdp#util#install']() end)
  end,
  post_install = function()
    MiniDeps.later(function() vim.fn['mkdp#util#install']() end)
  end,
}

Hooks.fzf = {
  post_checkout = function()
    MiniDeps.later(function() vim.fn['fzf#install']() end)
  end,
  post_install = function()
    MiniDeps.later(function() vim.fn['fzf#install']() end)
  end,
}

Hooks.blink = {
  post_checkout = function(params) Config.build(params, { 'cargo', 'build', '--release' }) end,
  post_install = function(params) Config.build(params, { 'cargo', 'build', '--release' }) end,
}

--
-- Config
--

function Config.build(params, build_cmd)
  vim.notify('Building ' .. params.name, vim.log.levels.INFO)
  local obj = vim.system(build_cmd, { cwd = params.path }):wait()
  if obj.code == 0 then
    vim.notify('Building ' .. params.name .. ' done', vim.log.levels.INFO)
  else
    vim.notify('Building ' .. params.name .. ' failed', vim.log.levels.ERROR)
  end
end

function Config.qftf(info)
  local items
  local ret = {}

  if info.quickfix == 1 then
    items = vim.fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end

  local limit = 62
  local fnameFmt1, fnameFmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
  local validFmt = '%s │%5d:%-3d│%s %s'

  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ''
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = vim.fn.bufname(e.bufnr)
        if fname == '' then
          fname = '[No Name]'
        else
          fname = fname:gsub('^' .. vim.env.HOME, '~')
        end
        -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
        if #fname <= limit then
          fname = fnameFmt1:format(fname)
        else
          fname = fnameFmt2:format(fname:sub(1 - limit))
        end
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
      str = validFmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end

  return ret
end
