return {
  'echasnovski/mini.ai',
  event = 'VeryLazy',
  opts = function()
    local ai = require('mini.ai')
    local gen_ai_spec = require('mini.extra').gen_ai_spec

    return {
      n_lines = 500,
      custom_textobjects = {
        o = ai.gen_spec.treesitter({
          a = { '@block.outer', '@conditional.outer', '@loop.outer' },
          i = { '@block.inner', '@conditional.inner', '@loop.inner' },
        }),
        f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
        c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
        t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
        e = {
          { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
          '^().*()$',
        },
        g = gen_ai_spec.buffer(),
        d = gen_ai_spec.diagnostic(),
        i = gen_ai_spec.indent(),
        l = gen_ai_spec.line(),
        n = gen_ai_spec.number(),
        u = ai.gen_spec.function_call(),
        U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }),
      },
    }
  end,
  config = function(_, opts)
    require('mini.ai').setup(opts)

    local objects = {
      { ' ', desc = 'whitespace' },
      { '"', desc = '" string' },
      { "'", desc = "' string" },
      { '(', desc = '() block' },
      { ')', desc = '() block with ws' },
      { '<', desc = '<> block' },
      { '>', desc = '<> block with ws' },
      { '?', desc = 'user prompt' },
      { 'U', desc = 'use/call without dot' },
      { '[', desc = '[] block' },
      { ']', desc = '[] block with ws' },
      { '_', desc = 'underscore' },
      { '`', desc = '` string' },
      { 'a', desc = 'argument' },
      { 'b', desc = ')]} block' },
      { 'c', desc = 'class' },
      { 'd', desc = 'diagnostic' },
      { 'e', desc = 'CamelCase / snake_case' },
      { 'f', desc = 'function' },
      { 'g', desc = 'entire file' },
      { 'i', desc = 'indent' },
      { 'l', desc = 'line' },
      { 'n', desc = 'number' },
      { 'o', desc = 'block, conditional, loop' },
      { 'q', desc = 'quote `"\'' },
      { 't', desc = 'tag' },
      { 'u', desc = 'use/call' },
      { '{', desc = '{} block' },
      { '}', desc = '{} with ws' },
    }

    local ret = { mode = { 'o', 'x' } }

    local mappings = {
      around = 'a',
      inside = 'i',
      around_next = 'an',
      inside_next = 'in',
      around_last = 'al',
      inside_last = 'il',
    }

    mappings.goto_left = nil
    mappings.goto_right = nil

    for name, prefix in pairs(mappings) do
      name = name:gsub('^around_', ''):gsub('^inside_', '')
      ret[#ret + 1] = { prefix, group = name }
      for _, obj in ipairs(objects) do
        local desc = obj.desc
        if prefix:sub(1, 1) == 'i' then desc = desc:gsub(' with ws', '') end
        ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
      end
    end

    require('which-key').add(ret, { notify = false })
  end,
}
