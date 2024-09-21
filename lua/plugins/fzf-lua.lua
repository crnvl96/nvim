return {
  'ibhagwan/fzf-lua',
  cmd = 'FzfLua',
  opts = {
    fzf_opts = {
      ['--info'] = 'default',
      ['--layout'] = 'reverse-list',
      ['--cycle'] = '',
    },
    defaults = { file_icons = 'mini' },
    winopts = {
      preview = {
        scrollbar = false,
        hidden = 'hidden',
        vertical = 'up:70%',
        layout = 'vertical',
      },
    },
    keymap = {
      fzf = {
        true,
        ['ctrl-d'] = 'half-page-down',
        ['ctrl-u'] = 'half-page-up',
        ['ctrl-f'] = 'preview-page-down',
        ['ctrl-b'] = 'preview-page-up',
        ['ctrl-a'] = 'select-all',
        ['ctrl-o'] = 'toggle-all',
      },
    },
    grep = { rg_glob = true },
    oldfiles = { include_current_session = true },
  },
  config = function(_, opts)
    local fzf = require('fzf-lua')

    fzf.setup(opts)
    fzf.register_ui_select()
  end,
  keys = function()
    local fzf = require('fzf-lua')
    local l = function(map) return '<leader>' .. map end

    return {
      { l('f<space>'), '<cmd>FzfLua<CR>', desc = 'menu' },
      { l('fl'), function() fzf.lgrep_curbuf() end, desc = 'grep buffer' },
      { l('f>'), function() fzf.resume() end, desc = 'resume' },
      { l('fk'), function() fzf.keymaps() end, desc = 'maps' },
      { l('fc'), function() fzf.highlights() end, desc = 'highlights' },
      { l('ff'), function() fzf.files({ cwd_prompt = false }) end, desc = 'files' },
      { l('fo'), function() fzf.oldfiles() end, desc = 'oldfiles' },
      { l('fh'), function() fzf.help_tags() end, desc = 'help' },
      { l('fg'), function() fzf.live_grep_native() end, desc = 'grep' },
      { l('fg'), function() fzf.grep_visual() end, desc = 'grep visual', mode = 'x' },
      { l('fr'), function() fzf.live_grep_resume() end, desc = 'resume grep' },
      { l('fx'), function() fzf.quickfix() end, desc = 'qf' },
    }
  end,
}
